import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/theme.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_button.dart';

class InterestsScreen extends StatelessWidget {
  final List<String> interests = [
    'Books',
    'Gym',
    'Cycling',
  ];

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
                'What are you interested in?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Obx(() => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: interests.map((interest) {
                      final isSelected =
                          authController.selectedInterests.contains(interest);
                      return GestureDetector(
                        onTap: () => authController.toggleInterest(interest),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            interest,
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )),
              Spacer(),
              CustomButton(
                text: 'Start dating',
                onPressed: () {
                  if (authController.selectedInterests.isNotEmpty) {
                    authController.completeOnboarding();
                  } else {
                    Get.snackbar(
                      'Error',
                      'Please select at least one interest',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
