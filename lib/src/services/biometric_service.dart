import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  factory BiometricService() => _instance;
  BiometricService._internal();
  static BiometricService get instance => _instance;

  final LocalAuthentication _auth = LocalAuthentication();
  final String biometicEnabledFlag = 'biometric_enabled';

  /// Checks if the device has biometric support
  Future<bool> hasBiometricSupport() async {
    return await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
  }

  /// Returns whether or not the device has enrolled biometrics
  Future<bool> hasEnrolledBiometrics() async {
    final avalBiometrics = await _auth.getAvailableBiometrics();
    return avalBiometrics.isNotEmpty;
  }

  /// Attempts biometric authentication
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true, // No fallback to device pin/pattern/password
        persistAcrossBackgrounding:
            true, // Persist authentication when brought to foreground to prevent it failing with errors
      );
    } catch (e, st) {
      debugPrint("Error during biometric auth: ${e.toString()}");
      debugPrint("Stacktrace: $st");
      return false;
    }
  }

  /// Stores biometic enabled flag
  Future<void> setBiometricEnabled(bool enabled) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setBool(biometicEnabledFlag, enabled);
  }

  /// Gets the biometric enabled flag
  Future<bool> isBiometricEnabled() async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getBool(biometicEnabledFlag) ?? false;
  }

  /// Removes the biometric enabled flag
  Future<void> disableBiometrics() async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.remove(biometicEnabledFlag);
  }
}
