import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final PageController _pageController = PageController();
  PageController get pageController => _pageController;
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