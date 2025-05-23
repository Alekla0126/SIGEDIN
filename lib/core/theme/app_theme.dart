// Contains global app theme configuration
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colores principales
  static const primaryColor = Color(0xFF1A73E8);
  static const primaryLightColor = Color(0xFFE8F0FE);
  static const secondaryColor = Color(0xFF5F6368);
  static const accentColor = Color(0xFF4285F4);
  static const errorColor = Color(0xFFD93025);
  static const successColor = Color(0xFF34A853);
  static const warningColor = Color(0xFFFBBC05);
  static const backgroundColor = Color(0xFFF8F9FA);
  static const surfaceColor = Colors.white;
  static const cardColor = Colors.white;
  static const shadowColor = Color(0x1A000000);

  // Tema claro
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        primaryContainer: primaryLightColor,
        secondary: accentColor,
        secondaryContainer: accentColor.withOpacity(0.1),
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: secondaryColor,
        onBackground: secondaryColor,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.nunitoSansTextTheme().copyWith(
        headlineLarge: GoogleFonts.nunitoSans(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: secondaryColor.withOpacity(0.9),
        ),
        headlineMedium: GoogleFonts.nunitoSans(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: secondaryColor.withOpacity(0.9),
        ),
        titleLarge: GoogleFonts.nunitoSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: secondaryColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.nunitoSans(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return primaryColor.withOpacity(0.4);
            }
            return primaryColor;
          }),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(2),
          minimumSize: MaterialStateProperty.all(const Size(100, 50)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          )),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: secondaryColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: secondaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(color: secondaryColor, fontWeight: FontWeight.w500),
        floatingLabelStyle: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        hintStyle: TextStyle(color: secondaryColor.withOpacity(0.5)),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: cardColor,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        backgroundColor: secondaryColor,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
      ),
      textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
    );
  }
}
