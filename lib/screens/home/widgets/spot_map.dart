import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/car_location.dart';

class SpotMap extends StatefulWidget {
  const SpotMap(this.coordinates, {super.key, this.zoom = 17});

  final Coordinates coordinates;
  final double zoom;

  @override
  State<SpotMap> createState() => _SpotMapState();
}

class _SpotMapState extends State<SpotMap> {
  static const _osmCopyright = 'https://www.openstreetmap.org/copyright';

  final _controller = MapController();

  LatLng get _point =>
      LatLng(widget.coordinates.latitude, widget.coordinates.longitude);

  @override
  void didUpdateWidget(covariant SpotMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final old = oldWidget.coordinates;
    final now = widget.coordinates;
    if (old.latitude != now.latitude || old.longitude != now.longitude) {
      _recenter();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _recenter() => _controller.move(_point, widget.zoom);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        FlutterMap(
          mapController: _controller,
          options: MapOptions(
            initialCenter: _point,
            initialZoom: widget.zoom,
            minZoom: 3,
            maxZoom: 19,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.joao.ondeestacionei',
              maxNativeZoom: 19,
              tileBuilder: isDark ? darkModeTileBuilder : null,
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _point,
                  width: 64,
                  height: 64,
                  child: Semantics(
                    label: 'Local onde o carro está estacionado',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.secondary.withValues(
                          alpha: 0.25,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.primary,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 10,
                                color: Colors.black38,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.directions_car_filled,
                            size: 20,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(Uri.parse(_osmCopyright)),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          top: 16,
          right: 16,
          child: FloatingActionButton.small(
            heroTag: null,
            tooltip: 'Centralizar no carro',
            onPressed: _recenter,
            child: const Icon(Icons.my_location_rounded),
          ),
        ),
      ],
    );
  }
}