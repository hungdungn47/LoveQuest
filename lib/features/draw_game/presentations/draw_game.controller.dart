import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:love_quest/core/config/events.dart';
import 'package:love_quest/core/socket/socket_service.dart';
import 'package:love_quest/extensions/freestyleDrawable.extension.dart';
import 'package:love_quest/features/draw_game/dto/drawData.dto.dart';
import 'package:love_quest/features/draw_game/presentations/test.page.dart';

class DrawGameController extends GetxController {
  final SocketService _socketService = SocketService();
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
  RxBool isYourTurn = true.obs;
  RxBool changeToUpdateUI = true.obs;
  RxString question = ''.obs;
  // RxInt curLength = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _socketService.connect();

    joinRoom("123456");

    handleListenAnswerResponse();

    handleListenVerifyAnswer();
    
    if(!isYourTurn.value) {
      receivedData();
    }
  }
  
  void joinRoom(String roomId) {
    _socketService.sendMessage(EventName.joinRoom, roomId);
  }

  void handleSubmit() {
    if(!isYourTurn.value) {
      _socketService.sendMessage(EventName.answer, {
        "answer": _textEditingController.text,
        "roomId": "123456",
      });
    } else {
      question.value = _textEditingController.text;
    }
  }

  String checkAnswer(String answer) {
    if(answer == question.value) {
      return "You answered correctly";
    }
    return "You answered wrongly";
  }

  void handleListenAnswerResponse() {
    _socketService.listenToMessages(EventName.answerResponse, (data) {
      Get.dialog(Test(title: "The opponent's answer is: $data"));
      final String message = checkAnswer(data);
      _socketService.sendMessage(EventName.verifyAnswer, {
        "message": message,
        "roomId": "123456"
      });
    });
  }

  void handleListenVerifyAnswer() {
    _socketService.listenToMessages(EventName.verifyAnswerResponse, (message) {
      print("verify response");
      Get.dialog(Test(title: message,));
    });
  }

  void sendDataToAnother() {
    int length = _painterController.value?.drawables.length ?? 0;
    if (length > 0) {
      final lastDrawable = _painterController.value!.drawables.last;

      if (lastDrawable is FreeStyleDrawable) {
        Map<String, String> data = DrawDataDto(
            data: lastDrawable, roomId: "123456").toMap();
        _socketService.sendMessage('draw', data);
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