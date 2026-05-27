import 'package:flutter/material.dart';

class ThemeProvider {
  static ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      onSurface: Colors.black,
      brightness: Brightness.light,
      surface: Colors.white,
      primary: Colors.grey.shade400,
      secondary: Colors.grey.shade500,
    ),
  );

  static ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.light(
      onSurface: Colors.white,
      brightness: Brightness.dark,
      surface: Colors.black,
      primary: Colors.grey.shade900,
      secondary: Colors.grey.shade800,
    ),
  );

  static ThemeData getCurrentTheme(bool isDark) {
    return (isDark) ? _darkTheme : _lightTheme;
  }
}
