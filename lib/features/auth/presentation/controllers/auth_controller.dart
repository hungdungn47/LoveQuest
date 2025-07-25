import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/routes.dart';
import 'package:love_quest/core/resources/data_state.dart';
import 'package:love_quest/core/storage/local_storage.dart';
import 'package:love_quest/features/auth/domain/entities/user.dart';
import 'package:love_quest/features/auth/domain/repository/user_repository.dart';
import 'package:love_quest/features/auth/domain/usecases/get_profile.dart';
import 'package:love_quest/features/auth/domain/usecases/signup.dart';
import 'package:love_quest/features/auth/domain/usecases/login.dart';
import 'package:love_quest/features/auth/domain/usecases/verify_otp.dart';
import 'package:logger/logger.dart';

class AuthController extends GetxController {
  final Rx<UserEntity> user = UserEntity().obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  final RxBool isLoggedIn = false.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedGender = ''.obs;
  final RxList<String> selectedInterests = <String>[].obs;

  var logger = Logger();

  Future<void> getProfile() async {
    try {
      // isLoading.value = true;
      final getProfileUseCase = Get.find<GetProfileUseCase>();
      final result = await getProfileUseCase.call(NoParams());

      if (result is DataSuccess) {
        logger.i('Got user profile: ${result.data}');
        if (result.data != null) {
          logger.i('Result data:: ${result.data?.gender}');
          isLoggedIn.value = true;
          user.value = result.data!;
        }
        logger.i('User gender in controller: ${user.value.gender}');
      } else if (result is DataFailed) {
        // Get.offAllNamed(AppRoutes.login);
        logger.i('Failed getting user profile');
        isLoggedIn.value = false;
      }
    } catch (e) {
      // Get.offAllNamed(AppRoutes.login);
      logger.i('Failed getting user profile');
      isLoggedIn.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addFcmToken() async {
    try {
      final UserRepository userRepository = Get.find<UserRepository>();
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      logger.i('FCM token: $fcmToken');
      final result = await userRepository.addToken(newToken: fcmToken!);
    } catch (e) {
      logger.e('Failed adding fcm token');
    }
  }

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
      print('Controller: Starting signup process');

      final signupUseCase = Get.find<SignupUseCase>();
      final result = await signupUseCase.call(SignupParams(
        userName: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
      ));

      logger.i('Controller: Signup result: $result');

      if (result is DataSuccess) {
        user.value = UserEntity(
          email: emailController.text,
          nickName: usernameController.text,
        );
        Get.toNamed(AppRoutes.otp);
      } else if (result is DataFailed) {
        Get.snackbar('Error', result.exception.toString(),
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      logger.e('Controller: Signup error: $e');
      Get.snackbar('Error', 'An unexpected error occurred: $e',
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
      print('Controller: Starting login process');

      final loginUseCase = Get.find<LoginUseCase>();
      final result = await loginUseCase.call(LoginUserParams(
        email: emailController.text,
        password: passwordController.text,
      ));

      logger.i('Controller: Login result: ${result.data}');
      logger.i('Access token saved: ${LocalStorage().readData('accessToken')}');

      final userData = result.data?['user'];
      if (result is DataSuccess) {
        user.value = UserEntity(
          email: userData['email'] ?? emailController.text,
          nickName: userData['userName'] ?? '',
          fullName: userData['fullName'] ?? '',
          id: userData['_id'] ?? '',
          avatar: userData['avatar'] ?? '',
          gender: userData['gender'] ?? '',
        );
        logger.i('Gender: ${user.value.gender}');
        Get.offAllNamed(AppRoutes.home);
      } else if (result is DataFailed) {
        Get.snackbar('Error', result.exception.toString(),
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Controller: Login error: $e');
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String otp) async {
    try {
      final verifyOtpUsecase = Get.find<VerifyOtpUseCase>();
      await verifyOtpUsecase.call(VerifyOtpParams(email: emailController.text, otp: otp));
      Get.offNamed(AppRoutes.name);
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void setName(String name) {
    user.update((val) {
      val?.nickName = name;
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
      val?.gender = gender;
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
    Get.offAllNamed(AppRoutes.home);
    // Get.offNamed(AppRoutes.home);
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
