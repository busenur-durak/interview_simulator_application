import 'dart:math';

import 'enums.dart';
import 'sector_data.dart';
import 'hr_style_data.dart';
import 'level_data.dart';
import 'question_record.dart';

class InterviewState {
  final SectorData sector;
  final PositionData position;
  final LevelData level;
  final HRStyleData hrStyle;
  final String language;
  String hrName = '';

  final List<QuestionRecord> records = [];
  final Map<TopicCategory, List<String>> remainingTopics;
  final Map<TopicCategory, List<String>> coveredTopics;

  /// Model-assessed quality scores keyed by question number.
  /// Parsed from the `[EVAL:X]` tag the model outputs at the start of each
  /// response. Covers technical accuracy + communication quality (Tiers 2-3).
  final Map<int, int> modelQualityScores = {};
  InterviewEndReason? endReason;
  String? currentTopic;
  TopicCategory? currentCategory;

  /// Flags when the interview is transitioning toward ending.
  /// Set by FlowController when quality-based or turn-based closing triggers.
  bool isClosingPhase = false;

  /// Tracks how many Q&A turns have passed since [isClosingPhase] was set.
  /// Used by FlowController to allow a gradual 2-turn wind-down before the
  /// actual closing prompt fires.
  ///
  /// 0 = trigger turn (soft transition injection)
  /// 1 = second transition turn (stronger wrap-up injection)
  /// 2+ = FlowController returns [InterviewAction.close]
  int closingTurnCount = 0;

  InterviewState({
    required this.sector,
    required this.position,
    required this.level,
    required this.hrStyle,
    required this.language,
  })  : remainingTopics = {
          for (final entry in position.topics.entries)
            entry.key: List<String>.from(entry.value),
        },
        coveredTopics = {
          for (final category in TopicCategory.values) category: <String>[],
        };

  int get completedQuestions => records.length;

  int get nextQuestionNumber => records.length + 1;

  /// Interview phase based on question number (adapted for 7-15 range).
  ///
  /// Phase 1 (Warm-up):  Q1-2
  /// Phase 2 (Core):     Q3-6
  /// Phase 3 (Deep):     Q7-10
  /// Phase 4 (Closing):  Q11+
  int get currentPhase {
    final next = nextQuestionNumber;
    if (next <= 2) return 1;
    if (next <= 6) return 2;
    if (next <= 10) return 3;
    return 4;
  }

  /// Composite answer quality score (1.0–3.0), averaging two tiers:
  ///
  /// **Tier 1 — Length** (code-level):
  ///   brief (≤20 words) = 1, moderate (21-60) = 2, detailed (>60) = 3.
  ///
  /// **Tier 2 — Technical depth + Communication** (model-assessed via EVAL tag):
  ///   1 = weak/incorrect/rude, 2 = adequate, 3 = strong + professional.
  ///   Falls back to word-count score when the model score is not yet available.
  ///
  /// Used by FlowController to decide fast-track vs extended-track closing.
  double get averageAnswerQuality {
    if (records.isEmpty) return 0.0;
    double total = 0;
    for (final r in records) {
      // Tier 1: word count
      final double wordScore;
      if (r.answerWordCount > 60) {
        wordScore = 3.0;
      } else if (r.answerWordCount > 20) {
        wordScore = 2.0;
      } else {
        wordScore = 1.0;
      }

      // Tier 2: model-assessed (falls back to word score if unavailable)
      final modelScore =
          modelQualityScores[r.questionNumber]?.toDouble() ?? wordScore;

      total += (wordScore + modelScore) / 2;
    }
    return total / records.length;
  }

  int get totalRemainingTopics =>
      remainingTopics.values.expand((t) => t).length;

  int get totalCoveredTopics =>
      coveredTopics.values.expand((t) => t).length;

  List<String> get allRemainingTopicNames =>
      remainingTopics.values.expand((t) => t).toList();

  List<TopicCategory> lastNCategories(int n) {
    final count = min(n, records.length);
    if (count == 0) return [];
    return records
        .sublist(records.length - count)
        .map((r) => r.category)
        .toList();
  }

  void markTopicCovered(String topic, TopicCategory category) {
    remainingTopics[category]?.remove(topic);
    if (coveredTopics[category] != null &&
        !coveredTopics[category]!.contains(topic)) {
      coveredTopics[category]!.add(topic);
    }
  }

  void addRecord(QuestionRecord record) {
    records.add(record);
    markTopicCovered(record.topic, record.category);
  }
}
