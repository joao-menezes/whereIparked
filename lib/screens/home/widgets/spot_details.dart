import 'package:flutter/material.dart';

import '../../../controllers/parking_controller.dart';
import '../../../models/car_location.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/date_format.dart';
import '../../photo_viewer_screen.dart';
import 'spot_map.dart';

class SpotDetails extends StatelessWidget {
  const SpotDetails({
    super.key,
    required this.location,
    required this.controller,
  });

  final CarLocation location;
  final ParkingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final coordinates = location.coordinates;
    final photo = location.photoFileName;
    final visited = location.visited;
    final accent = visited ? scheme.tertiary : scheme.secondary;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      children: [
        if (coordinates != null)
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radius + 8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.14),
                  blurRadius: 32,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radius + 8),
              child: SizedBox(height: 300, child: SpotMap(coordinates)),
            ),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.location_off_outlined, color: scheme.secondary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Salvo sem GPS', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(
                          'Use a foto e a nota para encontrar o carro.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    visited ? Icons.check_rounded : Icons.directions_car_filled,
                    color: accent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visited ? 'Carro encontrado' : 'Carro estacionado',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Salvo em ${formatDateTime(location.timestamp)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (location.note case final note?) ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.sticky_note_2_outlined, color: scheme.secondary),
                  const SizedBox(width: 14),
                  Expanded(child: Text(note, style: theme.textTheme.bodyLarge)),
                ],
              ),
            ),
          ),
        ],
        if (photo != null) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => PhotoViewerScreen(controller.photoFile(photo)),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radius),
              child: Stack(
                children: [
                  Image.file(
                    controller.photoFile(photo),
                    height: 210,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => SizedBox(
                      height: 80,
                      child: Center(
                        child: Text(
                          'Foto indisponível',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.open_in_full_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
