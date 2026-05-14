import '../models/enums.dart';
import '../models/interview_state.dart';
import '../models/question_record.dart';

/// Builds the evaluation prompt sent to the model after the interview ends,
/// and parses the structured response into a usable map.
class FinalEvaluator {
  FinalEvaluator._();

  // ---------------------------------------------------------------------------
  // Tag keys used in the structured response format
  // ---------------------------------------------------------------------------

  static const _tagKeys = <String>[
    'OVERALL_SCORE',
    'TECHNICAL_SCORE',
    'TECHNICAL_FEEDBACK',
    'COMMUNICATION_SCORE',
    'COMMUNICATION_FEEDBACK',
    'PROBLEM_SOLVING_SCORE',
    'PROBLEM_SOLVING_FEEDBACK',
    'CULTURAL_FIT_SCORE',
    'CULTURAL_FIT_FEEDBACK',
    'STRENGTHS',
    'WEAKNESSES',
    'RECOMMENDATION',
    'SUMMARY',
  ];

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Assembles the full evaluation prompt from the completed interview state.
  static String buildEvaluationPrompt(InterviewState state) {
    final metadata = _buildMetadata(state);
    final transcript = _formatTranscript(state.records);
    final scoringRules = _buildScoringRules(state);
    final responseFormat = _buildResponseFormat();

    return '''
You are an expert interview evaluator with deep experience in hiring for ${state.sector.name} roles. Analyze the following interview transcript and provide a detailed, fair assessment.

=== INTERVIEW METADATA ===
$metadata

=== FULL TRANSCRIPT ===
$transcript

=== EVALUATION INSTRUCTIONS ===
Evaluate the candidate across four dimensions: Technical Knowledge, Communication Skills, Problem-Solving Ability, and Cultural Fit. Then provide an overall assessment.

$scoringRules

=== REQUIRED RESPONSE FORMAT ===
You MUST respond using the EXACT tag structure below. Do not add any text outside these tags. Each score must be an integer from 0 to 100.

$responseFormat'''
        .trim();
  }

  /// Parses the model's structured evaluation response into a map of
  /// lowercase-snake-case keys to trimmed string values.
  ///
  /// Returns an empty string for any tag that is missing from the response.
  static Map<String, String> parseEvaluationResponse(String response) {
    final result = <String, String>{};

    for (final tag in _tagKeys) {
      final mapKey = tag.toLowerCase();
      final pattern = RegExp(
        r'\[' + tag + r'\]\s*([\s\S]*?)\s*\[\/' + tag + r'\]',
      );
      final match = pattern.firstMatch(response);
      result[mapKey] = match != null ? match.group(1)!.trim() : '';
    }

    return result;
  }

  // ---------------------------------------------------------------------------
  // Private helpers — metadata
  // ---------------------------------------------------------------------------

  static String _buildMetadata(InterviewState state) {
    final uncoveredTopics = state.allRemainingTopicNames;
    final uncoveredDisplay = uncoveredTopics.isEmpty
        ? 'All topics were covered'
        : uncoveredTopics.join(', ');

    final categoryBreakdown = _buildCategoryBreakdown(state.records);

    return '''
Position: ${state.position.name}
Sector: ${state.sector.name}
Expected Level: ${state.level.name}
HR Style Used: ${state.hrStyle.name}
Language: ${state.language}
Total Questions Asked: ${state.completedQuestions}
End Reason: ${_formatEndReason(state.endReason)}
Topics Not Covered: $uncoveredDisplay
$categoryBreakdown'''
        .trim();
  }

  static String _buildCategoryBreakdown(List<QuestionRecord> records) {
    if (records.isEmpty) return 'Question Breakdown: No questions were asked.';

    final counts = <TopicCategory, int>{};
    for (final record in records) {
      counts[record.category] = (counts[record.category] ?? 0) + 1;
    }

    final parts = counts.entries
        .map((e) => '${e.key.displayName}: ${e.value}')
        .join(', ');

    return 'Question Breakdown by Category: $parts';
  }

  // ---------------------------------------------------------------------------
  // Private helpers — transcript
  // ---------------------------------------------------------------------------

  /// Formats the full list of Q&A records into a numbered transcript block.
  static String _formatTranscript(List<QuestionRecord> records) {
    if (records.isEmpty) {
      return 'No questions were asked during this interview.';
    }

    final buffer = StringBuffer();

    for (final record in records) {
      buffer.writeln(
        'Q${record.questionNumber} [${record.category.displayName}] '
        'Topic: ${record.topic}',
      );
      buffer.writeln('Interviewer: ${record.rawQuestion}');
      buffer.writeln('Candidate: ${record.rawAnswer}');
      buffer.writeln('Answer depth: ${record.answerLengthCategory}');
      buffer.writeln();
    }

    return buffer.toString().trim();
  }

  // ---------------------------------------------------------------------------
  // Private helpers — end reason
  // ---------------------------------------------------------------------------

  /// Returns a human-readable description of the interview end reason.
  static String _formatEndReason(InterviewEndReason? reason) {
    return switch (reason) {
      InterviewEndReason.naturalCompletion =>
        'Interview completed naturally — all planned topics were covered',
      InterviewEndReason.userRequestedEnd =>
        'Candidate requested to end the interview (via button)',
      InterviewEndReason.candidateAskedInChat =>
        'Candidate asked to end the interview during the conversation',
      InterviewEndReason.userTerminated =>
        'Interview was terminated early by the candidate',
      InterviewEndReason.modelTerminated =>
        'Interview was terminated by the interviewer due to inappropriate candidate behavior',
      InterviewEndReason.hardCap =>
        'Maximum question limit was reached',
      null =>
        'Interview completed normally',
    };
  }

