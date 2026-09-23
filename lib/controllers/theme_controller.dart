import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';

class ThemeController extends ChangeNotifier {
  static const _modeKey = 'theme_mode';
  static const _paletteKey = 'theme_palette';

  ThemeMode _mode = ThemeMode.system;
  AppPalette _palette = AppPalette.marinho;

  ThemeMode get mode => _mode;
  AppPalette get palette => _palette;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_modeKey);
    _mode = ThemeMode.values.firstWhere(
      (m) => m.name == savedMode,
      orElse: () => ThemeMode.system,
    );
    _palette = AppPalette.byId(prefs.getString(_paletteKey));
    notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modeKey, mode.name);
  }

  Future<void> setPalette(AppPalette palette) async {
    if (palette.id == _palette.id) return;
    _palette = palette;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_paletteKey, palette.id);
  }
}
