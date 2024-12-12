import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_colors.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/views/register/register.controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeController extends GetxController {
  final RegisterController registerController = Get.find();
  RxBool isScanned = false.obs;
  void handleScannedData(String? code) {
    if (isScanned.value) return;
    if (code != null && code.isNotEmpty) {
      isScanned.value = true;

      List<String> parts = code.split('%');

      if (parts.length == 3 && parts[0] == 'GTV' && parts[2] == 'GTV') {
        String extractedCode = parts[1];

        registerController.tribeCodeController.text = extractedCode;

        Get.back();
      } else {
        isScanned.value = false;
        Fluttertoast.showToast(
          msg: 'QR Code không hợp lệ.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.errorColor,
          fontSize: 14,
        );
      }
    }
  }
}

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key});

  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner>
    with SingleTickerProviderStateMixin {
  final QRCodeController qrController = Get.put(QRCodeController());
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Lặp lại animation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: SafeArea(
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.kRadius),
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.kRadius),
              ),
              child: Stack(
                children: [
                  QRView(
                    key: qrKey,
                    onQRViewCreated: (QRViewController controller) {
                      controller.scannedDataStream.listen((scanData) {
                        qrController.handleScannedData(scanData.code);
                      });
                    },
                  ),
                  // Animation và vẽ 4 góc nhỏ
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Stack(
                            children: [
                              // Vẽ 4 góc nhỏ
                              Positioned(
                                top: 10,
                                left: 10,
                                child: _buildCorner(),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: _buildCorner(),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: _buildCorner(),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: _buildCorner(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Hàm vẽ một góc nhỏ
  Widget _buildCorner() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
