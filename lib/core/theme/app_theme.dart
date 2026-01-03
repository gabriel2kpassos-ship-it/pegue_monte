import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.indigo,
    scaffoldBackgroundColor: Colors.grey.shade100,

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),

    // 🔧 CORREÇÃO AQUI
    cardTheme: const CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
    ),

    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );
}
