import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:love_quest/core/config/events.dart';
import 'package:love_quest/core/config/routes.dart';
import 'package:love_quest/core/global/global.controller.dart';
import 'package:love_quest/core/socket/socket_service.dart';
import 'package:love_quest/extensions/freestyleDrawable.extension.dart';
import 'package:love_quest/features/auth/presentation/controllers/auth_controller.dart';
import 'package:love_quest/features/draw_game/dto/drawData.dto.dart';
import 'package:love_quest/features/draw_game/presentations/test.page.dart';

class DrawGameController extends GetxController {
  final GlobalController _globalController = Get.find<GlobalController>();
  final SocketService _socketService = SocketService();
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _textEditingController = TextEditingController();
  final Rxn<PainterController> _painterController = Rxn<PainterController>(
      PainterController(
        settings: PainterSettings(
          freeStyle: FreeStyleSettings(
            mode: FreeStyleMode.draw, // Cho phép vẽ tự do
            strokeWidth: 3, // Độ dày nét vẽ
            color: Colors.black, // Màu vẽ
          ),
        ),
      )
  );

  PainterController? get painterController => _painterController.value;
  TextEditingController get textEditingController => _textEditingController;
  RxBool questionSubmitted = false.obs;
  RxBool isYourTurn = false.obs;
  RxBool changeToUpdateUI = true.obs;
  RxString question = ''.obs;
  RxInt remainingSeconds = 120.obs;
  Timer? countdownTimer;
  // RxInt curLength = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    handleOnInit();

    _handleGameStart();

    _handleGameRefesh();

    _handleGameEnd();

    _handleResponseSubmitQuestion();

    // handleListenAnswerResponse();

    // handleListenVerifyAnswer();

    _handleListenVerifyAnswer();
    
