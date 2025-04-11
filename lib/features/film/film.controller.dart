import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class FilmController extends GetxController {
  late VideoPlayerController _videoController;
  RxBool isVideoInitialized = false.obs;
  RxBool isVideoPlaying = false.obs;
  RxBool isMicroOn = false.obs;
  RxBool isVertical = true.obs;
  RxBool showControllerBlock = false.obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(
        'https://fb1f-2001-ee0-4a6c-fc70-2c7b-36f5-3ce8-351f.ngrok-free.app/upload/stream/1744302083401-Photograph.mp4')
    );
    _videoController.initialize().then((_) {
      isVideoInitialized.value = true;
      videoController.setLooping(true);
    });

    rotatePortrait();
  }

  VideoPlayerController get videoController => _videoController;

  @override
  void onClose() {
    _videoController.dispose();
    super.onClose();
  }

  void togglePlayPause() {
    if (videoController.value.isPlaying) {
      isVideoPlaying.value = false;
      videoController.pause();
    } else {
      isVideoPlaying.value = true;
      videoController.play();
    }
  }

  void handleOnTap() {
    print("Bat");
    showControllerBlock.value = true;
    timer?.cancel();
    timer = Timer(Duration(seconds: 5), () {
      showControllerBlock.value = false;
      print("Tat");
    });
  }

  Future<void> handleRotateScreen() async {
    if(isVertical.value) {
      await rotateLandscape();
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      await rotatePortrait();
    }
  }

  Future<void> rotateLandscape() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky);
    isVertical.value = false;
  }

  Future<void> rotatePortrait() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    isVertical.value = true;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    videoController.dispose();

    // Reset orientation khi controller bị huỷ
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }
}
