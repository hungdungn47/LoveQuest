import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../core/config/routes.dart';
import '../../controllers/auth_controller.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController otpController = TextEditingController();

  void verifyOtp() async {
    final otp = otpController.text.trim();
    if (otp.length != 8) {
      Get.snackbar('Error', 'OTP must be 8 digits',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    authController.verifyOtp(otp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Enter the 8-digit OTP sent to your email',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            PinCodeTextField(
              appContext: context,
              length: 8,
              controller: otpController,
              keyboardType: TextInputType.number,
              onChanged: (_) {},
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: verifyOtp,
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
