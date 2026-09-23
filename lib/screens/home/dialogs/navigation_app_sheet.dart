import 'package:flutter/material.dart';

import '../../../models/car_location.dart';
import '../../../services/navigation_launcher.dart';

Future<bool?> showNavigationAppSheet(
  BuildContext context, {
  required Coordinates coordinates,
  required NavigationLauncher navigation,
}) async {
  final launch = await showModalBottomSheet<Future<bool>>(
    context: context,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Column(
          mainAxisSize: .min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Abrir com',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            _AppTile(
              icon: Icons.map_rounded,
              label: 'Google Maps',
              onTap: () => Navigator.pop(
                context,
                navigation.openGoogleMaps(coordinates),
              ),
            ),
            _AppTile(
              icon: Icons.navigation_rounded,
              label: 'Waze',
              onTap: () =>
                  Navigator.pop(context, navigation.openWaze(coordinates)),
            ),
          ],
        ),
      ),
    ),
  );
  return launch == null ? null : await launch;
}

class _AppTile extends StatelessWidget {
  const _AppTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: scheme.secondary.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: scheme.secondary),
      ),
      title: Text(label, style: Theme.of(context).textTheme.titleMedium),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: scheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}
