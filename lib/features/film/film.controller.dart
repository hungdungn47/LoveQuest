import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:love_quest/core/config/events.dart';
import 'package:love_quest/core/global/global.controller.dart';
import 'package:love_quest/core/socket/socket_service.dart';
import 'package:love_quest/features/auth/domain/entities/user.dart';
import 'package:love_quest/features/auth/presentation/controllers/auth_controller.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:video_player/video_player.dart';

import '../../core/resources/data_state.dart';
import '../auth/data/models/response_user.dart';
import '../auth/domain/usecases/getOtherUser.dart';
import '../video_call/signaling.dart';
import 'enum/index.dart';

class FilmController extends GetxController {
  late VideoPlayerController _videoController;
  Rxn<ResponseUser> otherInfo = Rxn<ResponseUser>();
  RxBool isMic1On = false.obs;
  RxBool isMic2On = false.obs;
  RxBool isVideoInitialized = false.obs;
  RxBool isVideoPlaying = false.obs;
  RxBool isVertical = true.obs;
  RxBool showControllerBlock = false.obs;
  Timer? timer;
  final SocketService _socketService = SocketService();
  final GlobalController _globalController = Get.find<GlobalController>();
  final AuthController _authController = Get.find<AuthController>();
  var isUser1Speaking = false.obs;
  var isUser2Speaking = false.obs;
  RxString filmName = ''.obs;
  RxString filmUrl = ''.obs;
  late Signaling signaling;
  UserEntity get user => _authController.user.value;

  late final String userId;
  late final String peerId;

  @override
  void onInit() {
    super.onInit();

    handleInit();
  }

  Future<void> handleInit() async {
    userId = _authController.user.value.id!;
    peerId = _globalController.peerId.value;
    final data = Get.arguments;
    final String url = data["filmUrl"];
    filmUrl.value = url;
    filmName.value = data["filmName"];
    _videoController = VideoPlayerController.networkUrl(Uri.parse(
        'https://0f38-117-2-113-7.ngrok-free.app/api/upload/stream/${filmUrl.value}'))
      ..setVolume(1);
    _videoController.initialize().then((_) {
      isVideoInitialized.value = true;
    });

    rotatePortrait();

    listenFilmControlResponse();

    _handleToggleOpponentMicro();

    noiseAnalyst();

    await _initSignaling();

    otherInfo.value = await getOtherUserProfile(peerId);

    if (_authController.user.value.gender == "MALE") {
      makeCall();
    }
  }

  Future<ResponseUser?> getOtherUserProfile(String userId) async {
    try{
      final GetOtherUserUseCase getOtherUserUseCase = Get.find<GetOtherUserUseCase>();
      final result = await getOtherUserUseCase.call(UserIdParams(userId));
      if(result is DataSuccess) {
        return result.data;
      }
    } catch (e) {
      return null;
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
        // print('Noise: ${noiseReading.meanDecibel} dB');
        // print('Max amp: ${noiseReading.maxDecibel} dB');
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
        .sendMessage(EventName.filmSender, {...data, "roomId": _globalController.roomId.value});
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
      print("data ${data} ");
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
    final audioTracks = signaling.localStream.getAudioTracks();
    if (audioTracks.isNotEmpty) {
      final enabled = isMic1On.value;
      audioTracks.forEach((track) {
        track.enabled = !enabled;
      });
      isMic1On.value = !enabled;
    }
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
