import 'package:flutter/material.dart';

class AppTheme {
  // Definisi Warna sesuai Persentase
  static const Color hitam = Color(0xFF000000); // 60%
  static const Color putihTulang = Color(0xFFF5F5F5); // 15%
  static const Color abuAbu = Color(0xFF808080); // 15%
  static const Color merah = Color(0xFFE60813); // 10%

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: hitam,
      colorScheme: const ColorScheme.dark(
        primary: merah,
        onPrimary: putihTulang,
        secondary: abuAbu,
        onSecondary: hitam,
        surface: hitam,
        onSurface: putihTulang,
        error: merah,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: hitam,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: putihTulang),
        titleTextStyle: TextStyle(
          color: putihTulang,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: putihTulang),
        bodyMedium: TextStyle(color: abuAbu),
      ),
      cardTheme: CardThemeData(
        color: hitam,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: abuAbu, width: 0.5), // Border tipis
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: merah,
        foregroundColor: putihTulang,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: merah,
          foregroundColor: putihTulang,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
