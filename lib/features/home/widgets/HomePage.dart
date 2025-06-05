import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:love_quest/core/config/routes.dart';
import 'package:love_quest/features/home/presentation/home.controller.dart';
import 'package:love_quest/features/home/widgets/PageViewItem.dart';

import '../../../core/config/theme.dart';
import '../../../widgets/Appbar.dart';

class HomePageView extends StatelessWidget {
  final HomeController controller;
  const HomePageView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
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
        SizedBox(
          height: 32,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                return AnimatedSwitcher(
                  duration: const Duration(
                      milliseconds: 500), // thời gian chuyển mượt
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation, // hiệu ứng fade mờ
                      child: child,
                    );
                  },
                  child: controller.isLoading.value
                      ? Column(
                          key: ValueKey('loading'),
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                              SizedBox(
                                  height: 400,
                                  width: 400,
                                  child: Lottie.asset(
                                      'assets/animations/animation.json')),
                              const SizedBox(height: 20),
                              AnimatedTextKit(
                                animatedTexts: [
                                  ColorizeAnimatedText(
                                    "Waiting for finding suitable partner",
                                    textStyle: Styles.mediumTextW700,
                                    colors: [
                                      Colors.blue,
                                      Colors.red,
                                      Colors.green,
                                      Colors.purple,
                                    ],
                                  ),
                                ],
                                isRepeatingAnimation: true,
                                repeatForever: true,
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              CircularProgressIndicator(
                                strokeWidth: 6,
                                color: AppColors.primary,
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.handleCancelMatching();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 24),
                                  decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    "Cancel",
                                    style: Styles.mediumTextW800
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ])
                      : Column(
                          key: ValueKey('normal'),
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 86,
                                ),
                                Stack(
                                  children: [
                                    SizedBox(
                                      height: 400,
                                      child: PageView(
                                        controller: controller.pageController,
                                        onPageChanged: (index) {
                                          controller.updateCurrentIndex(index);
                                        },
                                        children: [
                                          PageViewItem(
                                              title: "You want to date",
                                              imageUrl:
                                                  "assets/images/date.png"),
                                          PageViewItem(
                                              title:
                                                  "But you’re always awkward in conversations?",
                                              imageUrl:
                                                  "assets/images/gotcha.png"),
                                          PageViewItem(
                                              title:
                                                  "That's why we're here for you",
                                              imageUrl:
                                                  "assets/images/user.png"),
                                          PageViewItem(
                                              title:
                                                  "Let’s play games to find your soulmate!",
                                              imageUrl:
                                                  "assets/images/game.png"),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 180,
                                      left: 18,
                                      child: GestureDetector(
                                        onTap: controller.handlePreviousPage,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: AppColors.btnBg,
                                              borderRadius:
                                                  BorderRadius.circular(24)),
                                          child: FittedBox(
                                            child: Icon(
                                              Icons.arrow_back_ios,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 180,
                                      right: 18,
                                      child: GestureDetector(
                                        onTap: controller.handleNextPage,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: AppColors.btnBg,
                                              borderRadius:
                                                  BorderRadius.circular(24)),
                                          child: FittedBox(
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Obx(() {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (int i = 0; i < 4; i++)
                                        GestureDetector(
                                          onTap: () {
                                            controller.goToPageSmooth(i);
                                          },
                                          child: Container(
                                            height: 12,
                                            width: 12,
                                            margin: EdgeInsets.only(
                                                right: 8, left: 8),
                                            decoration: BoxDecoration(
                                                color: controller.currentIndex
                                                            .value ==
                                                        i
                                                    ? AppColors.primary
                                                    : Colors.black12,
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                          ),
                                        ),
                                    ],
                                  );
                                })
                              ],
                            ),
                            SizedBox(
                              height: 48,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.handleShowAds();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 24),
                                decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  "Find Partner",
                                  style: Styles.mediumTextW800
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                );
              }),
            ],
          ),
        )
      ],
    );
  }
}
