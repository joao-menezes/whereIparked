import 'package:flutter/material.dart';

import '../../../models/car_location.dart';
import '../../../widgets/text_button_generic.dart';
import 'save_car_location_button.dart';

class HomeActions extends StatelessWidget {
  const HomeActions({
    super.key,
    required this.location,
    required this.saving,
    required this.onSave,
    required this.onNavigate,
    required this.onMarkVisited,
  });

  final CarLocation? location;
  final bool saving;
  final VoidCallback onSave;
  final ValueChanged<Coordinates> onNavigate;
  final VoidCallback onMarkVisited;

  @override
  Widget build(BuildContext context) {
    final coordinates = location?.coordinates;
    final canMarkVisited = location != null && !location!.visited;

    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (coordinates != null && canMarkVisited) ...[
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: scheme.secondary,
                    foregroundColor: scheme.onSecondary,
                  ),
                  onPressed: () => onNavigate(coordinates),
                  icon: const Icon(Icons.directions_walk_rounded),
                  label: const Text('Me leve até lá'),
                ),
                const SizedBox(height: 10),
              ],
              SaveCarLocationButton(saving: saving, onSave: onSave),
              if (canMarkVisited) ...[
                const SizedBox(height: 2),
                TextButtonGeneric(onMarkVisited, 'Já encontrei meu carro'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
