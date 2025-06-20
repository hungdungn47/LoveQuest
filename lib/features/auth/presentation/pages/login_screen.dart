import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/routes.dart';
import 'package:love_quest/core/config/theme.dart';
import 'package:love_quest/features/auth/presentation/controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      // Text(
                      //   'Welcome to',
                      //   style: TextStyle(
                      //     fontSize: 20,
                      //     color: AppColors.secondary,
                      //   ),
                      // ),
                      Text(
                        'LoveQuest',
                        style: TextStyle(
                          fontSize: 42,
                          fontFamily: 'Kaushan',
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Login .',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: 'email',
                  controller: authController.emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  hintText: 'password',
                  controller: authController.passwordController,
                  obscureText: true,
                ),
                SizedBox(height: 20),
                Obx(() => CustomButton(
                      text: 'Login',
                      onPressed: authController.login,
                      isLoading: authController.isLoading.value,
                    )),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        color: AppColors.lightText,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.signup),
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
