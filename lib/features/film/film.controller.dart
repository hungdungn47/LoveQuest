import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:love_quest/core/config/events.dart';
import 'package:love_quest/core/global/global.controller.dart';
import 'package:love_quest/core/socket/socket_service.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:video_player/video_player.dart';

import '../video_call/signaling.dart';
import 'enum/index.dart';

class FilmController extends GetxController {
  late VideoPlayerController _videoController;
  RxBool isMic1On = false.obs;
  RxBool isMic2On = false.obs;
  RxBool isVideoInitialized = false.obs;
  RxBool isVideoPlaying = false.obs;
  RxBool isVertical = true.obs;
  RxBool showControllerBlock = false.obs;
  Timer? timer;
  final SocketService _socketService = SocketService();
  final GlobalController _globalController = Get.find<GlobalController>();
  var isUser1Speaking = false.obs;
  var isUser2Speaking = false.obs;
  RxString filmName = ''.obs;
  late Signaling signaling;

  final String userId = 'userA';
  final String peerId = 'userB';

  @override
  void onInit() {
    super.onInit();

    handleInit();
    // _videoController = VideoPlayerController.networkUrl(Uri.parse(
    //     'https://ec93-14-191-139-167.ngrok-free.app/upload/stream/1745060757236-test.mp4')
    // );
    // _videoController.initialize().then((_) {
    //   isVideoInitialized.value = true;
    //   // videoController.setLooping(true);
    // });
    //
    // _socketService.connect();
    //
    // _socketService.sendMessage(EventName.joinRoom, "123456");
    //
    // Timer.periodic(Duration(seconds: 3), (timer) {
    //   isUser1Speaking.value = !isUser1Speaking.value;
    //   isUser2Speaking.value = !isUser1Speaking.value;
    // });
    //
    // rotatePortrait();
    //
    // listenFilmControlResponse();
  }

  Future<void> handleInit() async {
    final data = Get.arguments;
    final String filmUrl = data["filmUrl"];
    final String duration = data["duration"];
    filmName.value = data["filmName"];
    _videoController = VideoPlayerController.networkUrl(Uri.parse(
        'https://6f08-14-191-138-195.ngrok-free.app/upload/stream/fixed_purple_heart.mp4'))
      ..setVolume(1);
    _videoController.initialize().then((_) {
      isVideoInitialized.value = true;
    });

    // Timer.periodic(Duration(seconds: 3), (timer) {
    //   isUser1Speaking.value = !isUser1Speaking.value;
    //   isUser2Speaking.value = !isUser1Speaking.value;
    // });

    rotatePortrait();

    listenFilmControlResponse();

    _handleToggleOpponentMicro();

    noiseAnalyst();



    await _initSignaling();

    if (_globalController.gender.value == "MALE") {
      makeCall();
    }
  }

  void receiveOpponentSpeaking() {
    _socketService.listenToMessages(EventName.isSpeaking, (data) {
      final bool isSpeak = data["isSpeaking"];
      isUser2Speaking.value = isSpeak;
    });
  }

  void noiseAnalyst() {
    NoiseMeter().noise.listen(
          (NoiseReading noiseReading) {
        if (noiseReading.meanDecibel > 60) {
          isUser1Speaking.value = true;
        } else {
          isUser1Speaking.value = false;
        }
        sendSpeakingSignal(isUser1Speaking.value);
        print('Noise: ${noiseReading.meanDecibel} dB');
        print('Max amp: ${noiseReading.maxDecibel} dB');
      },
      onError: (Object error) {
        print(error);
      },
      cancelOnError: true,
    );
  }

  void sendSpeakingSignal(bool isSpeaking) {
    _socketService.sendMessage(EventName.isSpeaking,
        {"from": userId, "to": peerId, "isSpeaking": isSpeaking});
  }

  void makeCall() {
    try {
      print('Making call...');
      signaling.makeCall();
      print('Call initiated');
    } catch (e) {
      print('Error making call: $e');
    }
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
      handleSendDataToSocket({"actionType": FilmControllerType.PAUSE.name});
    } else {
      isVideoPlaying.value = true;
      videoController.play();
      handleSendDataToSocket({
        "actionType": FilmControllerType.PLAY.name,
      });
    }
  }

  void handleSendDataToSocket(Map<String, dynamic> data) {
    _socketService
        .sendMessage(EventName.filmSender, {...data, "roomId": "123456"});
  }

  void sendSeekVideoEvent() {
    int duration = _videoController.value.position.inSeconds;
    handleSendDataToSocket({
      "actionType": FilmControllerType.SEEK.name,
      "data": duration,
    });
  }

  void listenFilmControlResponse() {
    _socketService.listenToMessages(EventName.filmReceiver, (data) {
      final String actionTypeStr = data?['actionType'];
      FilmControllerType actionType = parseFilmType(actionTypeStr);
      final duration = data['data'];
      print('print hello hello hello ${actionTypeStr} ---- ${duration}');
      switch (actionType) {
        case FilmControllerType.PLAY:
          isVideoPlaying.value = true;
          videoController.play();
          break;
        case FilmControllerType.PAUSE:
          isVideoPlaying.value = false;
          videoController.pause();
          break;
        case FilmControllerType.SEEK:
          videoController.seekTo(Duration(seconds: duration));
          break;
      }
    });
  }

  FilmControllerType parseFilmType(String? value) {
    return FilmControllerType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => FilmControllerType.PLAY, // Return null if not found
    );
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
    if (isVertical.value) {
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
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    isVertical.value = false;
  }

  Future<void> rotatePortrait() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    isVertical.value = true;
  }

  Future<void> _initSignaling() async {
    try {
      print('Initializing signaling...');
      signaling = Signaling(userId, peerId);
      await signaling.init();
      print('Signaling initialized successfully');
    } catch (e) {
      print('Error initializing signaling: $e');
    }
  }

  void _handleToggleOpponentMicro() {
    _socketService.listenToMessages(EventName.turnOnMicro, (data) {
      bool isTurnOn = data["isTurnOn"];
      isMic2On.value = isTurnOn;
    });
  }

  void _handleSendMircoSignal() {
    _socketService.sendMessage(EventName.turnOnMicro, {
      "isTurnOn": isMic1On.value,
      "from": userId,
      "to": peerId,
    });
  }

  void toggleMicro() {
    isMic1On.toggle();
    _handleSendMircoSignal();
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
