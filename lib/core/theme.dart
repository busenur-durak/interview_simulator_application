import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const String _fontFamily = 'PlusJakartaSans';

  // Stitch Palette
  static const Color primaryBlue = Color(0xFF0C7FF2);
  static const Color bgGray = Color(0xFFF9FAFB);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate500 = Color(0xFF64748B);
  static const Color borderGray = Color(0xFFE5E7EB);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryBlue,
    fontFamily: _fontFamily,
    scaffoldBackgroundColor: bgGray,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
      primary: primaryBlue,
      onPrimary: Colors.white,
      secondary: const Color(0xFFa855f7),
      surface: Colors.white,
      onSurface: slate800,
    ),
    useMaterial3: true,
    
    // Fixed: Changed CardTheme to CardThemeData
    cardTheme: CardThemeData(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: borderGray, width: 1),
      ),
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 1,
        textStyle: const TextStyle(
          inherit: false,
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.3,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        side: const BorderSide(color: borderGray, width: 1.5),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(inherit: false, fontFamily: _fontFamily, fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: borderGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: borderGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      labelStyle: const TextStyle(color: slate600, fontWeight: FontWeight.w500),
      hintStyle: const TextStyle(color: slate500),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontWeight: FontWeight.w800, color: slate800, letterSpacing: -0.5),
      headlineMedium: TextStyle(fontWeight: FontWeight.w700, color: slate800, letterSpacing: -0.5),
      titleLarge: TextStyle(fontWeight: FontWeight.w600, color: slate800),
      titleMedium: TextStyle(fontWeight: FontWeight.w600, color: slate800),
      bodyLarge: TextStyle(color: slate800, fontSize: 16),
      bodyMedium: TextStyle(color: slate600, fontSize: 14),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: slate800,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      shape: Border(bottom: BorderSide(color: borderGray, width: 1)),
      titleTextStyle: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: slate800,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryBlue,
    fontFamily: _fontFamily,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.dark,
      primary: primaryBlue,
      surface: const Color(0xFF1E293B),
    ),
    useMaterial3: true,
    
    // Fixed: Changed CardTheme to CardThemeData
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withOpacity(0.05)),
      ),
      color: const Color(0xFF1E293B),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(
          inherit: false,
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.3,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        side: BorderSide(color: Colors.white.withOpacity(0.1), width: 1.5),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(inherit: false, fontFamily: _fontFamily, fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w500),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
    ),

    textTheme: TextTheme(
      headlineLarge: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5),
      headlineMedium: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.5),
      titleLarge: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      titleMedium: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      bodyLarge: const TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E293B),
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      shape: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05), width: 1)),
      titleTextStyle: const TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
  );

  static ThemeData modernTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF7C3AED),
    fontFamily: _fontFamily,
    scaffoldBackgroundColor: const Color(0xFFF7F7FB),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF7C3AED),
      brightness: Brightness.light,
      primary: const Color(0xFF7C3AED),
      onPrimary: Colors.white,
      secondary: const Color(0xFF06B6D4),
      surface: Colors.white,
      onSurface: slate800,
    ),
    useMaterial3: true,
    cardTheme: CardThemeData(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.black.withOpacity(0.06), width: 1),
      ),
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
        textStyle: const TextStyle(
          inherit: false,
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 14,
          letterSpacing: 0.3,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF7C3AED),
        side: BorderSide(color: Colors.black.withOpacity(0.10), width: 1.5),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          inherit: false,
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.10)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
      ),
      labelStyle: const TextStyle(color: slate600, fontWeight: FontWeight.w500),
      hintStyle: const TextStyle(color: slate500),
    ),
  );

  static ThemeData professionalTheme = lightTheme;

  static ThemeData highContrastTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFFFD400),
    fontFamily: _fontFamily,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFD400),
      onPrimary: Colors.black,
      secondary: Color(0xFF00E5FF),
      onSecondary: Colors.black,
      error: Color(0xFFFF3B30),
      onError: Colors.black,
      surface: Color(0xFF0B0B0B),
      onSurface: Colors.white,
    ),
    useMaterial3: true,
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFF2A2A2A), width: 1.5),
      ),
      color: const Color(0xFF0B0B0B),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFD400),
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        textStyle: const TextStyle(
          inherit: false,
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w800,
          fontSize: 14,
          letterSpacing: 0.4,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFF3A3A3A), width: 2),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          inherit: false,
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF0B0B0B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3A3A3A), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3A3A3A), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFFD400), width: 2.5),
      ),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.55)),
      labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
    ),
  );

  static ThemeData themeForId(String id) {
    switch (id) {
      case 'professional':
        return professionalTheme;
      case 'modern':
        return modernTheme;
      case 'high_contrast':
        return highContrastTheme;
      case 'dark':
      default:
        return darkTheme;
    }
  }
}
