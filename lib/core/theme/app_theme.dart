import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryColor = Color(0xFF4CAF50); // Nature Green
  static const Color _secondaryColor = Color(0xFF03A9F4); // Sky Blue

  static final ColorScheme _lightColorScheme = ColorScheme.fromSeed(
    seedColor: _primaryColor,
    secondary: _secondaryColor,
    brightness: Brightness.light,
  );

  static final ColorScheme _darkColorScheme = ColorScheme.fromSeed(
    seedColor: _primaryColor,
    secondary: _secondaryColor,
    brightness: Brightness.dark,
  );

  static ThemeData getLightTheme({ColorScheme? colorScheme}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme ?? _lightColorScheme,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static ThemeData getDarkTheme({ColorScheme? colorScheme}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme ?? _darkColorScheme,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
