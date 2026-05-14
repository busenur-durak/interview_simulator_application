import '../models/enums.dart';

/// Assembles the full prompt text sent to the model for each interview turn.
///
/// Every method returns a single string that is placed in the user-message
/// slot (Gemma 27B IT has no system-prompt support).
class PromptBuilder {
  PromptBuilder._();

  // ---------------------------------------------------------------------------
  // Opening turn — very first message of the interview
  // ---------------------------------------------------------------------------

  /// Produces the prompt for the interviewer's first message.
  /// The model should greet the candidate and ask for a self-introduction.
  static String buildOpeningPrompt({required String systemPrompt}) {
    return '''
$systemPrompt

[YOUR NEXT ACTION]
This is the start of the interview. Greet the candidate, introduce yourself by name, and ask them to briefly introduce themselves and their professional background.'''
        .trim();
  }

  // ---------------------------------------------------------------------------
  // Normal turn — Q2 onwards
  // ---------------------------------------------------------------------------

  /// Produces the prompt for a standard mid-interview turn where the
  /// interviewer reacts to the candidate's latest answer and asks a new
  /// question (or a follow-up).
  ///
  /// When [dynamicInjection] is provided, it is inserted as a `[SYSTEM NOTE]`
  /// block between the candidate's response and the action directive. This is
  /// used for quality-based closing-phase transitions without altering the
  /// system prompt.
  static String buildTurnPrompt({
    required String systemPrompt,
    required String conversationContext,
    required String candidateAnswer,
    required String instruction,
    String? dynamicInjection,
  }) {
    final injectionBlock = dynamicInjection != null
        ? '\n\n[SYSTEM NOTE]\n$dynamicInjection\n'
        : '';

    return '''
$systemPrompt

[CONVERSATION SO FAR]
$conversationContext

[CANDIDATE'S RESPONSE]
$candidateAnswer
$injectionBlock
[YOUR NEXT ACTION]
Start with [EVAL:X] (1=weak/incorrect/rude, 2=adequate, 3=strong technical depth & professional tone). Then:
$instruction'''
        .trim();
  }

  // ---------------------------------------------------------------------------
  // Closing turn — interviewer wraps up naturally
  // ---------------------------------------------------------------------------

  /// Produces the prompt for the final question + professional closing.
  static String buildClosingTurnPrompt({
    required String systemPrompt,
    required String conversationContext,
    required String candidateAnswer,
    required String closingStyle,
  }) {
    return '''
$systemPrompt

[CONVERSATION SO FAR]
$conversationContext

[CANDIDATE'S RESPONSE]
$candidateAnswer

[YOUR NEXT ACTION]
This is the final question. Ask one brief closing question, then wrap up the interview professionally. $closingStyle'''
        .trim();
  }

  // ---------------------------------------------------------------------------
  // Force-close turn — hard cap reached, no more questions
  // ---------------------------------------------------------------------------

  /// Produces the prompt when the interview must end immediately (e.g. Q15
  /// hard cap). The model should NOT ask any further questions.
  static String buildForceClosePrompt({
    required String systemPrompt,
    required String conversationContext,
    required String candidateAnswer,
    required String closingStyle,
  }) {
    return '''
$systemPrompt

[CONVERSATION SO FAR]
$conversationContext

[CANDIDATE'S RESPONSE]
$candidateAnswer

[YOUR NEXT ACTION]
The interview is now over. Do NOT ask any more questions. Thank the candidate sincerely for their time, provide a brief positive remark about the conversation, and close the interview professionally. $closingStyle'''
        .trim();
  }

  // ---------------------------------------------------------------------------
  // Instruction builder — single-line directive for [YOUR NEXT ACTION]
  // ---------------------------------------------------------------------------

  /// Generates the instruction line that tells the model what kind of
  /// question to ask next based on the orchestrator's decision.
  static String buildInstruction({
    required String topic,
    required String questionStyle,
    required FollowUpDecision followUpDecision,
    required String currentTopic,
  }) {
    return switch (followUpDecision) {
      FollowUpDecision.followUp =>
        'Their answer on $currentTopic needs more depth. Ask a specific follow-up that digs into the details.',
      FollowUpDecision.nextTopic =>
        'React to the substance of their answer, then transition to a $questionStyle question about $topic.',
      FollowUpDecision.modelDecides =>
        'Build on their answer — either dig deeper into $currentTopic or naturally transition to a $questionStyle question about $topic.',
    };
  }

  // ---------------------------------------------------------------------------
  // Dynamic prompt injection — quality-based closing transition
  // ---------------------------------------------------------------------------

  /// Builds a hidden system note injected during closing-phase transition
  /// turns. Returns `null` if no injection is needed.
  ///
  /// The injection progressively strengthens across two transition turns:
  ///   [closingTurnCount] 0 → Soft: lighter tone, subtle shift
  ///   [closingTurnCount] 1 → Strong: clear wrap-up signal, final-question feel
  ///
  /// After turn 1, FlowController returns [InterviewAction.close] which
  /// triggers the actual farewell prompt (no injection needed).
  static String? buildDynamicInjection({
    required int questionCount,
    required bool isClosingPhase,
    required int closingTurnCount,
    required double averageQuality,
  }) {
    if (!isClosingPhase) return null;

    // ── Turn 0: Soft transition ──
    if (closingTurnCount == 0) {
      if (averageQuality >= 2.0) {
        return 'The candidate has demonstrated strong competence throughout '
            'the interview. Start subtly shifting the tone — acknowledge a '
            'specific strength from their recent answer, then ask a lighter, '
            'more reflective question. Do NOT announce that the interview is '
            'ending. Everything must sound natural.';
      }
      return 'We are approaching the end of our assessment. Shift to a '
          'lighter, more reflective question. React warmly to their answer '
          'before transitioning. Do NOT announce the interview is ending.';
    }

    // ── Turn 1: Stronger wrap-up signal ──
    if (closingTurnCount == 1) {
      return 'This is your second-to-last question. Ask a brief, '
          'forward-looking question about career goals, growth plans, or '
          'what excites them professionally. Signal that the conversation '
          'is naturally winding down — for example, you might say something '
          'like "as we are wrapping up..." but keep it conversational. '
          'Do NOT mention question counts or quotas.';
    }

    return null;
  }
}
