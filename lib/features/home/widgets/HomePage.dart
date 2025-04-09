import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        AppBarCustomize(title: "LoveQuest"),
        SizedBox(
          height: 32,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
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
                                imageUrl: "assets/images/date.png"),
                            PageViewItem(
                                title:
                                    "But you’re always awkward in conversations?",
                                imageUrl: "assets/images/gotcha.png"),
                            PageViewItem(
                                title: "That's why we're here for you",
                                imageUrl: "assets/images/user.png"),
                            PageViewItem(
                                title:
                                    "Let’s play games to find your soulmate!",
                                imageUrl: "assets/images/game.png"),
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
                                borderRadius: BorderRadius.circular(24)),
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
                                borderRadius: BorderRadius.circular(24)),
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
                              margin: EdgeInsets.only(right: 8, left: 8),
                              decoration: BoxDecoration(
                                  color: controller.currentIndex.value == i
                                      ? AppColors.primary
                                      : Colors.black12,
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                      ],
                    );
                  })
                ],
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.cat_game);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    "Find Partner",
                    style: Styles.mediumTextW800.copyWith(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 64,
              )
            ],
          ),
        )
      ],
    );
  }
}
