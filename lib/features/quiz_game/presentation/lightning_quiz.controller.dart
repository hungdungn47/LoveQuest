import 'dart:async';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:love_quest/features/quiz_game/domain/entities/quiz.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class LightningQuizController extends GetxController {
  List<QuizEntity> quizList = [
    QuizEntity(
      question: "Where would you like to travel?",
      option1: "Beach",
      option2: "Mountain",
    ),
    QuizEntity(
      question: "Which taste do you prefer?",
      option1: "Sweet",
      option2: "Salty",
    ),
    QuizEntity(
      question: "Would you rather ...",
      option1: "Watch movies",
      option2: "Read books",
    ),
    QuizEntity(
      question: "Would you rather explore ...",
      option1: "A futuristic city",
      option2: "An ancient ruin",
    ),
    QuizEntity(
      question: "Would you like to wear ...",
      option1: "Sneakers",
      option2: "Sandals",
    )
  ];
  var currentQuizIndex = 0.obs;
  var remainingTime = 500.obs;
  var selectedOption = RxnString();
  var isCompleted = false.obs;
  List<String> answers = [];
  Timer? _timer;
  final logger = Logger();
  QuizEntity get getCurrentQuiz => currentQuizIndex.value == quizList.length
      ? quizList[quizList.length - 1]
      : quizList[currentQuizIndex.value];

  double get progress => currentQuizIndex / quizList.length;
  double get remainingTimeInSeconds => remainingTime.value / 100;

  @override
  void onInit() {
    super.onInit();
    // ever(currentQuizIndex, (_) {
    //   if (currentQuizIndex.value < quizList.length) {
    //     startTimer();
    //   }
    // });
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    remainingTime.value = 5 * 100;
    selectedOption.value = null;

    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (remainingTime > 0) {
        remainingTime.value--;
      } else {
        autoSubmit();
      }
    });
  }

  void autoSubmit() {
    logger.i('Auto-submitting due to timeout');
    // if (selectedOption.value == null) {
    //   selectedOption.value = "Time's up!";
    // }
    moveToNextQuestion();
  }

  void submitQuiz(String answer) {
    logger.i('Answer: $answer');
    selectedOption.value = answer;
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   moveToNextQuestion();
    // });
  }

  void moveToNextQuestion() {
    if (selectedOption.value != null) {
      answers.add(selectedOption.value!);
    } else {
      answers.add("");
    }
    currentQuizIndex++;
    if (currentQuizIndex.value < quizList.length) {
      startTimer();
    } else {
      _timer?.cancel();
      remainingTime.value = 0;
      isCompleted.value = true;
    }
  }

  void handleTimeUp() {
    logger.i('Time up!');
    autoSubmit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
