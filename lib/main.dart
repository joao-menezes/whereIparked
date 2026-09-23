import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'app.dart';
import 'controllers/parking_controller.dart';
import 'controllers/theme_controller.dart';
import 'data/car_location_repository.dart';
import 'services/location_service.dart';
import 'services/navigation_launcher.dart';
import 'services/notification_service.dart';
import 'services/photo_service.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: binding);

  final photos = PhotoService();
  final notifications = NotificationService();
  await Future.wait([photos.init(), notifications.init()]);

  final controller = ParkingController(
    repository: CarLocationRepository(),
    location: LocationService(),
    photos: photos,
    notifications: notifications,
  );
  final themeController = ThemeController();
  Future.wait([
    controller.load(),
    themeController.load(),
  ]).whenComplete(FlutterNativeSplash.remove);

  runApp(
    OndeEstacioneiApp(
      controller: controller,
      themeController: themeController,
      navigation: NavigationLauncher(),
    ),
  );
}
