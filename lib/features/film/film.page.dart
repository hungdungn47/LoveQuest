import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:love_quest/features/film/film.controller.dart';
import 'package:video_player/video_player.dart';

import '../../core/config/theme.dart';
import '../../widgets/Appbar.dart';

class FilmPage extends GetView<FilmController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isVideoInitialized.value) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Phần hiển thị AppBar khi ở chế độ dọc
                Obx(() {
                  if (controller.isVertical.value) {
                    return Column(
                      children: [
                        AppBarCustomize(title: 'Film'),
                        SizedBox(height: 60),
                        Center(
                          child: Text(
                            controller.filmName.value,
                            style: Styles.bigTextW700.copyWith(fontSize: 32),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 80,
                        )
                      ],
                    );
                  }
                  return SizedBox();
                }),
                // Phần video và controller
                Obx(() {
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: controller.handleOnTap,
                        onDoubleTap: controller.togglePlayPause,
                        child: controller.isVertical.value
                            ? AspectRatio(
                                aspectRatio: controller
                                    .videoController.value.aspectRatio,
                                child: VideoPlayer(controller.videoController),
                              )
                            : FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child:
                                      VideoPlayer(controller.videoController),
                                ),
                              ),
                      ),
                      // Thanh điều khiển video
                      Obx(() {
                        return Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedOpacity(
                            opacity: controller.showControllerBlock.value
                                ? 1.0
                                : 0.0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: IgnorePointer(
                              ignoring: !controller.showControllerBlock.value,
                              child: Column(
                                children: [
                                  // Thanh tiến độ video
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: GestureDetector(
                                      onHorizontalDragStart: (_) {
                                        controller.showControllerBlock.value =
                                            true;
                                      },
                                      onHorizontalDragUpdate: (_) {
                                        controller.showControllerBlock.value =
                                            true;
                                      },
                                      onHorizontalDragEnd: (_) {
                                        controller.handleOnTap();
                                        controller.sendSeekVideoEvent();
                                      },
                                      child: Listener(
                                        onPointerDown: (e) {
                                          controller.showControllerBlock.value =
                                              true;
                                        },
                                        onPointerMove: (e) {
                                          controller.showControllerBlock.value =
                                              true;
                                        },
                                        onPointerUp: (e) {
                                          controller.handleOnTap();
                                          controller.sendSeekVideoEvent();
                                        },
                                        child: VideoProgressIndicator(
                                          controller.videoController,
                                          allowScrubbing: true,
                                          colors: VideoProgressColors(
                                            playedColor: Color(0xFFf2f2f2),
                                            bufferedColor: Color(0xFF898c8d),
                                            backgroundColor: Color(0xFF3b4042),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  // Các nút điều khiển
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              controller.isVideoPlaying.value
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                              size: 40,
                                              color: Color(0xFFf2f2f2),
                                            ),
                                            onPressed:
                                                controller.togglePlayPause,
                                          ),
                                          SizedBox(width: 18),
                                          IconButton(
                                            icon: Icon(
                                              controller.isUser1Speaking.value
                                                  ? Icons.mic_rounded
                                                  : Icons.mic_off_rounded,
                                              size: 36,
                                              color: Color(0xFFf2f2f2),
                                            ),
                                            onPressed: () {
                                              controller.toggleMicro();
                                              // Giả lập trạng thái nói khi bật mic
                                              // controller.updateSpeakingStatus(
                                              //     true, controller.isMicroOn.value);
                                            },
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.crop_rotate,
                                          size: 36,
                                          color: Color(0xFFf2f2f2),
                                        ),
                                        onPressed:
                                            controller.handleRotateScreen,
                                      ),
                                    ],
                                  ),
                                  // Thêm 2 avatar ở dưới
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                }),
                SizedBox(height: 128),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Avatar User 1
                      Obx(() {
                        return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: controller.isUser1Speaking.value
                                    ? Colors.blueAccent
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: controller.isUser1Speaking.value
                                  ? [
                                      BoxShadow(
                                        color:
                                            Colors.blueAccent.withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: 20,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/20240719_YOONA_3rd_Blue_Dragon_Series_Awards.jpg/960px-20240719_YOONA_3rd_Blue_Dragon_Series_Awards.jpg',
                                  ),
                                ),
                                Positioned(
                                  bottom: -64,
                                  left: 0,
                                  right: 0,
                                  child: Icon(
                                    controller.isUser1Speaking.value ? Icons.mic_rounded : Icons.mic_off_rounded,
                                    size: 32,
                                    color: Colors
                                        .black, // tùy bạn, có thể thêm background tròn
                                  ),
                                ),
                              ],
                            ));
                      }),
                      SizedBox(width: 20),
                      // Avatar User 2
                      Obx(() {
                        return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: controller.isUser2Speaking.value
                                    ? Colors.blueAccent
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: controller.isUser2Speaking.value
                                  ? [
                                      BoxShadow(
                                        color:
                                            Colors.blueAccent.withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: 10,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/20240719_YOONA_3rd_Blue_Dragon_Series_Awards.jpg/960px-20240719_YOONA_3rd_Blue_Dragon_Series_Awards.jpg',
                                  ),
                                ),
                                Positioned(
                                  bottom: -64,
                                  left: 0,
                                  right: 0,
                                  child: Icon(
                                    controller.isUser2Speaking.value ? Icons.mic_rounded : Icons.mic_off_rounded,
                                    size: 32,
                                    color: Colors
                                        .black, // tùy bạn, có thể thêm background tròn
                                  ),
                                ),
                              ],
                            ));
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 500,
                      width: 500,
                      child: Lottie.asset('assets/animations/loading.json')),
                  const SizedBox(height: 20),
                  AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        "Waiting for loading film",
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
                ]),
          );
        }
      }),
    );
  }
}
