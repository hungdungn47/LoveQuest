import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:love_quest/core/global/global.controller.dart';
import 'package:love_quest/core/socket/socket_service.dart';
import 'package:love_quest/features/auth/presentation/controllers/auth_controller.dart';
import 'package:love_quest/features/quiz_game/domain/entities/quiz.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class LightningQuizController extends GetxController {
  var currentQuizIndex = 0.obs;
  Rx<QuizEntity> currentQuiz = QuizEntity(
    question: '',
    option1: '',
    option2: ''
  ).obs;
  RxString gameId = ''.obs;
  var remainingTime = 500.obs;
  var selectedOption = RxnString();
  var isCompleted = false.obs;
  List<String> answers = [];
  List<QuizEntity> quizList = [];
  Timer? _timer;
  final logger = Logger();
  // QuizEntity get getCurrentQuiz => currentQuizIndex.value == quizList.length
  //     ? quizList[quizList.length - 1]
  //     : quizList[currentQuizIndex.value];
  QuizEntity get getCurrentQuiz => currentQuiz.value;

  double get progress => currentQuizIndex / 10;
  double get remainingTimeInSeconds => remainingTime.value / 100;

  final GlobalController globalController = Get.find<GlobalController>();
  final AuthController _authController = Get.find<AuthController>();
  final SocketService _socketService = SocketService();

  Map<String, Map<String, String>> allAnswers = {}; // userId -> { gameId: answer }
  Map<String, String> opponentAnswers = {}; // gameId -> opponent's answer

  Future<void> _initializeGameSocket() async {
    logger.i('Quiz game connecting');
    await _socketService.connect();

    _socketService.sendMessage(
        'qa_ready', {'roomId': globalController.roomId.value, 'userId': _authController.user.value.id});

    _socketService.listenToMessages('qa_questionSender', (data) {
      if (gameId.value.isNotEmpty) {
        submitAnswer(); // Always submit previous
      }
      startTimer();
      logger.i('Received question $data');
      QuizEntity newQuiz = QuizEntity(
          question: data['question'],
          option1: data['optionA'],
          option2: data['optionB']
      );
      quizList.add(newQuiz);
      gameId.value = data['gameId'];
      currentQuiz.value = newQuiz;
      currentQuizIndex.value += 1;
    });

    _socketService.listenToMessages('qa_finalAnswers', (data) {
      logger.i('Received finalAnswers: $data');

      final answersList = data['answers'] as List;
      final myUserId = _authController.user.value.id;

      for (var entry in answersList) {
        final userId = entry['userId'];
        final answersMap = Map<String, dynamic>.from(entry['answers']);

        if (userId != myUserId) {
          // This is the opponent
          int index = 0;
          answersMap.forEach((key, value) {
            opponentAnswers['q$index'] = value ?? "No answer";
            index++;
          });
        }
      }

      // Mark quiz as completed
      isCompleted.value = true;
    });

  }

  @override
  void onInit() {
    super.onInit();
    _initializeGameSocket();
  }

  void startTimer() {
    _timer?.cancel();
    remainingTime.value = 4 * 100;
    selectedOption.value = null;

    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (remainingTime > 0) {
        remainingTime.value--;
      } else {
        // autoSubmit();
      }
    });
  }

  // void autoSubmit() {
  //   logger.i('Auto-submitting due to timeout');
  //   moveToNextQuestion();
  // }

  void chooseAnswer(String answer) {
    logger.i('Answer: $answer');
    selectedOption.value = answer;
  }

  void submitAnswer() {
    _socketService.sendMessage('qa_answerReceiver', {
      'userId': _authController.user.value.id,
      'roomId': globalController.roomId.value,
      'gameId': gameId.value,
      'answer': selectedOption.value
    });
    answers.add(selectedOption.value ?? "No answer");
    selectedOption.value = '';
  }

  void moveToNextQuestion() {
    if (selectedOption.value != null) {
      answers.add(selectedOption.value!);
    } else {
      answers.add("");
    }
    // currentQuizIndex++;
    if (currentQuizIndex.value <= 10) {
      // startTimer();
    } else {
      _timer?.cancel();
      remainingTime.value = 0;
      isCompleted.value = true;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
