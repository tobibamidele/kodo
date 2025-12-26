import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:kodo/src/services/auth_service.dart';

String formatTime(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

void copyToClipboard(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}

String? getCurrentUsername() {
  final email = AuthService.currentUser?.email;
  if (email == null) return null;
  return email.split("@")[0];
}

Timestamp parseTimestamp(dynamic value) {
  if (value == null) return Timestamp.now();
  if (value is Timestamp) return value;
  if (value is String) {
    return Timestamp.fromDate(DateTime.parse(value));
  }
  throw Exception('Invalid timestamp type: ${value.runtimeType}');
}
