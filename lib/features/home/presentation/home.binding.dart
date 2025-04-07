import 'package:get/get.dart';
import 'package:love_quest/features/profile/presentations/profile.page.dart';
import 'package:love_quest/features/chat/presentation/chat_controller.dart';
import 'package:love_quest/features/schedule/presentation/schedule_controller.dart';
import 'home.controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(ProfilePage());
    Get.put(ChatController());
    Get.put(ScheduleController());
  }
}
