import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomeController extends GetxController {
  final PersistentTabController _persistentTabController = PersistentTabController(initialIndex: 0);
  final PageController _pageController = PageController();
  PageController get pageController => _pageController;
  PersistentTabController get persistentTabController => _persistentTabController;
  RxInt currentIndex = 0.obs;
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
}