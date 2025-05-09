import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/routes.dart';
import 'package:love_quest/core/config/theme.dart';
import 'package:love_quest/features/quiz_game/presentation/lightning_quiz.controller.dart';
import 'package:love_quest/features/quiz_game/presentation/widgets/outlined_button.dart';
import 'package:love_quest/features/quiz_game/presentation/widgets/progress_bar.dart';
import 'package:love_quest/features/quiz_game/presentation/widgets/circular_timer.dart';
import 'package:love_quest/features/quiz_game/presentation/widgets/completion_modal.dart';

class LightningQuizScreen extends GetView<LightningQuizController> {
  const LightningQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Get.offAllNamed(AppRoutes.home),
        ),
        title: Text(
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
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Progress section
                Column(
                  children: [
                    Obx(
                      () => CustomProgressBar(
                        width: MediaQuery.of(context).size.width - 48,
                        progress: controller.progress,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.quiz,
                                  color: AppColors.primary, size: 24),
                              const SizedBox(width: 12),
                              Obx(
                                () => Text(
                                  'Question ${controller.currentQuizIndex.value + 1}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircularTimer(controller: controller),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 40),
                // Quiz content section
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 48,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Obx(
                          () => Text(
                            controller.getCurrentQuiz.question!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Obx(
                        () => CustomOutlinedButton(
                          text: controller.getCurrentQuiz.option1!,
                          isSelected: controller.selectedOption.value ==
                              controller.getCurrentQuiz.option1,
                          onPressed: () {
                            controller
                                .submitQuiz(controller.getCurrentQuiz.option1!);
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => CustomOutlinedButton(
                          text: controller.getCurrentQuiz.option2!,
                          isSelected: controller.selectedOption.value ==
                              controller.getCurrentQuiz.option2,
                          onPressed: () {
                            controller
                                .submitQuiz(controller.getCurrentQuiz.option2!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => controller.isCompleted.value
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CompletionModal(
                        questions: controller.quizList,
                        answers: controller.answers,
                        onProceed: () {
                          // TODO: Navigate to next game
                          Get.back();
                        },
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
