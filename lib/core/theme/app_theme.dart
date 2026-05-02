import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF8B5E3C), // coklat kopi
        primary: const Color(0xFF8B5E3C),
        surface: const Color(0xFFF5EDE0),   // coklat muda krem
        background: const Color(0xFFF5EDE0),
        error: const Color(0xFFB00020),
      ),
      scaffoldBackgroundColor: const Color(0xFFF5EDE0),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF8B5E3C),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B5E3C),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFDF8F3), // krem lebih terang
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD7BFAE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD7BFAE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF8B5E3C), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Color(0xFF4E342E)),
        titleLarge: TextStyle(color: Color(0xFF3E2723)),
      ),
    );
  }
}
