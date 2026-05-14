import '../models/enums.dart';
import '../models/interview_state.dart';

class FlowController {
  // ---------------------------------------------------------------------------
  // Constants
  // ---------------------------------------------------------------------------

  static const int minQuestions = 7;
  static const int maxQuestions = 15;

  /// Minimum average quality score (1.0–3.0) for the fast-track closing path.
  static const double highQualityThreshold = 2.0;

  // ---------------------------------------------------------------------------
  // Core interview flow decision
  // ---------------------------------------------------------------------------

  /// Decides the next action after a completed Q&A round.
  ///
  /// The interview length is dynamically managed between [minQuestions] and
  /// [maxQuestions] based on the candidate's answer quality:
  ///
  /// **High-quality path** (avg quality ≥ 2.0):
  ///   Trigger [isClosingPhase] at Q8 → close by Q9-10.
  ///
  /// **Low-quality / extended path**:
  ///   Bypass early closing → trigger [isClosingPhase] at Q11 → close by Q12-13.
  ///   Hard stop at Q15 regardless.
  ///
  /// **Topics exhausted**: close immediately once minimum is reached.
  static InterviewAction decide(InterviewState state) {
    final completed = state.completedQuestions;
    final remaining = state.totalRemainingTopics;

    // ── Hard cap: force close at 15 questions ──
    if (completed >= maxQuestions) {
      return InterviewAction.forceClose;
    }

    // ── All topics covered after minimum reached → close ──
    if (remaining == 0 && completed >= minQuestions) {
      return InterviewAction.close;
    }

    // ── Minimum threshold not yet reached ──
    if (completed < minQuestions) {
      return InterviewAction.continueInterview;
    }

    // ── Already in closing phase → gradual wind-down ──
    // Turn 0: soft transition injection (continue)
    // Turn 1: stronger wrap-up injection (continue)
    // Turn 2+: actual close
    if (state.isClosingPhase) {
      state.closingTurnCount++;
      if (state.closingTurnCount >= 2) {
        return InterviewAction.close;
      }
      return InterviewAction.continueInterview;
    }

    // ── Quality-based closing decision ──
    final quality = state.averageAnswerQuality;

    // High-quality fast track: enter closing phase at Q8+
    if (quality >= highQualityThreshold && completed >= 8) {
      state.isClosingPhase = true;
      // Return continue — this turn gets the transition prompt injection.
      // Next call to decide() will hit the isClosingPhase check and close.
      return InterviewAction.continueInterview;
    }

    // Extended track: enter closing phase at Q11+
    if (completed >= 11) {
      state.isClosingPhase = true;
      return InterviewAction.continueInterview;
    }

    return InterviewAction.continueInterview;
  }

  // ---------------------------------------------------------------------------
  // Follow-up heuristic
  // ---------------------------------------------------------------------------

  /// Heuristic to decide whether the interviewer should probe deeper into the
  /// candidate's answer, move on, or let the AI model decide.
  static FollowUpDecision shouldFollowUp(String candidateAnswer) {
    final trimmed = candidateAnswer.trim();
    if (trimmed.isEmpty) return FollowUpDecision.followUp;

    final wordCount = trimmed.split(RegExp(r'\s+')).length;

    if (wordCount < 15) return FollowUpDecision.followUp;
    if (wordCount <= 25) return FollowUpDecision.modelDecides;
    return FollowUpDecision.nextTopic;
  }

  // ---------------------------------------------------------------------------
  // User-initiated finish
  // ---------------------------------------------------------------------------

  /// Evaluates whether it is safe to end the interview when the user presses
  /// the "I'm done" button.
  ///
  /// Returns an empty list if conditions are met (OK to close).
  /// Otherwise returns the names of uncovered topics so the UI can display
  /// a confirmation warning.
  static List<String> evaluateFinishRequest(InterviewState state) {
    // Must have answered at least the minimum number of questions.
    if (state.completedQuestions < minQuestions) {
      return state.allRemainingTopicNames;
    }
    final remaining = state.allRemainingTopicNames;
    if (remaining.length <= 3) return [];
    return remaining;
  }

  // ---------------------------------------------------------------------------
  // In-chat end request detection
  // ---------------------------------------------------------------------------

  /// Simple keyword-based detection for when the candidate explicitly asks to
  /// end the interview inside the chat. Supports both Turkish and English.
  static bool detectCandidateEndRequest(String message) {
    final lower = message.toLowerCase();

    const keywords = [
      'bitirmek istiyorum',
      'mülakatı sonlandır',
      'end the interview',
      'i want to stop',
      'finish the interview',
      'mülakatı bitir',
    ];

    return keywords.any((kw) => lower.contains(kw));
  }

  /// Softer closing-remark detection used **only** when [isClosingPhase] is
  /// already active. Detects polite wrap-up phrases that indicate the
  /// candidate is reciprocating the interviewer's closing cues.
  static bool detectClosingRemarks(String message) {
    final lower = message.toLowerCase();

    const keywords = [
      // Turkish
      'teşekkür ederim',
      'teşekkürler',
      'sağ olun',
      'burada bitirebiliriz',
      'bitirelim',
      'ekleyecek bir şeyim yok',
      // English
      'thank you for your time',
      'thanks for the opportunity',
      'we can end here',
      "that's all from me",
      'nothing else to add',
      'i think we can wrap up',
      'we can wrap up',
    ];

    return keywords.any((kw) => lower.contains(kw));
  }
}
