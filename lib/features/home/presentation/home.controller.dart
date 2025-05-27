import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/routes.dart';
import 'package:love_quest/core/global/global.controller.dart';
import 'package:love_quest/features/auth/presentation/controllers/auth_controller.dart';
import 'package:love_quest/core/config/events.dart';
import 'package:love_quest/core/socket/socket_service.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomeController extends GetxController {
  final SocketService _socketService = SocketService();
  final PersistentTabController _persistentTabController = PersistentTabController(initialIndex: 0);
  final PageController _pageController = PageController();
  final AuthController _authController = Get.find<AuthController>();
  final GlobalController _globalController = Get.find<GlobalController>();
  PageController get pageController => _pageController;
  PersistentTabController get persistentTabController =>
      _persistentTabController;
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    handleInit();
  }

  Future<void> handleInit() async {
    await _socketService.connect();
    _socketService.sendMessage('register', {'userId': _authController.user.value.id});
    _socketService.sendMessage('online', {"userId": _authController.user.value.id, "gender": _authController.user.value.gender});
    listenMatchingEvent();
  }

  void updateCurrentIndex(int val) {
    currentIndex.value = val;
  }

  void handleNextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void handlePreviousPage() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void goToPageSmooth(int index) {
    updateCurrentIndex(index);
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void handleFindPartner() {
    isLoading.value = true;
    print("Gender is ${_authController.user.value.gender}");
    _socketService.sendMessage(EventName.online, {"userId": _authController.user.value.id, "gender": _authController.user.value.gender});
    _socketService.sendMessage(EventName.matching, {
      "userId": _authController.user.value.id,
      "gender": _authController.user.value.gender,
      // "userId": "456",
      // "gender": "MALE",
    });
  }

  void listenMatchingEvent() {
    print("Listening matching event");
    _socketService.listenToMessages(EventName.matching, (data) {
      print("Hello");
      print(data["roomId"]);
      String roomId = data["roomId"];
      isLoading.value = false;
      _globalController.roomId.value = roomId;
      print('Global controller room id: ${_globalController.roomId.value}');
      Get.toNamed(AppRoutes.cat_game);
      // _joinRoom(roomId);
    });
  }

  void handleCancelMatching() {
    isLoading.value = false;
    _socketService.sendMessage(EventName.cancel, {
      "userId": _authController.user.value.id,
      "gender": _authController.user.value.gender,
      // "userId": "456",
      // "gender": "MALE",
    });
  }
}