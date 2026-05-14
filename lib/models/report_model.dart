class ReportModel {
  final String interviewId;
  final int technicalScore;
  final int communicationScore;
  final List<String> strengths;
  final List<String> weaknesses;
  final String advice;
  final DateTime createdAt;

  const ReportModel({
    required this.interviewId,
    required this.technicalScore,
    required this.communicationScore,
    required this.strengths,
    required this.weaknesses,
    required this.advice,
    required this.createdAt,
  });

  int get overallScore => ((technicalScore + communicationScore) / 2).round();

  Map<String, dynamic> toMap() {
    return {
      'interviewId': interviewId,
      'technicalScore': technicalScore,
      'communicationScore': communicationScore,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'advice': advice,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      interviewId: map['interviewId'] as String,
      technicalScore: map['technicalScore'] as int,
      communicationScore: map['communicationScore'] as int,
      strengths: List<String>.from(map['strengths'] as List),
      weaknesses: List<String>.from(map['weaknesses'] as List),
      advice: map['advice'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
