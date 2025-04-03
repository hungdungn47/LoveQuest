import 'package:flutter/material.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/theme.dart';
import 'package:love_quest/features/draw_game/presentations/draw_game.controller.dart';
import 'package:love_quest/widgets/Appbar.dart';

class DrawGameView extends GetView<DrawGameController> {
  const DrawGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarCustomize(
                title: 'Gaming Room',
              ),
              SizedBox(
                height: 32,
              ),
              Padding(
                padding: EdgeInsets.only(left: 24),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 24, right: 24),
                      // width: MediaQuery.of(context).size.width - 48,
                      height: 18,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    Positioned(
                      left: 0,
                      child: Container(
                        width: 96,
                        height: 18,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 48,
              ),
              Container(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's draw something cute",
                      style: Styles.bigTextW800,
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Center(
                      child: Obx(() {
                        return Container(
                          width: 400,
                          height: 400,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18)),
                          child: IgnorePointer(
                            ignoring: controller.isYourTurn.value,
                            child: Listener(
                              onPointerUp: (event) {
                                controller.sendDataToAnother();
                              },
                              child: FlutterPainter(
                                  controller: controller.painterController!),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Text(
                      "Tell us what it is. She won't know it",
                      style: Styles.bigTextW800,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12), // Bo góc cho Container
                        // border: Border.all(color: AppColors.primary), // Thêm viền nếu cần
                      ),
                      child: TextField(
                        style: Styles.mediumTextW500,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12), // Bo góc cho TextField
                            borderSide: BorderSide(color: AppColors.primary), // Viền mặc định
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12), // Bo góc khi chưa focus
                            borderSide: BorderSide(color: Colors.transparent), // Màu viền khi chưa focus
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12), // Bo góc khi focus
                            borderSide: BorderSide(color: AppColors.primary, width: 2), // Viền khi focus
                          ),
                          filled: true, // Bật nền
                          fillColor: Colors.white, // Màu nền của TextField
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
