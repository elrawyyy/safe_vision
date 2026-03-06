import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xFFFCAE15),
    brightness: Brightness.light,
    scaffoldBackgroundColor:
        const Color(0xFF212F3D), // Navy background for auth
    cardColor: Colors.white, // Inner container
    textTheme: GoogleFonts.outfitTextTheme(
      const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87), // Input text
        bodyMedium: TextStyle(color: Colors.black54), // Subtitle
        displayLarge: TextStyle(color: Color(0xFF001B36)), // Headers
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.transparent,
      hintStyle: TextStyle(color: Colors.grey[400]),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xFFFCAE15),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212), // Deep black background
    cardColor: const Color(0xFF1E1E1E), // Dark grey inner container
    textTheme: GoogleFonts.outfitTextTheme(
      const TextTheme(
        bodyLarge: TextStyle(
            color: Colors.black), // User explicitly wanted typed text Black
        bodyMedium: TextStyle(color: Colors.white70), // Subtitle
        displayLarge: TextStyle(color: Colors.white), // Headers
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor:
          Colors.white, // White background for inputs so black text is visible
      hintStyle: TextStyle(color: Colors.grey[500]),
    ),
  );
}
