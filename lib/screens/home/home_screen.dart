import 'package:flutter/material.dart';

import '../../controllers/parking_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../models/car_location.dart';
import '../../services/navigation_launcher.dart';
import 'dialogs/history_dialog.dart';
import 'dialogs/navigation_app_sheet.dart';
import 'dialogs/save_flow_dialogs.dart';
import 'dialogs/theme_sheet.dart';
import 'widgets/empty_state.dart';
import 'widgets/home_actions.dart';
import 'widgets/spot_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.controller,
    required this.themeController,
    required this.navigation,
  });

  final ParkingController controller;
  final ThemeController themeController;
  final NavigationLauncher navigation;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _saving = false;

  ParkingController get _controller => widget.controller;

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _saveSpot() async {
    if (_controller.needsOverwriteConfirmation &&
        !await confirmOverwrite(context)) {
      return;
    }

    setState(() => _saving = true);
    try {
      final coordinates = await _controller.captureCoordinates();
      if (!mounted) return;
      if (coordinates == null) {
        _showMessage(
          'Localização indisponível. Você pode salvar com foto e/ou nota.',
        );
      }

      String? photo;
      final wantsPhoto = await askToTakePhoto(context);
      if (!mounted) return;
      if (wantsPhoto) {
        photo = await _controller.takePhoto();
        if (!mounted) return;
        if (photo == null) _showMessage('Foto não salva.');
      }

      final note = await askForNote(context);
      if (!mounted) return;

      if (coordinates == null && photo == null && note == null) {
        _showMessage('Nada foi salvo: sem GPS, adicione uma foto ou uma nota.');
        return;
      }

      await _controller.save(
        coordinates: coordinates,
        photoFileName: photo,
        note: note,
      );
      if (!mounted) return;
      _showMessage('Local do carro salvo!');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _navigate(Coordinates coordinates) async {
    final opened = await showNavigationAppSheet(
      context,
      coordinates: coordinates,
      navigation: widget.navigation,
    );
    if (opened == false && mounted) {
      _showMessage('Não foi possível abrir o app de navegação.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Text('Onde Estacionei'),
        actions: [
          IconButton(
            tooltip: 'Aparência',
            onPressed: () => showThemeSheet(context, widget.themeController),
            icon: const Icon(Icons.palette_outlined),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Histórico',
            onPressed: () => showHistoryDialog(
              context,
              history: _controller.history,
              photoFile: _controller.photoFile,
            ),
            icon: const Icon(Icons.history_rounded),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final current = _controller.current;
          return Column(
            crossAxisAlignment: .stretch,
            children: [
              Expanded(
                child: current == null
                    ? const EmptyState()
                    : SpotDetails(location: current, controller: _controller),
              ),
              HomeActions(
                location: current,
                saving: _saving,
                onSave: _saveSpot,
                onNavigate: _navigate,
                onMarkVisited: _controller.markVisited,
              ),
            ],
          );
        },
      ),
    );
  }
}
