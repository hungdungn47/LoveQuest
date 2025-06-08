import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/theme.dart';
import 'package:love_quest/features/auth/presentation/widgets/custom_button.dart';
import '../controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LoveQuest',
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'Kaushan',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to LoveQuest!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 20),
              Obx(() => Text(
                    'Name: ${authController.user.value.nickName ?? "Not set"}',
                    style: TextStyle(fontSize: 18),
                  )),
              SizedBox(height: 8),
              Obx(() => Text(
                    'Gender: ${authController.user.value.gender ?? "Not set"}',
                    style: TextStyle(fontSize: 18),
                  )),
              SizedBox(height: 8),
              // Obx(() => Text(
              //   'Birthday: ${authController.user.value.birthday ?? "Not set"}',
              //   style: TextStyle(fontSize: 18),
              // )),
              // SizedBox(height: 8),
              // Obx(() => Text(
              //   'Interests: ${authController.user.value.interests?.join(", ") ?? "None selected"}',
              //   style: TextStyle(fontSize: 18),
              // )),
              CustomButton(text: 'Find partner', onPressed: () => {})
            ],
          ),
        ),
      ),
    );
  }
}
