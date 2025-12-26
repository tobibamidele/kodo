import 'package:flutter/material.dart';

class KodoFloatingActionButtonTheme {
  static FloatingActionButtonThemeData lightFloatingActionButtonTheme =
      FloatingActionButtonThemeData(backgroundColor: Colors.green.shade800);
  static FloatingActionButtonThemeData darkFloatingActionButtonTheme =
      FloatingActionButtonThemeData(backgroundColor: Colors.green.shade800);
}

class KodoElevatedButtonTheme {
  static ElevatedButtonThemeData lightElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          backgroundColor: Colors.green.shade800,
          overlayColor: Colors.transparent,
        ),
      );

  static ElevatedButtonThemeData darkElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          backgroundColor: Colors.green.shade800,
          overlayColor: Colors.transparent,
        ),
      );
}

class KodoOutlinedButtonTheme {
  static OutlinedButtonThemeData lightOutlinedButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(color: Colors.green.shade800, width: 2),
        ),
      );

  static OutlinedButtonThemeData darkOutlinedButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(color: Colors.green.shade800, width: 2),
        ),
      );
}
