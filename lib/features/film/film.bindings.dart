import 'package:get/get.dart';
import 'package:love_quest/features/film/film.controller.dart';

class FilmBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<FilmController>(FilmController());
  }
}