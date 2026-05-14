class InterviewModel {
  final String id;
  final String sector;
  final String position;
  final String level;
  final int questionCount;
  final DateTime createdAt;
  final bool isCompleted;
  final String? endReason; // e.g. 'naturalCompletion', 'userTerminated', etc.

  const InterviewModel({
    required this.id,
    required this.sector,
    required this.position,
    required this.level,
    required this.questionCount,
    required this.createdAt,
    this.isCompleted = false,
    this.endReason,
  });

  bool get isFailed =>
      endReason == 'userTerminated' || endReason == 'modelTerminated';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sector': sector,
      'position': position,
      'level': level,
      'questionCount': questionCount,
      'createdAt': createdAt.toIso8601String(),
      'isCompleted': isCompleted,
      'endReason': endReason,
    };
  }

  factory InterviewModel.fromMap(Map<String, dynamic> map) {
    return InterviewModel(
      id: map['id'] as String,
      sector: map['sector'] as String,
      position: map['position'] as String,
      level: map['level'] as String,
      questionCount: map['questionCount'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      isCompleted: map['isCompleted'] as bool? ?? false,
      endReason: map['endReason'] as String?,
    );
  }
}
