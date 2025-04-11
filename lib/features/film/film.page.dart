import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:love_quest/features/film/film.controller.dart';
import 'package:video_player/video_player.dart';

import '../../widgets/Appbar.dart';

class FilmPage extends GetView<FilmController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Video Player"),
      // ),
      body: Obx(() {
        if (controller.isVideoInitialized.value) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() {
                  if (controller.isVertical.value) {
                    return Column(
                      children: [
                        AppBarCustomize(
                          title: 'Film', // Sử dụng .value để truy cập giá trị
                        ),
                        SizedBox(
                            height: 240), // Sử dụng .value để truy cập giá trị
                      ],
                    );
                  }
                  return SizedBox();
                }),
                Obx(() {
                  return Stack(children: [
                    GestureDetector(
                      onTap: controller.handleOnTap,
                      onDoubleTap: () {
                        controller.togglePlayPause();
                      },
                      child: controller.isVertical.value
                          ? AspectRatio(
                              aspectRatio:
                                  controller.videoController.value.aspectRatio,
                              child: VideoPlayer(controller.videoController),
                            )
                          : FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: VideoPlayer(controller.videoController),
                              ),
                            ),
                    ),
                    Obx(() {
                      return Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: AnimatedOpacity(
                          opacity:
                              controller.showControllerBlock.value ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: IgnorePointer(
                            ignoring: !controller.showControllerBlock.value,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: GestureDetector(
                                    onHorizontalDragStart: (_) {
                                      controller.showControllerBlock.value = true;
                                    },
                                    onHorizontalDragUpdate: (_) {
                                      controller.showControllerBlock.value = true;
                                    },
                                    onHorizontalDragEnd: (_) {
                                      controller.handleOnTap();
                                    },
                                    child: Listener(
                                      onPointerDown: (e) {
                                        controller.showControllerBlock.value = true;
                                      },
                                      onPointerMove: (e) {
                                        controller.showControllerBlock.value = true;
                                      },
                                      onPointerUp: (e) {
                                        controller.handleOnTap();
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
                                          onPressed: controller.togglePlayPause,
                                        ),
                                        SizedBox(width: 18),
                                        IconButton(
                                          icon: Icon(
                                            controller.isMicroOn.value
                                                ? Icons.mic_rounded
                                                : Icons.mic_off_rounded,
                                            size: 36,
                                            color: Color(0xFFf2f2f2),
                                          ),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.crop_rotate,
                                        size: 36,
                                        color: Color(0xFFf2f2f2),
                                      ),
                                      onPressed: controller.handleRotateScreen,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                  ]);
                })
              ],
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      }),
    );
  }
}
