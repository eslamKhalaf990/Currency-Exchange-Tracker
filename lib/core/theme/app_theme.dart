import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Outfit',
      colorScheme: const ColorScheme.light(
        primary: Colors.black,
        secondary: Colors.grey,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSurface: Colors.black,
      ),
      useMaterial3: true,
    );
  }
}
