import 'dart:async';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:love_quest/core/socket/socket_service.dart';
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
  Rx<QuizEntity> currentQuiz = QuizEntity(
    question: '',
    option1: '',
    option2: ''
  ).obs;
  RxString gameId = ''.obs;
  var remainingTime = 500.obs;
  var selectedOption = RxnString();
  var isCompleted = false.obs;
  List<String> answers = ['1', '1', '1', '1', '1'];
  Timer? _timer;
  final logger = Logger();
  // QuizEntity get getCurrentQuiz => currentQuizIndex.value == quizList.length
  //     ? quizList[quizList.length - 1]
  //     : quizList[currentQuizIndex.value];
  QuizEntity get getCurrentQuiz => currentQuiz.value;

  double get progress => currentQuizIndex / quizList.length;
  double get remainingTimeInSeconds => remainingTime.value / 100;

  final SocketService _socketService = SocketService();

  Future<void> _initializeGameSocket() async {
    logger.i('Quiz game connecting');
    await _socketService.connect();

    _socketService.sendMessage(
        'qa_ready', {'roomId': 'quiz_game', 'userId': 'userA'});

    _socketService.listenToMessages('qa_questionSender', (data) {
      submitAnswer();
      startTimer();
      logger.i('Received question $data');
      QuizEntity newQuiz = QuizEntity(
        question: data['question'],
        option1: data['optionA'],
        option2: data['optionB']
      );
      gameId.value = data['gameId'];
      currentQuiz.value = newQuiz;
      currentQuizIndex.value += 1;
    });

    _socketService.listenToMessages('qa_answerReceiver', (data) {
      logger.i('Received answers: $data');
    });
  }

  @override
  void onInit() {
    super.onInit();
    _initializeGameSocket();
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

  void chooseAnswer(String answer) {
    logger.i('Answer: $answer');
    selectedOption.value = answer;
  }

  void submitAnswer() {
    _socketService.sendMessage('qa_answerReceiver', {
      'userId': 'userA',
      'roomId': 'quiz_game',
      'gameId': gameId.value,
      'answer': selectedOption.value
    });
    selectedOption.value = '';
  }

  void moveToNextQuestion() {
    if (selectedOption.value != null) {
      answers.add(selectedOption.value!);
    } else {
      answers.add("");
    }
    // currentQuizIndex++;
    if (currentQuizIndex.value < quizList.length) {
      // startTimer();
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
