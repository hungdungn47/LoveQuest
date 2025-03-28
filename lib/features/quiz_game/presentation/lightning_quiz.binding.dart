import 'package:get/get.dart';
import 'package:love_quest/features/quiz_game/presentation/lightning_quiz.controller.dart';

class LightningQuizBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(LightningQuizController());
  }
}
