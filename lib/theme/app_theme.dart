import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryDark = Color(0xFF0F0F0F); // Deepest Charcoal
  static const Color accentGold = Color(0xFFD4AF37); // Royal Gold
  static const Color mutedGold = Color(0xFF997D29); 
  static const Color glassColor = Color(0x1AFFFFFF); // Translucent White
  static const Color textOffWhite = Color(0xFFF0F0F0);

  static LinearGradient get goldGradient => const LinearGradient(
        colors: [accentGold, mutedGold],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static ThemeData get modernDarkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryDark,
      scaffoldBackgroundColor: primaryDark,
      colorScheme: const ColorScheme.dark(
        primary: accentGold,
        secondary: accentGold,
        surface: Color(0xFF1A1A1A),
        onSurface: textOffWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: accentGold,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Amiri',
          letterSpacing: 1.2,
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: accentGold,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'Amiri',
        ),
        bodyLarge: TextStyle(
          color: textOffWhite,
          fontSize: 18,
          fontFamily: 'Tajawal',
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: Colors.white70,
          fontSize: 16,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }
}
