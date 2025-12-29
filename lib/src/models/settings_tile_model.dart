import 'package:flutter/material.dart';

class SettingsTileModel {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Icon? trailing;
  final Icon leading;

  const SettingsTileModel({
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.leading,
    this.trailing,
  });
}
