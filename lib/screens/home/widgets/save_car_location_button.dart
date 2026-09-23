import 'package:flutter/material.dart';

class SaveCarLocationButton extends StatelessWidget {
  const SaveCarLocationButton({
    super.key,
    required this.saving,
    required this.onSave,
  });

  final bool saving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(60),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      onPressed: saving ? null : onSave,
      icon: saving
          ? SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: scheme.secondary,
              ),
            )
          : Icon(Icons.add_location_alt_rounded, color: scheme.secondary),
      label: const Text('Salvar local do carro'),
    );
  }
}
