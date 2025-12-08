import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/vocab_word.dart';

class VocabLoader {
  static Future<List<VocabWord>> loadLesson(int lesson) async {
    final path = 'assets/data/vocabulary/lesson_$lesson.json';

    final jsonString = await rootBundle.loadString(path);
    final List<dynamic> data = json.decode(jsonString);

    return data.map((item) => VocabWord.fromJson(item)).toList();
  }
}
