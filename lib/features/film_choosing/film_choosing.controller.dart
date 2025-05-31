import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:love_quest/core/config/events.dart';
import 'package:love_quest/core/config/routes.dart';
import 'package:love_quest/core/global/global.controller.dart';
import 'package:love_quest/core/socket/socket_service.dart';
import 'package:love_quest/features/auth/presentation/controllers/auth_controller.dart';
import 'package:love_quest/features/film_choosing/services/filmChoosingService.dart';

import 'entity/film.dart';

class FilmChoosingController extends GetxController {
  RxInt current = 0.obs;

  final CarouselSliderController _carouselSliderController =
      CarouselSliderController();

  final SocketService _socketService = SocketService();

  final GlobalController _globalController = Get.find<GlobalController>();

  final AuthController _authController = Get.find<AuthController>();

  RxBool canChoose = false.obs;

  final List<String> _imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  List<String> get imgList => _imgList;

  CarouselSliderController get carouselSliderController =>
      _carouselSliderController;

  GlobalController get globalController => _globalController;

  final IFilmChoosingService apiService = Get.find<IFilmChoosingService>();

  Rxn<List<String>> types = Rxn<List<String>>();

  Rxn<List<Film>> recommendationFilms = Rxn<List<Film>>();

  Rxn<List<Film>> films = Rxn<List<Film>>();

  RxBool isLoading = false.obs;

  RxBool isTypeChange = false.obs;

  RxString currentType = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    handleInit();

    _handleReceiveChoosingFilm();
  }

  Future<void> handleInit() async {
    isLoading.value = true;
    await _socketService.connect();
    _socketService.sendMessage("joinRoom", "123456");
    // canChoose.value = _globalController.gender.value == 'FEMALE';
    canChoose.value = _authController.user.value.gender == 'FEMALE';
    await loadData();
    isLoading.value = false;
  }

  Future<void> loadData() async {
    final results = await Future.wait([
      apiService.getTypeOfFilm(),
      apiService.getTopsFilm(),
    ]);

    types.value = results[0] as List<String>;

    recommendationFilms.value = results[1] as List<Film>;

    films.value = await apiService.getFilmByType(types.value![0]);

    currentType.value = types.value![0];

    print("Hello ${types.value}");
    print("Hello1 ${recommendationFilms.value}");
    print("Hello2 ${films.value}");
  }

  Future<void> changeType(String type) async {
    isTypeChange.value = true;
    currentType.value = type;
    films.value = await apiService.getFilmByType(type);
    isTypeChange.value = false;
  }

  void changeCurrentIndex(int index) {
    current.value = index;
  }

  void handleChoosingFilm(Film item) {
    _socketService.sendMessage(EventName.filmChoosing, {
      // "roomId": "123456",
      "roomId": _globalController.roomId.value,
      "filmUrl": item.filmUrl,
      "filmName": item.name,
    });
  }

  void _handleReceiveChoosingFilm() {
    _socketService.listenToMessages(EventName.filmChoosing, (data) {
      print("Choose Film Successfully");
      final String filmUrl = data["filmUrl"];
      final String filmName = data["filmName"];
      print('Film Choosed - ${filmUrl} - ${filmName}');
      Get.toNamed(AppRoutes.film, arguments: {
        "filmUrl": filmUrl,
        "filmName": filmName
      });
    });
  }
}
