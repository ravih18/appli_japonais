import 'package:flutter/material.dart';
import '../../models/vocab_word.dart';
import '../../services/vocab_loader.dart';
import 'vocab_flashcards.dart';
import 'vocab_quiz.dart';

class LessonScreen extends StatefulWidget {
  final int lesson;
  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late Future<List<VocabWord>> futureVocab;

  @override
  void initState() {
    super.initState();
    futureVocab = VocabLoader.loadLesson(widget.lesson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(title: Text("Leçon ${widget.lesson}")),

      body: FutureBuilder<List<VocabWord>>(
        future: futureVocab,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final vocab = snapshot.data!;

          return Column(
            children: [
              const SizedBox(height: 20),

              /// ⭐ Boutons Flashcards + Quiz (3 lignes)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Ligne : Flashcards
                    SizedBox(
                      height: 70,
                      child: _thinButton(
                        icon: Icons.style,
                        label: "Flashcards",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VocabFlashcards(words: vocab),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Ligne : Quiz JP -> FR
                    SizedBox(
                      height: 70,
                      child: _thinButton(
                        icon: Icons.quiz,
                        label: "Quiz JP → FR",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VocabQuiz(
                                words: vocab,
                                mode: QuizMode.jpToFr,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Ligne : Quiz FR -> JP
                    SizedBox(
                      height: 70,
                      child: _thinButton(
                        icon: Icons.quiz_outlined,
                        label: "Quiz FR → JP",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VocabQuiz(
                                words: vocab,
                                mode: QuizMode.frToJp,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Vocabulaire",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: vocab.length,
                  separatorBuilder: (_, __) => const Divider(height: 20),
                  itemBuilder: (context, i) {
                    final w = vocab[i];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            offset: const Offset(1, 2),
                          )
                        ],
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.book, color: Colors.indigo),
                        title: Text(
                          w.jp,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          w.fr,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// ⭐ Bouton homogène
  Widget _bigButton({
    required IconData icon,
    required String label,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: const Color(0xFFCC0000)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ⭐ Bouton plus fin pour 1 par ligne
Widget _thinButton({
  required IconData icon,
  required String label,
  required Function() onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(2, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 26, color: const Color(0xFFCC0000)),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
