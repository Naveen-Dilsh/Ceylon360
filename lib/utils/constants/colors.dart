import 'package:flutter/material.dart';

class APPColors {
  APPColors._();

  // App Basic Colors - Updated for Ceylon 360 Tourism Theme
  static const Color primary = Color(0xFF1A7D5A); // Ceylon Tea Green
  static const Color secondary = Color(0xFFFF9E1B); // Sunset Orange
  static const Color accent = Color(0xFF60C0CB); // Ocean Blue

  // Additional Ceylon Theme Colors
  static const Color ceylonRed = Color(0xFFD12E42); // Reddish tone from flag
  static const Color ceylonYellow = Color(0xFFFFD639); // Cultural gold
  static const Color ceylonTeal = Color(0xFF008080); // Coastal water
  static const Color ceylonCoral = Color(0xFFFF7F50); // Beach sunset
  static const Color ceylonSand = Color(0xFFF5DEB3); // Beach sand

  //Gradient Colors
  static const Gradient ceylonSunriseGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFF9E1B), Color(0xFFFFD639), Color(0xFFF5DEB3)]);

  static const Gradient ceylonOceanGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1A7D5A), Color(0xFF60C0CB), Color(0xFF008080)]);

  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color.fromARGB(255, 108, 125, 114);
  static const Color textWhite = Colors.white;

  // Background Colors
  static const Color light = Color(0xFFF8F5F2); // Subtle off-white
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFE6F2EE); // Light green tint

  // Background Container Colors
  static const Color lightContainer = Color(0xFFF8F5F2);
  static Color darkContainer = APPColors.white.withOpacity(0.1);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF1A7D5A);
  static const Color buttonSecondary = Color(0xFFFF9E1B);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // Border Colors
  static const Color borderPrimary = Color(0xFF1A7D5A);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // Error and Validation Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFFF9E1B); // Using sunset orange
  static const Color info = Color(0xFF60C0CB); // Using ocean blue

  // Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}
