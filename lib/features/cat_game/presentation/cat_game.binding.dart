import 'package:get/get.dart';
import 'package:love_quest/features/cat_game/presentation/cat_game.controller.dart';

class CatGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CatGameController>(() => CatGameController());
  }
}
