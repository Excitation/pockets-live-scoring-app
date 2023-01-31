import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppTheme class
class PocketTheme {
  /// The Dark theme data.
  static ThemeData darkThemeData = ThemeData(
    primaryColor: Colors.red,
    primarySwatch: Colors.red,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: Colors.red,
      secondary: const Color(0xFFEFEFEF),
      background: const Color(0xFF121212),
      onBackground: Colors.white,
      error: Colors.red,
    ),
    fontFamily: GoogleFonts.poppins().fontFamily,
    iconTheme: const IconThemeData(color: Colors.black),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      ),
    ),
  );

  /// The Light theme data.
  static ThemeData lightThemeData = ThemeData(
    primaryColor: Colors.red,
    primarySwatch: Colors.red,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.grey,
      primary: Colors.red,
      background: Colors.white,
      onBackground: Colors.black,
      error: Colors.red,
    ),
    fontFamily: GoogleFonts.poppins().fontFamily,
    iconTheme: const IconThemeData(color: Colors.white),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      ),
    ),
  );
}
