import 'package:flutter/material.dart';
import '../vocabulary/lesson_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0), // beige clair japonais
      body: SafeArea(
        child: Column(
          children: [
            // ENTÊTE
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/torii.png",
                    height: 100,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "JP Study",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFCC0000),
                    ),
                  ),
                  const Text(
                    "Apprendre le japonais facilement",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  )
                ],
              ),
            ),

            const SizedBox(height: 40),

            // BOUTONS PRINCIPAUX
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(20),
                childAspectRatio: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _menuButton(
                    label: "Vocabulaire",
                    icon: Icons.menu_book,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LessonListScreen()),
                      );
                    },
                  ),
                  _menuButton(
                    label: "Kanji",
                    icon: Icons.translate,
                    onTap: () {}, // À venir
                  ),
                  _menuButton(
                    label: "Grammaire",
                    icon: Icons.list_alt,
                    onTap: () {}, // À venir
                  ),
                  _menuButton(
                    label: "Révisions",
                    icon: Icons.star,
                    onTap: () {}, // À venir
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton({required String label, required IconData icon, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
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
            Icon(icon, size: 50, color: const Color(0xFFCC0000)),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
