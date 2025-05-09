import 'package:get/get.dart';
import 'package:love_quest/features/draw_game/presentations/draw_game.controller.dart';

class DrawGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DrawGameController>(DrawGameController());
  }

}