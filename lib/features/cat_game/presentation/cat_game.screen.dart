import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:love_quest/core/config/routes.dart';
import 'package:love_quest/core/config/theme.dart';
import 'cat_game.controller.dart';

class CatGameScreen extends GetView<CatGameController> {
  const CatGameScreen({super.key});

  void _showWinnerDialog(String winner) {
    Get.defaultDialog(
      title: 'Congratulations! 🎉',
      middleText: '$winner wins the game!',
      barrierDismissible: false,
      confirm: TextButton(
        onPressed: () => Get.offAndToNamed(AppRoutes.quiz_game),
        child: const Text('Next Game'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final foodCenterY = screenHeight / 2;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'LoveQuest',
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'Kaushan',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Obx(
              () => Row(
                children: [
                  Text('🖤 ${controller.blackPoints.value}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 16),
                  Text('🧡 ${controller.orangePoints.value}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.schedule_offer);
                    },
                    icon: Icon(Icons.schedule, color: Colors.white,))
                ],
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/game-art/floor.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Food in center
            Obx(() => controller.isFoodVisible.value
                ? Positioned(
              top: foodCenterY - 80,
              left: screenWidth / 2 - 50,
              child: Image.asset(
                controller.isGoodFood.value
                    ? 'assets/game-art/food.png'
                    : 'assets/game-art/fish-bone.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            )
                : Container()),

            // Black cat paw
            Positioned(
              top: 50,
              left: screenWidth / 2 - 100,
              child: SlideTransition(
                position: controller.blackAnimation,
                child: Transform.rotate(
                  angle: 3.14,
                  child: Image.asset(
                    'assets/game-art/black-cat-paw.png',
                    width: 200,
                    height: 250,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),

            // Orange cat paw
            Positioned(
              bottom: 50,
              left: screenWidth / 2 - 100,
              child: SlideTransition(
                position: controller.orangeAnimation,
                child: Image.asset(
                  'assets/game-art/orange-cat-paw.png',
                  width: 200,
                  height: 250,
                  fit: BoxFit.fill,
                ),
              ),
            ),

            // Single button (middle right side)
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 40,
              right: 40,
              child: GestureDetector(
                onTap: () {
                  // Randomly choose which cat paw to animate
                  bool isOrange = controller.role.value == 'orange';
                  controller.animateCat(
                    isOrange: isOrange,
                  );
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.black],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.play_arrow, color: Colors.white, size: 40),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
