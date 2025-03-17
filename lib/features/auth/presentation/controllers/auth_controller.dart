import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/routes.dart';
import 'package:love_quest/features/auth/domain/entities/user.dart';

class AuthController extends GetxController {
  final Rx<UserEntity> user = UserEntity().obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString selectedGender = ''.obs;
  final RxList<String> selectedInterests = <String>[].obs;

  void signup() async {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;

      // Here you would integrate with your auth service
      // For demo purposes, we'll just move to the next screen
      await Future.delayed(Duration(seconds: 1));

      user.value = UserEntity(
        email: emailController.text,
        nickName: usernameController.text,
      );

      Get.toNamed(AppRoutes.name);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;

      // Here you would integrate with your auth service
      // For demo purposes, we'll just move to the next screen
      await Future.delayed(Duration(seconds: 1));

      user.value = UserEntity(
        email: emailController.text,
      );

      Get.toNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void setName(String name) {
    user.update((val) {
      // val?.nickName = name;
    });
    Get.toNamed(AppRoutes.gender);
  }

  void setBirthday(String birthday) {
    user.update((val) {
      // val?.birthday = birthday;
    });
    Get.toNamed(AppRoutes.gender);
  }

  void setGender(String gender) {
    selectedGender.value = gender;
    user.update((val) {
      // val?.gender = gender;
    });
    Get.toNamed(AppRoutes.interests);
  }

  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }

    user.update((val) {
      // val?.interests = selectedInterests;
    });
  }

  void completeOnboarding() {
    // In a real app, you would save the user profile to backend
    Get.toNamed(AppRoutes.home);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    fullNameController.dispose();
    birthdayController.dispose();
    super.onClose();
  }
}