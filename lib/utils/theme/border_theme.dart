import 'package:flutter/material.dart';

class KodoBorderTheme {
  static OutlineInputBorder lightOutlineInputBorderTheme = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: Color(0xFFB0F542)),
  );

  static OutlineInputBorder darkOutlineInputBorderTheme = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: Color(0xFF088208)),
  );
}
