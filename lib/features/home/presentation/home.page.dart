import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/theme.dart';
import 'package:love_quest/features/home/presentation/home.controller.dart';
import 'package:love_quest/widgets/Appbar.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBarCustomize(title: "LoveQuest"),
          SizedBox(
            height: 32,
          ),
          Column(
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
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "You want to date",
                                    style: Styles.bigTextW700,
                                  ),
                                  SizedBox(
                                    height: 32,
                                  ),
                                  Image.asset("assets/images/date.png")
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "But you’re always awkward in conversations?",
                                    style: Styles.bigTextW700,
                                  ),
                                  SizedBox(
                                    height: 32,
                                  ),
                                  Image.asset("assets/images/gotcha.png")
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "That's why we're here for you",
                                    style: Styles.bigTextW700,
                                  ),
                                  SizedBox(
                                    height: 32,
                                  ),
                                  Image.asset("assets/images/user.png")
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Let’s play games to find your soulmate!",
                                    style: Styles.bigTextW700,
                                  ),
                                  SizedBox(
                                    height: 32,
                                  ),
                                  Image.asset("assets/images/game.png")
                                ],
                              ),
                            )
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
                              borderRadius: BorderRadius.circular(24)
                            ),
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
                                borderRadius: BorderRadius.circular(24)
                            ),
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
                        for(int i = 0; i < 4; i++)
                          GestureDetector(
                            onTap: () {
                              controller.goToPageSmooth(i);
                            },
                            child: Container(
                              height: 12,
                              width: 12,
                              margin: EdgeInsets.only(right:8 , left: 8),
                              decoration: BoxDecoration(
                                  color: controller.currentIndex.value == i ? AppColors.primary : Colors.black12,
                                  borderRadius: BorderRadius.circular(16)
                              ),
                            ),
                          ),
                      ],
                    );
                  })
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