  // ---------------------------------------------------------------------------
  // Private helpers — scoring rules
  // ---------------------------------------------------------------------------

  static String _buildScoringRules(InterviewState state) {
    final buffer = StringBuffer();

    buffer.writeln('SCORING RULES — follow these strictly:');
    buffer.writeln();
    buffer.writeln(
      '1. LEVEL CALIBRATION: The expected level is "${state.level.name}". '
      'Calibrate your scoring accordingly — a junior candidate who demonstrates '
      'solid fundamentals and eagerness to learn should score well. A senior '
      'candidate is expected to show depth, leadership awareness, and '
      'architectural thinking.',
    );
    buffer.writeln();
    buffer.writeln(
      '2. UNCOVERED TOPICS: Some topics may not have been covered due to time '
      'constraints. Mark these as "Not Assessed" where relevant in your '
      'feedback. Do NOT penalize the candidate\'s scores for topics that were '
      'never asked about.',
    );
    buffer.writeln();
    buffer.writeln(
      '3. ANSWER DEPTH: Consider the depth indicators provided '
      '(detailed/moderate/brief). Brief answers are not automatically bad — '
      'concise, correct answers can score well. However, consistently brief '
      'answers with missing key details should be noted.',
    );
    buffer.writeln();

    // End-reason-specific rules
    switch (state.endReason) {
      case InterviewEndReason.candidateAskedInChat:
        buffer.writeln(
          '4. END REASON NOTE: The candidate asked to end the interview '
          'during the conversation. Note this as a minor observation in '
          'the communication assessment — it may indicate discomfort or '
          'time pressure. Do not heavily penalize unless the context '
          'suggests disengagement.',
        );
      case InterviewEndReason.userTerminated:
        buffer.writeln(
          '4. END REASON NOTE: The candidate terminated the interview '
          'early. This is a significant concern. Factor it into the '
          'overall score and communication assessment. The evaluation '
          'should be based only on the answers that were provided, but '
          'the early termination itself should be noted as a negative '
          'signal regarding engagement and commitment.',
        );
      default:
        buffer.writeln(
          '4. END REASON: The interview ended normally. No special '
          'adjustment is needed for the end reason.',
        );
    }

    buffer.writeln();
    buffer.writeln(
      '5. SPECIFICITY: Be fair, specific, and reference actual answers '
      'where possible. Avoid generic praise or criticism — cite concrete '
      'examples from the transcript to support each point.',
    );
    buffer.writeln();
    buffer.writeln(
      '6. LANGUAGE: Generate the ENTIRE evaluation in the same language '
      'as the interview: ${state.language}. All scores, feedback, '
      'strengths, weaknesses, recommendation, and summary must be in '
      '${state.language}.',
    );

    return buffer.toString().trim();
  }

  // ---------------------------------------------------------------------------
  // Private helpers — response format template
  // ---------------------------------------------------------------------------

  static String _buildResponseFormat() {
    return '''
[OVERALL_SCORE]
{integer 0-100}
[/OVERALL_SCORE]

[TECHNICAL_SCORE]
{integer 0-100}
[/TECHNICAL_SCORE]

[TECHNICAL_FEEDBACK]
{2-3 sentences evaluating technical knowledge, referencing specific answers}
[/TECHNICAL_FEEDBACK]

[COMMUNICATION_SCORE]
{integer 0-100}
[/COMMUNICATION_SCORE]

[COMMUNICATION_FEEDBACK]
{2-3 sentences evaluating clarity, structure, and professionalism of communication}
[/COMMUNICATION_FEEDBACK]

[PROBLEM_SOLVING_SCORE]
{integer 0-100}
[/PROBLEM_SOLVING_SCORE]

[PROBLEM_SOLVING_FEEDBACK]
{2-3 sentences evaluating analytical thinking and problem-solving approach}
[/PROBLEM_SOLVING_FEEDBACK]

[CULTURAL_FIT_SCORE]
{integer 0-100}
[/CULTURAL_FIT_SCORE]

[CULTURAL_FIT_FEEDBACK]
{2-3 sentences evaluating alignment with team culture and professional values}
[/CULTURAL_FIT_FEEDBACK]

[STRENGTHS]
- strength 1
- strength 2
- strength 3
[/STRENGTHS]

[WEAKNESSES]
- weakness 1
- weakness 2
- weakness 3
[/WEAKNESSES]

[RECOMMENDATION]
{Exactly one of: Strong Yes / Yes / Maybe / No / Strong No}
[/RECOMMENDATION]

[SUMMARY]
IMPORTANT: This section MUST NOT be empty. Write 3-5 specific, actionable improvement recommendations as a numbered list. Each recommendation MUST directly reference one of the weaknesses listed in the WEAKNESSES section above and provide concrete steps the candidate can take to improve. Example format:
1. [Weakness]: [Specific advice with actionable steps]
2. [Weakness]: [Specific advice with actionable steps]
If the candidate performed well overall, still provide growth-oriented suggestions based on any areas where they could improve further.
[/SUMMARY]'''
        .trim();
  }
}
