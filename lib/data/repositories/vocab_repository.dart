import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/vocab_word.dart';

class VocabRepository {

  Future<List<VocabWord>> loadLesson(int lesson) async {
    final path = "assets/data/vocabulary/lesson$lesson.json";
    final raw = await rootBundle.loadString(path);
    final List list = jsonDecode(raw);
    return list.map((item) => VocabWord.fromJson(item)).toList();
  }
}
