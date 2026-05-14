class PhaseManager {
  /// Returns the interview phase (1-4) based on the next question number.
  ///
  /// Adapted for the dynamic 7-15 question range:
  ///
  /// Phase 1 (Warm-up):  Q1-2
  /// Phase 2 (Core):     Q3-6
  /// Phase 3 (Deep):     Q7-10
  /// Phase 4 (Closing):  Q11+
  static int getPhase(int nextQuestionNumber) {
    if (nextQuestionNumber <= 2) return 1;
    if (nextQuestionNumber <= 6) return 2;
    if (nextQuestionNumber <= 10) return 3;
    return 4;
  }

  /// Returns a question style instruction string that guides the AI model on
  /// how to formulate the next question. Varies by [phase] and [levelId].
  ///
  /// [levelId] is typically 'junior', 'mid', or 'senior'.
  static String getQuestionStyle(int phase, String levelId) {
    return switch (phase) {
      1 => 'open-ended and conversational',
      2 => _corePhaseStyle(levelId),
      3 => 'scenario-based with real-world constraints and trade-offs',
      4 => 'reflective, about growth, career goals, and professional vision',
      _ => 'open-ended and conversational', // defensive default
    };
  }

  /// Phase 2 style varies by candidate experience level.
  static String _corePhaseStyle(String levelId) {
    final normalized = levelId.trim().toLowerCase();
    return switch (normalized) {
      'junior' => 'conceptual, asking for definitions and basic understanding',
      'mid' => 'comparative, asking to compare approaches and trade-offs',
      'senior' =>
        'scenario-based, presenting a real-world problem to solve',
      _ => 'comparative, asking to compare approaches and trade-offs',
    };
  }
}
