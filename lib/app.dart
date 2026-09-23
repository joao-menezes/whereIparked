import 'package:flutter/material.dart';

import 'controllers/parking_controller.dart';
import 'controllers/theme_controller.dart';
import 'screens/home/home_screen.dart';
import 'services/navigation_launcher.dart';
import 'theme/app_theme.dart';

class OndeEstacioneiApp extends StatelessWidget {
  const OndeEstacioneiApp({
    super.key,
    required this.controller,
    required this.themeController,
    required this.navigation,
  });

  final ParkingController controller;
  final ThemeController themeController;
  final NavigationLauncher navigation;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) => MaterialApp(
        title: 'Onde Estacionei',
        themeMode: themeController.mode,
        theme: AppTheme.light(themeController.palette),
        darkTheme: AppTheme.dark(themeController.palette),
        home: HomeScreen(
          controller: controller,
          themeController: themeController,
          navigation: navigation,
        ),
      ),
    );
  }
}
