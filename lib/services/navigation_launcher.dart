import 'package:url_launcher/url_launcher.dart';

import '../models/car_location.dart';

class NavigationLauncher {
  Future<bool> openGoogleMaps(Coordinates c) => launchUrl(
    Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${c.latitude},${c.longitude}&travelmode=walking',
    ),
    mode: LaunchMode.externalApplication,
  );

  Future<bool> openWaze(Coordinates c) => launchUrl(
    Uri.parse(
      'https://waze.com/ul?ll=${c.latitude},${c.longitude}&navigate=yes',
    ),
    mode: LaunchMode.externalApplication,
  );
}
