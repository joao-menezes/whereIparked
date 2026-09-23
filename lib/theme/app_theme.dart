import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppPalette {
  const AppPalette({
    required this.id,
    required this.name,
    required this.deep,
    required this.tint,
    required this.accent,
  });

  final String id;
  final String name;

  final Color deep;

  final Color tint;
  final Color accent;

  static const marinho = AppPalette(
    id: 'marinho',
    name: 'Marinho',
    deep: Color(0xFF14213D),
    tint: Color(0xFFDCE3F5),
    accent: Color(0xFFC9A45C),
  );
  static const esmeralda = AppPalette(
    id: 'esmeralda',
    name: 'Esmeralda',
    deep: Color(0xFF0F3D33),
    tint: Color(0xFFD5EFE6),
    accent: Color(0xFFD4AF6A),
  );
  static const grafite = AppPalette(
    id: 'grafite',
    name: 'Grafite',
    deep: Color(0xFF23262E),
    tint: Color(0xFFE4E6EC),
    accent: Color(0xFFCB7F52),
  );
  static const bordo = AppPalette(
    id: 'bordo',
    name: 'Bordô',
    deep: Color(0xFF4A1626),
    tint: Color(0xFFF3D9E0),
    accent: Color(0xFFD9A68F),
  );

  static const all = [marinho, esmeralda, grafite, bordo];

  static AppPalette byId(String? id) =>
      all.firstWhere((p) => p.id == id, orElse: () => marinho);
}

abstract final class AppTheme {
  static const radius = 20.0;

  static ThemeData light([AppPalette p = AppPalette.marinho]) => _build(
    ColorScheme.fromSeed(seedColor: p.deep, brightness: Brightness.light)
        .copyWith(
          primary: p.deep,
          onPrimary: Colors.white,
          secondary: p.accent,
          onSecondary: const Color(0xFF241A05),
          tertiary: const Color(0xFF2E7D5B),
          surface: const Color(0xFFF7F6F3),
          surfaceContainerLowest: Colors.white,
          surfaceContainerLow: Colors.white,
          surfaceContainer: const Color(0xFFEFEDE8),
          outlineVariant: const Color(0xFFE2DFD8),
        ),
  );

  static ThemeData dark([AppPalette p = AppPalette.marinho]) => _build(
    ColorScheme.fromSeed(seedColor: p.deep, brightness: Brightness.dark)
        .copyWith(
          primary: p.tint,
          onPrimary: p.deep,
          secondary: p.accent,
          onSecondary: const Color(0xFF241A05),
          tertiary: const Color(0xFF6FD0A5),
          surface: const Color(0xFF0D1119),
          surfaceContainerLowest: const Color(0xFF0A0D14),
          surfaceContainerLow: const Color(0xFF151A24),
          surfaceContainer: const Color(0xFF1B2130),
          outlineVariant: const Color(0xFF2A3142),
        ),
  );

  static ThemeData _build(ColorScheme scheme) {
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    final text = GoogleFonts.plusJakartaSansTextTheme(base.textTheme);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      textTheme: text.copyWith(
        headlineSmall: text.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
        titleLarge: text.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        titleMedium: text.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.1,
        ),
        labelLarge: text.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: shape,
          textStyle: text.labelLarge?.copyWith(fontSize: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.onSurfaceVariant,
          shape: shape,
          minimumSize: const Size.fromHeight(48),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: scheme.surfaceContainerLow,
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        backgroundColor: scheme.surfaceContainerLowest,
        foregroundColor: scheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.secondary, width: 1.5),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
    );
  }
}
