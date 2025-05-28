// ignore_for_file: public_member_api_docs, sort_constructors_first

class SimilarWordModel {
  String? firstWord;
  String? secondWord;
  SimilarWordModel({
    this.firstWord,
    this.secondWord,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'word': firstWord,
      'same_word': secondWord,
    };
  }

  factory SimilarWordModel.fromJson(Map<String, dynamic> json) {
    return SimilarWordModel(
      firstWord: json['word'] != null ? json['word'] as String : null,
      secondWord: json['same_word'] != null ? json['same_word'] as String : null,
    );
  }

  @override
  String toString() => 'SimilarWordModel(firstWord: $firstWord, secondWord: $secondWord)';
}

final List<SimilarWordModel> similarWords = [
  SimilarWordModel(firstWord: 'حياة', secondWord: 'حيوة'),
];
