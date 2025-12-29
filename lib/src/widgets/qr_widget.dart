import 'package:flutter/material.dart';
import 'package:kodo/src/services/qr_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class KodoQrWidget extends StatelessWidget {
  final KodoQrConfig config;
  final Color backgroundColor;
  final Color foregroundColor;

  const KodoQrWidget({
    super.key,
    required this.config,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
  });
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(12),
        child: QrImageView(
          data: config.data,
          size: config.size,
          version: config.version,
          eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.circle),
          dataModuleStyle: QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.circle,
          ),
          errorCorrectionLevel: config.errorCorrectionLevel,
          backgroundColor: backgroundColor,
          // ignore: deprecated_member_use
          foregroundColor: foregroundColor,
        ),
      ),
    );
  }
}
