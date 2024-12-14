import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  var phoneNumber = ''.obs;
  var otp = ''.obs;
  var verificationId = ''.obs;
  var isOtpSent = false.obs;
  var isLoading = false.obs;

  // Gửi OTP
  void sendOtp(String phone) async {
    isLoading(true);
  }

  // Xác thực OTP
  void verifyOtp(String otp) async {
    isLoading(true);
  }
}
