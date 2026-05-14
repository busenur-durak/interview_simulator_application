import 'dart:math';

import '../models/interview_state.dart';
import '../models/question_record.dart';

/// Manages the sliding-window conversation context that is injected into each
/// prompt so the model has memory of prior exchanges without exceeding the
/// context budget.
///
/// Older exchanges are compressed into one-line structural summaries while
/// recent exchanges are kept verbatim, giving the model both long-range
/// awareness and short-range fidelity.
class MemoryManager {
  MemoryManager._();

  /// Default number of recent Q&A pairs kept in full text.
  static const int defaultWindowSize = 8;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Builds the conversation context string from [state.records].
  ///
  /// Records outside the sliding window are compressed to one-line summaries.
  /// Records inside the window are rendered as full interviewer/candidate
  /// exchanges.
  ///
  /// Returns an empty string when there are no records yet.
  static String buildConversationContext(
    InterviewState state, {
    int windowSize = defaultWindowSize,
  }) {
    final records = state.records;
    if (records.isEmpty) return '';

    final windowStart = max(0, records.length - windowSize);
    final buffer = StringBuffer();

    // --- Older records: structural summaries ---
    if (windowStart > 0) {
      buffer.writeln('[Previous questions — summary]');
      for (var i = 0; i < windowStart; i++) {
        buffer.writeln(buildStructuralSummary(records[i]));
      }
      buffer.writeln();
    }

    // --- Recent records: full Q&A text ---
    for (var i = windowStart; i < records.length; i++) {
      final r = records[i];
      buffer.writeln('Interviewer: ${r.rawQuestion}');
      buffer.writeln('Candidate: ${r.rawAnswer}');
      if (i < records.length - 1) buffer.writeln();
    }

    return buffer.toString().trim();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Returns a compact one-line summary of a single [QuestionRecord].
  ///
  /// Format: `Q{n} [{Category}] {topic} — {answerLengthCategory} answer`
  static String buildStructuralSummary(QuestionRecord record) {
    return 'Q${record.questionNumber} '
        '[${record.category.displayName}] '
        '${record.topic} '
        '\u2014 ${record.answerLengthCategory} answer';
  }
}
