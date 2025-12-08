import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/vocab_word.dart';

class VocabQuiz extends StatefulWidget {
  final List<VocabWord> words;

  const VocabQuiz({super.key, required this.words});

  @override
  State<VocabQuiz> createState() => _VocabQuizState();
}

class _VocabQuizState extends State<VocabQuiz> {
  late List<VocabWord> questions;
  int index = 0;

  bool answered = false;
  bool isCorrect = false;
  String correctAnswer = "";

  List<String> currentChoices = [];
  int score = 0;

  @override
  void initState() {
    super.initState();

    /// 🔀 Mélange les mots et garde seulement 10 pour le quiz
    questions = [...widget.words];
    questions.shuffle();
    if (questions.length > 10) {
      questions = questions.sublist(0, 10);
    }

    /// 🧠 Génère une première liste de choix
    currentChoices = generateChoices(questions[0]);
  }

  /// Génère 3 mauvaises réponses + 1 bonne réponse
  List<String> generateChoices(VocabWord word) {
    final rng = Random();

    final otherWords = widget.words
        .where((w) => w.fr != word.fr)
        .map((w) => w.fr)
        .toList();

    otherWords.shuffle(rng);

    final choices = [
      word.fr,
      ...otherWords.take(3),
    ];

    choices.shuffle(rng);

    return choices;
  }

  void answer(String selected, VocabWord word) {
    if (answered) return;

    setState(() {
      answered = true;
      isCorrect = selected == word.fr;
      correctAnswer = word.fr;

      if (isCorrect) score++;
    });
  }

  void nextQuestion() {
    if (index < questions.length - 1) {
      setState(() {
        index++;
        answered = false;

        /// 🎯 Génère les choix de la nouvelle question
        currentChoices = generateChoices(questions[index]);
      });
    } else {
      /// 🏁 Fin du quiz → écran récapitulatif
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizSummaryScreen(
            score: score,
            total: questions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final word = questions[index];
    final choices = currentChoices;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: const Text("Quiz"),
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),

          /// ⭐ Progression
          Text(
            "Question ${index + 1} / ${questions.length}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 30),

          /// ⭐ Question (JP)
          Text(
            word.jp,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 30),

          /// ⭐ Choix
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: choices.length,
              itemBuilder: (context, i) {
                final answerText = choices[i];

                Color bg = Colors.white;
                Color border = Colors.transparent;

                if (answered) {
                  if (answerText == correctAnswer) {
                    bg = Colors.green.shade100;
                    border = Colors.green;
                  } else if (answerText != correctAnswer &&
                             answerText == choices[i] &&
                             !isCorrect) {
                    bg = Colors.red.shade100;
                    border = Colors.red;
                  }
                }

                return GestureDetector(
                  onTap: () => answer(answerText, word),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: border, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        )
                      ],
                    ),
                    child: Text(
                      answerText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// ⭐ Feedback (correct/incorrect)
          if (answered)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    isCorrect ? "Correct !" : "Incorrect…",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isCorrect ? Colors.green[800] : Colors.red[800],
                    ),
                  ),
                  if (!isCorrect)
                    Text(
                      "Bonne réponse : $correctAnswer",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                ],
              ),
            ),

          /// ⭐ Bouton Suivant
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap: answered ? nextQuestion : null,
              child: Container(
                height: 70,
                width: 240,
                decoration: BoxDecoration(
                  color: answered ? Colors.white : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: answered
                      ? [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 8,
                            offset: const Offset(2, 2),
                          )
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Suivant",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// 🏁 Écran final récapitulatif du quiz
/// ---------------------------------------------------------------------------
class QuizSummaryScreen extends StatelessWidget {
  final int score;
  final int total;

  const QuizSummaryScreen({
    super.key,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(title: const Text("Résultats du Quiz")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
            const SizedBox(height: 20),

            Text(
              "$score / $total",
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              score == total
                  ? "Parfait ! 🎉"
                  : score > total / 2
                      ? "Bien joué !"
                      : "Continue à t’entraîner !",
              style: const TextStyle(fontSize: 22),
            ),

            const SizedBox(height: 40),

            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 70,
                width: 240,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 8,
                      offset: const Offset(2, 2),
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Retour",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
