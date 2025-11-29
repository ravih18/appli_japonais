class VocabWord {
  final String jp;
  final String fr;

  VocabWord({required this.jp, required this.fr});

  factory VocabWord.fromJson(Map<String, dynamic> json) {
    return VocabWord(
      jp: json["jp"],
      fr: json["fr"],
    );
  }
}
