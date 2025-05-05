import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/socket/socket_service.dart';

class CatGameController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController orangeController;
  late AnimationController blackController;
  late Animation<Offset> orangeAnimation;
  late Animation<Offset> blackAnimation;
  final RxBool isFoodVisible = false.obs;
  final RxBool isGoodFood = true.obs;
  final RxInt orangePoints = 0.obs;
  final RxInt blackPoints = 0.obs;
  final RxBool isAnimating = false.obs;

  final AudioPlayer audioPlayer = AudioPlayer();

  final SocketService _socketService = SocketService();

  Timer? foodTimer;
  // Timer? hideTimer;

  @override
  void onInit() {
    super.onInit();
    _socketService.connect();
    orangeController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    blackController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    orangeAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.6),
    ).animate(CurvedAnimation(
      parent: orangeController,
      curve: Curves.linear,
    ));

    blackAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.6),
    ).animate(CurvedAnimation(
      parent: blackController,
      curve: Curves.linear,
    ));

    _startFoodCycle();
  }

  void _startFoodCycle() {
    foodTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      isFoodVisible.value = true;
      isGoodFood.value = Random().nextBool();

      // hideTimer = Timer(const Duration(seconds: 2), () {
      //   isFoodVisible.value = false;
      // });
    });
  }

  void animateCat({required bool isOrange, required VoidCallback onWin}) {
    if (isAnimating.value) return;
    isAnimating.value = true;

    final controller = isOrange ? orangeController : blackController;
    final points = isOrange ? orangePoints : blackPoints;

    controller.forward().then((_) {
      if (isFoodVisible.value) {
        isFoodVisible.value = false;
        points.value += isGoodFood.value ? 1 : -2;
        if (points.value >= 3) {
          onWin();
        }
        _playSound(isGoodFood.value);
      }
      Future.delayed(const Duration(milliseconds: 50), () {
        controller.reverse().then((_) => isAnimating.value = false);
      });
    });
  }

  Future<void> _playSound(bool isGood) async {
    try {
      await audioPlayer
          .play(AssetSource('sfx/${isGood ? 'correct' : 'wrong'}.wav'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  @override
  void onClose() {
    orangeController.dispose();
    blackController.dispose();
    foodTimer?.cancel();
    // hideTimer?.cancel();
    audioPlayer.dispose();
    super.onClose();
  }
}
