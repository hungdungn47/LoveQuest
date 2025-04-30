import 'package:get/get.dart';
import 'package:love_quest/features/film_choosing/film_choosing.controller.dart';

class FilmChoosingBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<FilmChoosingController>(FilmChoosingController());
  }
}