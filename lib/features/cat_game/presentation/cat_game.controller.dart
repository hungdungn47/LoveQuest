import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/global/global.controller.dart';
import 'package:love_quest/core/socket/socket_service.dart';
import 'package:logger/logger.dart';
// import 'package:love_quest/features/auth/domain/entities/user.dart';
import 'package:love_quest/features/auth/presentation/controllers/auth_controller.dart';

import '../../../core/config/routes.dart';

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
  final RxString gameId = ''.obs;
  final RxString clientId = ''.obs;
  final RxString role = ''.obs;

  final AudioPlayer audioPlayer = AudioPlayer();
  final GlobalController globalController = Get.find<GlobalController>();

  final SocketService _socketService = SocketService();

  var logger = Logger();

  Timer? foodTimer;
  // Timer? hideTimer;

  Future<void> _initializeGameSocket() async {
    logger.i('Connecting...');
    final AuthController _authController = Get.find<AuthController>();

    // Await socket connection
    await _socketService.connect();

    // Send the ready message AFTER connection is established
    _socketService.sendMessage(
        'fish_hunter_ready', {'roomId': globalController.roomId.value, 'userId': _authController.user.value.id});

    // Now listen to events
    _socketService.listenToMessages('fish_hunter_assigned', (data) {
      if(clientId.value == '') {
        clientId.value = data['clientId'];

      }
      if(clientId.value == data['clientId']) {
        role.value = data['role'];
        logger.i('Assigned role: $data');
      }
    });

    _socketService.listenToMessages('fish_hunter_start', (data) {
      logger.i('Received data: $data');
    });

    _socketService.listenToMessages('fish_hunter_showItem', (data) {
      isFoodVisible.value = true;
      gameId.value = data['gameId'];
      logger.i('Show item: $data');
      isGoodFood.value = data['type'] == 'FISH';
    });

    _socketService.listenToMessages('fish_hunter_notifyGameAnswer', (data) {
      isFoodVisible.value = false;
      if(data['clientId'] == clientId.value) {
        if(role.value == 'orange') {
          orangePoints.value += data['point'] as int;
        } else {
          blackPoints.value += data['point'] as int;
        }
      } else {
        if(role.value == 'orange') {
          blackPoints.value += data['point'] as int;
        } else {
          orangePoints.value += data['point'] as int;
        }
      }
      if (orangePoints.value >= 3 || blackPoints.value >= 3) {
        onWin();
      }
      _playSound(isGoodFood.value);
    });

    _socketService.listenToMessages('fish_hunter_gameOver', (data) {
      orangePoints.value = 0;
      blackPoints.value = 0;
      showWinningDialog(blackPoints.value > orangePoints.value ? 'Black cat' : 'Orange cat');
    });
  }

  void onWin() {
    String winner;
    if (blackPoints.value > orangePoints.value) {
      winner = 'Black cat';
    } else {
      winner = 'Orange cat';
    }
    _socketService.sendMessage('fish_hunter_gameOver', {
      "roomId": globalController.roomId.value,
      "clientId": clientId.value,
    });
  }

  void showWinningDialog(String winner) {
    Get.defaultDialog(
      title: 'Congratulations! 🎉',
      middleText: '$winner wins the game!',
      barrierDismissible: false,
      confirm: TextButton(
        onPressed: () {
          Get.offAndToNamed(AppRoutes.quiz_game);
        },
        child: const Text('Next Game'),
      ),
    );
  }

  @override
  void onInit() {
    super.onInit();
    _initializeGameSocket();
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
  }

  void animateCat({required bool isOrange}) {
    if (isAnimating.value) return;
    isAnimating.value = true;

    final roleOrange = role.value == 'orange';

    final controller = roleOrange ? orangeController : blackController;

    controller.forward().then((_) {
      _socketService.sendMessage('fish_hunter_answer', {
        'gameId': gameId.value,
        'roomId': globalController.roomId.value,
        'message': 'tapped the food',
      });
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
    _socketService.sendMessage('fish_hunter_leaveRoom', {
      'clientId': clientId.value
    });
    _socketService.disconnect();
    super.onClose();
  }
}
