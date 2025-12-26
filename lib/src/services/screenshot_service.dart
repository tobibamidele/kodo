import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenshotService {
  static final ScreenshotService _instance = ScreenshotService._internal();
  factory ScreenshotService() => _instance;
  ScreenshotService._internal();
  static ScreenshotService get instance => _instance;

  // Same channel defined in the MainActivity.kt for screenshot handling
  static const _channel = MethodChannel('screenshot_channel');

  /// Disables screenshots on the device
  Future<void> disableScreenshot() async {
    try {
      await _channel.invokeMethod('disable_screenshot');
    } catch (e) {
      debugPrint('Failed to disable screenshots: $e');
    }
  }

  // Re-enables screenshots on the device
  Future<void> enableScreenshot() async {
    try {
      await _channel.invokeMethod('enable_screenshot');
    } catch (e) {
      debugPrint('Failed to enable screenshots: $e');
    }
  }
}
