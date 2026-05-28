import 'package:flutter/material.dart';

class AppTheme {
  static const Color darkBackground = Color(0xFF050505);
  static const Color cardBackground = Color(0xFF121212);
  static const Color fireRed = Color(0xFFB71C1C);
  static const Color fireOrange = Color(0xFFFF6F00);
  static const Color gold = Color(0xFFFFA000);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color surfaceRed = Color(0xFF1A0A0A);

  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    scaffoldBackgroundColor: darkBackground,
    primaryColor: fireRed,
    colorScheme: const ColorScheme.dark(
      primary: fireRed,
      secondary: gold,
      surface: cardBackground,
      background: darkBackground,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        letterSpacing: 3,
        color: gold,
        shadows: [
          Shadow(color: fireRed, blurRadius: 8, offset: Offset(0, 0)),
        ],
      ),
    ),
    cardTheme: CardTheme(
      color: cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 12,
      shadowColor: fireRed.withOpacity(0.25),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: cardBackground.withOpacity(0.95),
      selectedItemColor: gold,
      unselectedItemColor: textSecondary,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
      type: BottomNavigationBarType.fixed,
      elevation: 16,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: fireOrange,
      inactiveTrackColor: Colors.grey.shade800,
      thumbColor: gold,
      overlayColor: fireRed.withOpacity(0.2),
      trackHeight: 4,
    ),
    iconTheme: const IconThemeData(color: textSecondary),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: 2),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: gold),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary),
      bodyLarge: TextStyle(fontSize: 16, color: textPrimary),
      bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
    ),
  );
}
