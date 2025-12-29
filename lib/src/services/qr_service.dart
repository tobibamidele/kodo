import 'package:qr_flutter/qr_flutter.dart';

/// Helper class that centralizes QR config for reusabilty
class KodoQrConfig {
  final String data;
  final double size;
  final int errorCorrectionLevel;
  final int version;

  const KodoQrConfig({
    required this.data,
    this.size = 200,
    this.errorCorrectionLevel = QrErrorCorrectLevel.M,
    this.version = QrVersions.auto,
  });
}

enum KodoQrType { invite, user, group, message }

class KodoQrService {
  /// Generates QR data for sharing a user's profile
  /// Returns the data in a url format `kodo://user?uid=%s`
  static String generateUserQrCode({required String userId}) {
    return "kodo://qrcode?type=user&uid=$userId";
  }
}
