import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodo/src/models/user_model.dart';
import 'package:kodo/src/providers/user_provider.dart';
import 'package:kodo/src/services/qr_service.dart';
import 'package:kodo/src/services/user_service.dart';
import 'package:kodo/src/widgets/add_user_modal.dart';
import 'package:kodo/src/widgets/bottom_modal.dart';
import 'package:kodo/src/widgets/qr_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});
  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "QR Code",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: 'GET QR'),
              Tab(text: 'SCAN QR'),
            ],
          ),
        ),
        body: const TabBarView(children: [GetQrView(), ScanQrView()]),
      ),
    );
  }
}

/// View for displaying the user QR
class GetQrView extends ConsumerStatefulWidget {
  const GetQrView({super.key});

  @override
  ConsumerState<GetQrView> createState() => _GetQrViewState();
}

class _GetQrViewState extends ConsumerState<GetQrView> {
  String qrData = "";

  void createUserQr(KodoUser? user) {
    if (user == null) {
      return;
    }
    final data = KodoQrService.generateUserQrCode(userId: user.id);
    setState(() {
      qrData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userStateAsync = ref.watch(userProvider);
    return SafeArea(
      child: userStateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (user) {
          return _buildQrView(user);
        },
      ),
    );
  }

  Widget _buildQrView(KodoUser? user) {
    createUserQr(user);
    return Column(
      children: [
        const SizedBox(height: 20),
        Center(
          child: KodoQrWidget(
            config: KodoQrConfig(
              size: 240,
              data: qrData,
              errorCorrectionLevel: QrErrorCorrectLevel.Q,
            ),
          ),
        ),
      ],
    );
  }
}

/// View for scanning the qr code
class ScanQrView extends StatefulWidget {
  const ScanQrView({super.key});
  @override
  State<ScanQrView> createState() => _ScanQrViewState();
}

class _ScanQrViewState extends State<ScanQrView> {
  bool isLoading = false;
  PermissionStatus? _status;
  @override
  void initState() {
    super.initState();
    _requestCamera();
  }

  /// Requests access to the camera
  Future<void> _requestCamera() async {
    final status = await Permission.camera.request();
    setState(() => _status = status);
  }

  Map<String, String> parseQrCode(String rawValue) {
    // Parse the qr code uri
    final uri = Uri.parse(rawValue);
    return Map<String, String>.from(uri.queryParameters);
  }

  /// Handles the QR code if the type parameter is 'user'
  void handleUserQrCode(BuildContext context, String userId) async {
    final user = await KodoUserService().getUserById(
      userId.trim(),
    ); // Get the user from firebase
    if (!context.mounted) return;
    if (user == null) return;
    showKodoBottomModal(
      context,
      builder: (dismiss) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  AddUserModal(user: user, dismiss: dismiss),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_status == null) {
      return const SafeArea(child: Center(child: CircularProgressIndicator()));
    }

    if (_status!.isDenied || _status!.isPermanentlyDenied) {
      return SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Camera permission is required",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: openAppSettings,
                child: const Text("Open settings"),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: (isLoading)
          ? const CircularProgressIndicator()
          : Column(
            children: [
              SizedBox(height: 20),
              SizedBox(
                  width: 220,
                  height: 220,
                  child: MobileScanner(
                    controller: MobileScannerController(
                      detectionSpeed: DetectionSpeed.noDuplicates,
                      facing: CameraFacing.back,
                      autoZoom: true,
                    ),
                    onDetect: (capture) {
                      final code = capture.barcodes.first;
                      final value = code.rawValue;
                      if (value == null) return;
                      final data = parseQrCode(value);
                      switch (data['type']) {
                        case 'user':
                          handleUserQrCode(context, data['uid'] ?? '');
                          break;
                        default:
                      }
                    },
                  ),
                ),
            ],
          ),
    );
  }
}
