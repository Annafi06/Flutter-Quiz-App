import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(QuizApp());

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
        ),
        textTheme: TextTheme(
          headline6: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size(100, 40)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            )),
            backgroundColor: MaterialStateProperty.all(Colors.grey),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
        ),
      ),
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the capital of France?',
      'options': ['Paris', 'London', 'Berlin', 'Madrid'],
      'answer': 0,
    },
    {
      'question': 'What is the largest planet in our solar system?',
      'options': ['Earth', 'Mars', 'Jupiter', 'Saturn'],
      'answer': 2,
    },
    {
      'question': 'What is the currency used in Japan?',
      'options': ['Dollar', 'Euro', 'Yen', 'Pound'],
      'answer': 2,
    },
  ];
  int currentIndex = 0;
  int correctAnswers = 0;
  int totalTime = 0;
  int currentQuestionTime = 15; // 15 seconds per question
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    for (var question in questions) {
      totalTime += 15;
    }
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentQuestionTime--;
      });
      if (currentQuestionTime == 0) {
        _timer?.cancel();
        moveToNextQuestion();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void checkAnswer(int selectedIndex) {
    if (selectedIndex == questions[currentIndex]['answer']) {
      setState(() {
        correctAnswers++;
      });
    }
    _timer?.cancel();
    moveToNextQuestion();
  }

  void moveToNextQuestion() {
    setState(() {
      if (currentIndex < questions.length - 1) {
        currentIndex++;
        currentQuestionTime = 15;
        startTimer();
      } else {
        // Quiz finished, show result
        showQuizResult();
      }
    });
  }

  void showQuizResult() {
    // Calculate score and show final result
    double score = (correctAnswers / questions.length) * 100;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Quiz Finished"),
          content: Text(
              "You scored ${correctAnswers} out of ${questions.length}.\nTotal Time: $totalTime seconds"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
            TextButton(
              onPressed: () {
                // Share the quiz result
                shareQuizResult(score);
              },
              child: Text("Share"),
            ),
          ],
        );
      },
    );
  }

  void shareQuizResult(double score) {
    // Share the quiz result as text
    // Example using Share plugin
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz App"),
      ),
      body: Column(
        children: <Widget>[
          Text(
            "Question ${currentIndex + 1}/${questions.length}",
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(height: 10.0),
          Text(
            questions[currentIndex]['question'],
            style: TextStyle(fontSize: 24.0),
          ),
          SizedBox(height: 20.0),
          Text(
            "Time Left: $currentQuestionTime seconds",
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
              questions[currentIndex]['options'].length,
              (index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => checkAnswer(index),
                  child: Text(questions[currentIndex]['options'][index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}