import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final RxInt currentStep = 0.obs;

  void nextStep() {
    currentStep.value++;
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }
}