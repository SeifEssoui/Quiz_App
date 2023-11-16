import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/screens/result_screen/result_screen.dart';
import 'package:quiz_app/screens/welcome_screen.dart';

class QuizController extends GetxController{
  String name = '';
 //question variables
  int get countOfQuestion => _questionsList.length;
  final List<QuestionModel> _questionsList = [
  QuestionModel(
    id: 1,
    question: "What is the main function in a Flutter app?",
    answer: 2,
    options: ['main()', 'start()', 'app()', 'execute()'],
  ),
  QuestionModel(
    id: 2,
    question: "Which widget is used to create a button in Flutter?",
    answer: 1,
    options: ['ElevatedButton', 'ClickWidget', 'ButtonContainer', 'FlatButton'],
  ),
  QuestionModel(
    id: 3,
    question: "What does the MaterialApp widget do in Flutter?",
    answer: 2,
    options: ['Defines the app theme', 'Manages app navigation', 'Creates a button', 'Handles user input'],
  ),
  QuestionModel(
    id: 4,
    question: "What is the purpose of the pubspec.yaml file in Flutter?",
    answer: 1,
    options: ['Declare project dependencies and metadata', 'Define app layout', 'Specify app permissions', 'Configure app animations'],
  ),
  QuestionModel(
    id: 5,
    question: "Which command is used to run a Flutter app from the terminal?",
    answer: 3,
    options: ['flutter start', 'flutter launch', 'flutter run', 'flutter go'],
  ),
  QuestionModel(
    id: 6,
    question: "What is Flutter's hot reload feature used for?",
    answer: 2,
    options: ['Restarting the app', 'Updating code without restarting the app', 'Refreshing dependencies', 'Compiling the app'],
  ),
  QuestionModel(
    id: 7,
    question: "Which package is commonly used for state management in Flutter?",
    answer: 3,
    options: ['flutter_state', 'provider', 'stateful_manager', 'dart_state'],
  ),
  QuestionModel(
    id: 8,
    question: "What does the `async` keyword indicate in Flutter?",
    answer: 3,
    options: ['A widget type', 'A design pattern', 'Asynchronous operation', 'App version'],
  ),
  QuestionModel(
    id: 9,
    question: "How can you navigate to a new screen in Flutter?",
    answer: 1,
    options: ['Navigator.push()', 'Screen.navigate()', 'Page.open()', 'Route.change()'],
  ),
  QuestionModel(
    id: 10,
    question: "What is the purpose of the Scaffold widget in Flutter?",
    answer: 2,
    options: ['Handling animations', 'Providing a basic app structure', 'Managing app state', 'Defining app colors'],
  ),
];


  List<QuestionModel> get questionsList => [..._questionsList];


  bool _isPressed = false;


  bool get isPressed => _isPressed; //To check if the answer is pressed


  double _numberOfQuestion = 1;


  double get numberOfQuestion => _numberOfQuestion;


  int? _selectAnswer;


  int? get selectAnswer => _selectAnswer;


  int? _correctAnswer;


  int _countOfCorrectAnswers = 0;


  int get countOfCorrectAnswers => _countOfCorrectAnswers;

  //map for check if the question has been answered
  final Map<int, bool> _questionIsAnswerd = {};


  //page view controller
  late PageController pageController;

  //timer
  Timer? _timer;


  final maxSec = 15;


  final RxInt _sec = 15.obs;


  RxInt get sec => _sec;

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    resetAnswer();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  //get final score
  double get scoreResult {
    return _countOfCorrectAnswers * 100 / _questionsList.length;
  }

  void checkAnswer(QuestionModel questionModel, int selectAnswer) {
    _isPressed = true;

    _selectAnswer = selectAnswer;
    _correctAnswer = questionModel.answer;

    if (_correctAnswer == _selectAnswer) {
      _countOfCorrectAnswers++;
    }
    stopTimer();
    _questionIsAnswerd.update(questionModel.id, (value) => true);
    Future.delayed(const Duration(milliseconds: 500)).then((value) => nextQuestion());
    update();
  }

  //check if the question has been answered
  bool checkIsQuestionAnswered(int quesId) {
    return _questionIsAnswerd.entries
        .firstWhere((element) => element.key == quesId)
        .value;
  }

  void nextQuestion() {
    if (_timer != null || _timer!.isActive) {
      stopTimer();
    }

    if (pageController.page == _questionsList.length - 1) {
      Get.offAndToNamed(ResultScreen.routeName);
    } else {
      _isPressed = false;
      pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.linear);

      startTimer();
    }
    _numberOfQuestion = pageController.page! + 2;
    update();
  }

  //called when start again quiz
  void resetAnswer() {
    for (var element in _questionsList) {
      _questionIsAnswerd.addAll({element.id: false});
    }
    update();
  }

  //get right and wrong color
  Color getColor(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Colors.green.shade700;
      } else if (answerIndex == _selectAnswer &&
          _correctAnswer != _selectAnswer) {
        return Colors.red.shade700;
      }
    }
    return Colors.white;
  }

  //het right and wrong icon
  IconData getIcon(int answerIndex) {
    if (_isPressed) {
      if (answerIndex == _correctAnswer) {
        return Icons.done;
      } else if (answerIndex == _selectAnswer &&
          _correctAnswer != _selectAnswer) {
        return Icons.close;
      }
    }
    return Icons.close;
  }

  void startTimer() {
    resetTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sec.value > 0) {
        _sec.value--;
      } else {
        stopTimer();
        nextQuestion();
      }
    });
  }

  void resetTimer() => _sec.value = maxSec;

  void stopTimer() => _timer!.cancel();
  //call when start again quiz
  void startAgain() {
    _correctAnswer = null;
    _countOfCorrectAnswers = 0;
    resetAnswer();
    _selectAnswer = null;
    Get.offAllNamed(WelcomeScreen.routeName);
  }
}
