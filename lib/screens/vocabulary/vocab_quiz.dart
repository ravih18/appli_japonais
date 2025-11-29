import 'package:flutter/material.dart';
import '../../models/vocab_word.dart';
import 'dart:math';

class VocabQuiz extends StatefulWidget {
  final List<VocabWord> words;
  const VocabQuiz({super.key, required this.words});

  @override
  State<VocabQuiz> createState() => _VocabQuizState();
}

class _VocabQuizState extends State<VocabQuiz> {
  late VocabWord current;
  late List<String> options;

  String? feedback;       // "Correct !" ou "Incorrect"
  Color feedbackColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  void _nextQuestion() {
    final rand = Random();
    current = widget.words[rand.nextInt(widget.words.length)];

    final wrong = widget.words
        .where((w) => w != current)
        .map((w) => w.fr)
        .toList()
      ..shuffle();

    options = ([current.fr] + wrong.take(3).toList())..shuffle();

    setState(() {});
  }

  void _answer(String selected) {
    final correct = selected == current.fr;

    setState(() {
      feedback = correct ? "Correct !" : "Incorrect";
      feedbackColor = correct ? Colors.green : Colors.red;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        feedback = null;
        feedbackColor = Colors.transparent;
      });
      _nextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            current.jp,
            style: const TextStyle(fontSize: 32),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          ...options.map((opt) => Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () => _answer(opt),
                  child: Text(opt),
                ),
              )),

          const Spacer(),

          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: feedback != null ? 60 : 0,
            width: double.infinity,
            color: feedbackColor,
            child: Center(
              child: Text(
                feedback ?? "",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
