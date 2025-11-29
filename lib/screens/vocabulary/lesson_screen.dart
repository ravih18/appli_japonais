import 'package:flutter/material.dart';
import '../../data/repositories/vocab_repository.dart';
import '../../models/vocab_word.dart';
import 'vocab_flashcards.dart';
import 'vocab_quiz.dart';

class LessonScreen extends StatefulWidget {
  final int lesson;
  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late Future<List<VocabWord>> futureWords;

  @override
  void initState() {
    super.initState();
    futureWords = VocabRepository().loadLesson(widget.lesson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leçon ${widget.lesson}")),
      body: FutureBuilder(
        future: futureWords,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final words = snapshot.data!;

          return Column(
            children: [
              if (widget.lesson == 13) _lessonMenu(words),
              Expanded(
                child: ListView.builder(
                  itemCount: words.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Text(words[i].jp),
                      subtitle: Text(words[i].fr),
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

  Widget _lessonMenu(List<VocabWord> words) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (_) => VocabFlashcards(words: words)));
          },
          child: const Text("Flashcards"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (_) => VocabQuiz(words: words)));
          },
          child: const Text("Quiz"),
        ),
      ],
    );
  }
}
