import 'package:get/get.dart';
import 'package:love_quest/features/profile/presentations/profile.controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController());
  }

}