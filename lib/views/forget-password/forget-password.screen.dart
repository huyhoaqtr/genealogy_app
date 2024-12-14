import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'forget-password.controller.dart';

class ForgetPasswordScreen extends GetView<ForgetPasswordController> {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone Verification")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Obx(() {
          return Column(
            children: [
              TextField(
                controller: controller.phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              controller.isOtpSent.value
                  ? Column(
                      children: [
                        TextField(
                          controller: controller.otpController,
                          decoration: InputDecoration(labelText: 'OTP'),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            controller.verifyOtp(controller.otpController.text);
                          },
                          child: Text('Verify OTP'),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () {
                        controller.sendOtp(controller.phoneController.text);
                      },
                      child: Text('Send OTP'),
                    ),
              controller.isLoading.value
                  ? CircularProgressIndicator()
                  : SizedBox.shrink(),
            ],
          );
        }),
      ),
    );
  }
}