    if(!isYourTurn.value) {
      receivedData();
    }
  }

  void startCountdown() {
    countdownTimer?.cancel(); // Clear previous timer
    remainingSeconds.value = 120;
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> handleOnInit() async {
    await _socketService.connect();
    // isYourTurn.value = _globalController.gender.value == 'MALE' ? true : false;
    isYourTurn.value = _authController.user.value.gender == 'MALE' ? true : false;
    _socketService.sendMessage(EventName.draw_ready, {
      "userId": _authController.user.value.id,
      "gender": _authController.user.value.gender,
      "roomId": _globalController.roomId.value,
      // "userId": "456",
      // "roomId": "123456"
    });
  }
  
  void _handleGameStart() {
    _socketService.listenToMessages(EventName.draw_start, (data) {
      print("Game Started");
    });
  }

  void _handleGameRefesh() {
    _socketService.listenToMessages(EventName.draw_refresh, (data) {
      print("Game refesh");
      startCountdown();
      isYourTurn.value = !isYourTurn.value;
      questionSubmitted.value = false;
      textEditingController.text = '';
    });
  }

  void _handleResponseSubmitQuestion() {
    _socketService.listenToMessages(EventName.draw_submit_question, (data) {
      print("Hello submited");
      questionSubmitted.value = true;
    });
  }

  void _handleGameEnd() {
    _socketService.listenToMessages(EventName.draw_end, (data) {
      print("Game ended");
      Get.toNamed(AppRoutes.filmChoosing);
    });
  }

  void handleSubmit() {
    if(!isYourTurn.value) {
      _socketService.sendMessage(EventName.answer, {
        "answer": _textEditingController.text,
        // "roomId": "123456",
        "roomId": _globalController.roomId.value,
      });
    } else {
      _socketService.sendMessage(EventName.draw_submit_question, {
        // "roomId": "123456",
        "question": _textEditingController.text,
        "roomId": _globalController.roomId.value,
      });
      question.value = _textEditingController.text;
    }
  }

  String checkAnswer(bool check) {
    if(check) {
      return "You answered correctly";
    }
    return "You answered wrongly";
  }

  void _handleListenVerifyAnswer() {
    _socketService.listenToMessages(EventName.draw_confirm, (data) {
      print("verify response");
      final bool check = data["check"];
      final String answer = data["answer"];
      if(isYourTurn.value) {
        Get.dialog(Test(title: "The opponent's answer is: $answer"));
      } else {
        Get.dialog(Test(title: checkAnswer(check),));
      }
    });
  }

  void sendDataToAnother() {
    int length = _painterController.value?.drawables.length ?? 0;
    if (length > 0) {
      final lastDrawable = _painterController.value!.drawables.last;

      if (lastDrawable is FreeStyleDrawable) {
        // Map<String, String> data = DrawDataDto(
        //     data: lastDrawable, roomId: "123456").toMap();
        Map<String, String> data = DrawDataDto(
            data: lastDrawable, roomId: _globalController.roomId.value).toMap();
        _socketService.sendMessage('draw', data);
        print('Room id ${_globalController.roomId.value}');
      }

      // curLength.value = curLength.value + 1;
    }
  }

  void receivedData() {
    _socketService.listenToMessages(
        EventName.receiveDrawEvent, (data) async {
          await handleDrawBySocketData(data);
    });
  }

  void setStrokeWidth(double value) {
    _painterController.value?.freeStyleStrokeWidth = value;
  }

  Future<void> handleDrawBySocketData(String data) async {
    Map<String, dynamic> json = jsonDecode(data);
    FreeStyleDrawable receivedDrawable = FreeStyleDrawableJson.fromJson(json);
    for (int i = 0; i < receivedDrawable.path.length - 1; i++) {
      await Future.delayed(Duration(milliseconds: 10));

      FreeStyleDrawable smallDrawable = FreeStyleDrawable(
        path: [receivedDrawable.path[i], receivedDrawable.path[i + 1]],
        color: receivedDrawable.color,
        strokeWidth: receivedDrawable.strokeWidth,
      );

      _painterController.value?.addDrawables([smallDrawable]);
    }
  }

    void test() async {
      Map<String, dynamic> json = jsonDecode(
          '{"type":"freestyle","color":4278190080,"strokeWidth":3.0,"points":[{"x":265.70005580357144,"y":269.84040178571433},{"x":265.70005580357144,"y":273.26813616071433},{"x":266.84263392857144,"y":273.26813616071433},{"x":266.84263392857144,"y":274.41071428571433},{"x":267.98521205357144,"y":277.83844866071433},{"x":267.98521205357144,"y":278.98102678571433},{"x":269.12779017857144,"y":278.98102678571433},{"x":269.12779017857144,"y":280.12360491071433},{"x":271.41294642857144,"y":281.26618303571433},{"x":272.55552455357144,"y":283.55133928571433},{"x":272.55552455357144,"y":284.69391741071433},{"x":273.69810267857144,"y":285.83649553571433},{"x":273.69810267857144,"y":286.97907366071433},{"x":273.69810267857144,"y":289.26422991071433},{"x":273.69810267857144,"y":290.40680803571433},{"x":274.84068080357144,"y":291.54938616071433},{"x":277.12583705357144,"y":292.69196428571433},{"x":277.12583705357144,"y":294.97712053571433},{"x":277.12583705357144,"y":296.11969866071433},{"x":278.26841517857144,"y":296.11969866071433},{"x":278.26841517857144,"y":300.69001116071433},{"x":279.41099330357144,"y":301.83258928571433},{"x":279.41099330357144,"y":304.11774553571433},{"x":279.41099330357144,"y":306.40290178571433},{"x":279.41099330357144,"y":307.54547991071433},{"x":279.41099330357144,"y":309.83063616071433},{"x":278.26841517857144,"y":314.40094866071433},{"x":277.12583705357144,"y":315.54352678571433},{"x":277.12583705357144,"y":317.82868303571433},{"x":274.84068080357144,"y":318.97126116071433},{"x":273.69810267857144,"y":321.25641741071433},{"x":272.55552455357144,"y":324.68415178571433},{"x":271.41294642857144,"y":325.82672991071433},{"x":269.12779017857144,"y":325.82672991071433},{"x":267.98521205357144,"y":329.25446428571433},{"x":267.98521205357144,"y":330.39704241071433},{"x":266.84263392857144,"y":330.39704241071433},{"x":263.41489955357144,"y":332.68219866071433},{"x":262.27232142857144,"y":334.96735491071433},{"x":261.12974330357144,"y":336.10993303571433},{"x":259.98716517857144,"y":336.10993303571433},{"x":256.55943080357144,"y":336.10993303571433},{"x":255.41685267857144,"y":336.10993303571433},{"x":254.27427455357144,"y":337.25251116071433},{"x":248.56138392857144,"y":338.39508928571433},{"x":243.99107142857144,"y":340.68024553571433},{"x":240.56333705357144,"y":340.68024553571433},{"x":239.408203125,"y":340.68024553571433},{"x":237.123046875,"y":340.68024553571433},{"x":233.6953125,"y":340.68024553571433},{"x":227.982421875,"y":340.68024553571433},{"x":215.4140625,"y":340.68024553571433},{"x":209.701171875,"y":340.68024553571433},{"x":206.2734375,"y":338.39508928571433},{"x":202.845703125,"y":338.39508928571433},{"x":199.41796875,"y":337.25251116071433},{"x":191.419921875,"y":337.25251116071433},{"x":183.421875,"y":336.10993303571433},{"x":182.279296875,"y":336.10993303571433},{"x":170.84095982142858,"y":334.96735491071433},{"x":170.84095982142858,"y":332.68219866071433},{"x":169.69838169642858,"y":332.68219866071433}]}');

      FreeStyleDrawable receivedDrawable = FreeStyleDrawableJson.fromJson(json);

      for (int i = 0; i < receivedDrawable.path.length - 1; i++) {
        await Future.delayed(Duration(milliseconds: 10));

        FreeStyleDrawable smallDrawable = FreeStyleDrawable(
          path: [receivedDrawable.path[i], receivedDrawable.path[i + 1]],
          // Vẽ một đoạn nhỏ
          color: receivedDrawable.color,
          strokeWidth: receivedDrawable.strokeWidth,
        );

        _painterController.value?.addDrawables([smallDrawable]);
      }
    }


    void onDrawUpdate(Drawable drawable) {
      if (drawable is FreeStyleDrawable) {
        print("User đang vẽ với nét tự do:");
        print("  - Points: ${drawable.path}");
      }
    }

    void setBackground() {
      _painterController.value?.background = Colors.black.backgroundDrawable;
    }

    void setBackgroundImage(String imageUrl) async {
      final ui.Image myImage = await NetworkImage(imageUrl).image;
      _painterController.value?.background = myImage.backgroundDrawable;
    }
  }