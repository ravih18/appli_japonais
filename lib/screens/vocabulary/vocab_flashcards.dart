import 'package:flutter/material.dart';
import '../../models/vocab_word.dart';

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
  late Animation<Offset> animation;

  Offset dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(controller);

    controller.addListener(() {
      setState(() {
        dragOffset = animation.value;
      });
    });
  }

  void animateToPosition(Offset end, {required bool forward}) {
    animation = Tween<Offset>(
      begin: dragOffset,
      end: end,
    ).animate(controller);

    controller.forward().then((_) {
      controller.reset();
      dragOffset = Offset.zero;

      setState(() {
        if (forward && index < widget.words.length - 1) {
          index++;
        } else if (!forward && index > 0) {
          index--;
        }
        showTranslation = false;
      });
    });
  }

  void goNext() {
    animateToPosition(const Offset(-500, 0), forward: true);
  }

  void goPrevious() {
    animateToPosition(const Offset(500, 0), forward: false);
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.words[index];

    return Scaffold(
      appBar: AppBar(title: const Text("Flashcards")),
      body: Column(
        children: [
          const SizedBox(height: 20),

          /// 🔢 Indicateur
          Text(
            "Carte ${index + 1} / ${widget.words.length}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => showTranslation = !showTranslation),

              onHorizontalDragUpdate: (details) {
                setState(() {
                  dragOffset += Offset(details.delta.dx, 0);
                });
              },

              onHorizontalDragEnd: (details) {
                const threshold = 150;

                if (dragOffset.dx < -threshold && index < widget.words.length - 1) {
                  goNext();
                } else if (dragOffset.dx > threshold && index > 0) {
                  goPrevious();
                } else {
                  // Retour au centre
                  animateToPosition(Offset.zero, forward: false);
                }
              },

              child: Transform.translate(
                offset: dragOffset,
                child: Card(
                  elevation: 10,
                  margin: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    height: 320,
                    padding: const EdgeInsets.all(20),
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
                          duration: const Duration(milliseconds: 200),
                          opacity: showTranslation ? 1.0 : 0.0,
                          child: Text(
                            word.fr,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// 🔽 Boutons précédent / suivant
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 40,
                  onPressed: index > 0 ? goPrevious : null,
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
                const SizedBox(width: 40),
                IconButton(
                  iconSize: 40,
                  onPressed: index < widget.words.length - 1 ? goNext : null,
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
