import 'package:flutter/material.dart';

class KodoTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    titleLarge: TextStyle(
      fontSize: 32,
      color: Colors.black87,
      fontFamily: 'Inter',
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      fontSize: 24,
      color: Colors.black87,
      fontWeight: FontWeight.bold,
      fontFamily: 'Inter',
    ),
    labelSmall: TextStyle(
      fontSize: 14,
      color: Colors.grey,
      fontWeight: FontWeight.normal,
      fontFamily: 'Inter',
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontFamily: 'Inter',
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      color: Colors.black,

      fontFamily: 'Inter',
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    titleLarge: TextStyle(
      fontSize: 32,
      color: Colors.white70,
      fontWeight: FontWeight.bold,
      fontFamily: 'Inter',
    ),
    titleMedium: TextStyle(
      fontSize: 24,
      color: Colors.white70,
      fontWeight: FontWeight.bold,
      fontFamily: 'Inter',
    ),
    labelSmall: TextStyle(
      fontSize: 14,
      color: Colors.grey,
      fontWeight: FontWeight.normal,
      fontFamily: 'Inter',
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: 'Inter',
    ),

    bodySmall: TextStyle(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.normal,
      fontFamily: 'Inter',
    ),
  );
}
