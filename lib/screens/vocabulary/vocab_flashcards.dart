import 'package:flutter/material.dart';
import '../../models/vocab_word.dart';
import 'dart:math';

class VocabFlashcards extends StatefulWidget {
  final List<VocabWord> words;
  const VocabFlashcards({super.key, required this.words});

  @override
  State<VocabFlashcards> createState() => _VocabFlashcardsState();
}

class _VocabFlashcardsState extends State<VocabFlashcards>
    with SingleTickerProviderStateMixin {
  int index = 0;
  bool showTranslation = false;

  late AnimationController controller;
  late Animation<Offset> slideAnimation;
  late Animation<double> rotationAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    // IMPORTANT : Initialisation pour éviter LateInitializationError
    slideAnimation = AlwaysStoppedAnimation<Offset>(Offset.zero);
    rotationAnimation = AlwaysStoppedAnimation<double>(0.0);
  }

  void animateCard({required bool forward}) {
    final endOffset =
        forward ? const Offset(-2.0, 0) : const Offset(2.0, 0);
    final endRotation = forward ? -0.3 : 0.3;

    slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: endOffset,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    rotationAnimation = Tween<double>(
      begin: 0,
      end: endRotation,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller.forward().then((_) {
      setState(() {
        if (forward && index < widget.words.length - 1) {
          index++;
        } else if (!forward && index > 0) {
          index--;
        }
        showTranslation = false;
      });

      controller.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.words[index];

    return Scaffold(
      appBar: AppBar(title: const Text("Flashcards")),
      body: Column(
        children: [
          const SizedBox(height: 20),

          /// ⭐ Indicateur de progression
          Text(
            "Carte ${index + 1} / ${widget.words.length}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () =>
                    setState(() => showTranslation = !showTranslation),

                onHorizontalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dx < -200) {
                    if (index < widget.words.length - 1) {
                      animateCard(forward: true);
                    }
                  } else if (details.velocity.pixelsPerSecond.dx > 200) {
                    if (index > 0) {
                      animateCard(forward: false);
                    }
                  }
                },

                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: slideAnimation.value,
                      child: Transform.rotate(
                        angle: rotationAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: Card(
                    elevation: 10,
                    margin: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: 320,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            word.jp,
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 20),

                          AnimatedOpacity(
                            duration:
                                const Duration(milliseconds: 200),
                            opacity: showTranslation ? 1.0 : 0.0,
                            child: Text(
                              word.fr,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.grey.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
