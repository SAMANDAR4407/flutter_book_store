
import 'package:flutter/material.dart';

class MyTheme {
  const MyTheme._();

  static ThemeData light() {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.black,
      secondaryHeaderColor: Colors.black87,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.black),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          iconColor: MaterialStatePropertyAll(Colors.black87),
        ),
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.white70),
      useMaterial3: true,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFF000F34),
      primaryColor: Colors.white,
      secondaryHeaderColor: Colors.white70,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF000F34),
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          iconColor: MaterialStatePropertyAll(Colors.white70),
        ),
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
      useMaterial3: true,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white70),
        bodyMedium: TextStyle(color: Colors.white70),
        bodySmall: TextStyle(color: Colors.white70),
      ),
    );
  }
}
