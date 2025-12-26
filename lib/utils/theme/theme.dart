import 'package:flutter/material.dart';
import 'package:kodo/utils/theme/button_theme.dart';
import 'package:kodo/utils/theme/extensions/chat_colors.dart';
import 'package:kodo/utils/theme/text_theme.dart';

class KodoTheme {
  KodoTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: KodoTextTheme.lightTextTheme,
    cardTheme: CardThemeData(color: Color(0xFFBDC7C7)),
    fontFamily: 'Inter',
    scaffoldBackgroundColor: Color(0xFFFFFFFF),
    cardColor: Colors.grey.shade700,
    primaryColor: Colors.green.shade800,
    primaryColorDark: Colors.green.shade900,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.green.shade800,
      brightness: Brightness.light,
    ),
    extensions: [
      ChatColors(
        myMessage: Colors.green.shade600,
        otherMessage: Color(0xFFBDC7C7).withOpacity(0.5),
      ),
    ],
    // primaryColor: Colors.black12,
    useMaterial3: true,
    inputDecorationTheme: InputDecorationTheme(
      border: InputBorder.none,
    ), // Removes that annoying line under input text fields
    floatingActionButtonTheme:
        KodoFloatingActionButtonTheme.lightFloatingActionButtonTheme,
    elevatedButtonTheme: KodoElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: KodoOutlinedButtonTheme.lightOutlinedButtonTheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: KodoTextTheme.darkTextTheme,
    cardTheme: CardThemeData(color: Color(0xFF404240)),
    fontFamily: 'Inter',
    scaffoldBackgroundColor: Color(0xFF111211),
    cardColor: Colors.grey.shade900,
    primaryColor: Colors.green.shade800,
    primaryColorDark: Colors.green.shade900,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.green.shade900,
      brightness: Brightness.dark,
    ),
    extensions: [
      ChatColors(
        myMessage: Colors.green.shade900,
        otherMessage: Colors.grey.shade900,
      ),
    ],
    // primaryColor: Colors.white12,
    useMaterial3: true,
    inputDecorationTheme: InputDecorationTheme(border: InputBorder.none),
    floatingActionButtonTheme:
        KodoFloatingActionButtonTheme.darkFloatingActionButtonTheme,
    elevatedButtonTheme: KodoElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: KodoOutlinedButtonTheme.darkOutlinedButtonTheme,
  );
}
