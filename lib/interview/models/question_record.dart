import 'enums.dart';

class QuestionRecord {
  final int questionNumber;
  final String topic;
  final TopicCategory category;
  final String questionStyle;
  final String rawQuestion;
  final String rawAnswer;
  final int answerWordCount;

  const QuestionRecord({
    required this.questionNumber,
    required this.topic,
    required this.category,
    required this.questionStyle,
    required this.rawQuestion,
    required this.rawAnswer,
    required this.answerWordCount,
  });

  String get answerLengthCategory {
    if (answerWordCount > 60) return 'detailed';
    if (answerWordCount > 20) return 'moderate';
    return 'brief';
  }
}
