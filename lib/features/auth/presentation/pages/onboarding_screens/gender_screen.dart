import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/theme.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/next_button.dart';

class GenderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
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
                'How do you identify?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Obx(() => Column(
                    children: [
                      _buildGenderOption(
                        'Male',
                        authController.selectedGender.value == 'Male',
                        () => authController.selectedGender.value = 'Male',
                      ),
                      SizedBox(height: 16),
                      _buildGenderOption(
                        'Female',
                        authController.selectedGender.value == 'Female',
                        () => authController.selectedGender.value = 'Female',
                      ),
                    ],
                  )),
              Spacer(),
              Center(
                child: NextButton(
                  onPressed: () {
                    if (authController.selectedGender.value.isNotEmpty) {
                      authController
                          .setGender(authController.selectedGender.value);
                    } else {
                      Get.snackbar(
                        'Error',
                        'Please select your gender',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption(
      String gender, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              gender,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.text,
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
