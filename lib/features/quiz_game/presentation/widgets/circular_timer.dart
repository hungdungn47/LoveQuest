import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/theme.dart';
import 'package:love_quest/features/quiz_game/presentation/lightning_quiz.controller.dart';

class CircularTimer extends StatelessWidget {
  final LightningQuizController controller;
  const CircularTimer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Obx(() => SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: controller.remainingTimeInSeconds / 5,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  strokeWidth: 6,
                  strokeCap: StrokeCap.round,
                ),
              )),
          Obx(() => Text(
                '${controller.remainingTimeInSeconds}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )),
        ],
      ),
    );
  }
}
