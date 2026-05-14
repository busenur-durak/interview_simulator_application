import '../models/enums.dart';
import '../models/interview_state.dart';
import '../models/question_record.dart';
import '../models/sector_data.dart';
import '../config/hr_styles.dart';
import '../config/levels.dart';
import '../config/system_template.dart';
import '../evaluation/final_evaluator.dart';
import 'prompt_builder.dart';
import 'memory_manager.dart';
import 'topic_selector.dart';
import 'phase_manager.dart';
import 'flow_controller.dart';
import '../sectors/tech_sector.dart';
import '../sectors/business_sector.dart';
import '../sectors/marketing_sector.dart';
import '../sectors/service_sector.dart';

class TurnResult {
  final String nextPrompt;
  final bool isFinalTurn;

  const TurnResult({required this.nextPrompt, this.isFinalTurn = false});
}

class InterviewManager {
  final InterviewState state;
  final String _systemPrompt;
  bool _isComplete = false;
  String _lastQuestionStyle = 'open-ended and conversational';

  // ---------------------------------------------------------------------------
  // Sector registry
  // ---------------------------------------------------------------------------

  static final List<SectorData> allSectors = [
    techSector,
    businessSector,
    marketingSector,
    serviceSector,
  ];

  static SectorData getSector(String sectorId) {
    for (final sector in allSectors) {
      if (sector.id == sectorId) return sector;
    }
    throw ArgumentError('Unknown sector: $sectorId');
  }

  static List<String> get sectorIds => allSectors.map((s) => s.id).toList();

  static List<String> get sectorNames => allSectors.map((s) => s.name).toList();

  static List<String> getPositionIds(String sectorId) =>
      getSector(sectorId).positionIds;

  static List<String> getPositionNames(String sectorId) =>
      getSector(sectorId).positionNames;

  static List<String> get levelIds => Levels.all.map((l) => l.id).toList();

  static List<String> get levelNames => Levels.all.map((l) => l.name).toList();

  static List<String> get hrStyleIds =>
      HRStyles.all.map((h) => h.id).toList();

  static List<String> get hrStyleNames =>
      HRStyles.all.map((h) => h.name).toList();

  // ---------------------------------------------------------------------------
  // Construction
  // ---------------------------------------------------------------------------

  InterviewManager._({
    required this.state,
    required String systemPrompt,
  }) : _systemPrompt = systemPrompt;

  factory InterviewManager({
    required String sectorId,
    required String positionId,
    required String levelId,
    required String hrStyleId,
    required String language,
    String? candidateName,
  }) {
    final sector = getSector(sectorId);
    final position = sector.getPosition(positionId);
    if (position == null) {
      throw ArgumentError(
        'Unknown position "$positionId" in sector "$sectorId"',
      );
    }
    final level = Levels.getById(levelId);
    final hrStyle = HRStyles.getById(hrStyleId);

    final interviewState = InterviewState(
      sector: sector,
      position: position,
      level: level,
      hrStyle: hrStyle,
      language: language,
    );

    interviewState.currentTopic = 'Self Introduction';
    interviewState.currentCategory = TopicCategory.culture;

    final result = SystemTemplate.build(
      hrStyle: hrStyle,
      sector: sector,
      position: position,
      level: level,
      language: language,
      candidateName: candidateName,
    );

    interviewState.hrName = result.hrName;

    return InterviewManager._(
      state: interviewState,
      systemPrompt: result.prompt,
    );
  }

  // ---------------------------------------------------------------------------
  // Public getters
  // ---------------------------------------------------------------------------

  bool get isInterviewComplete => _isComplete;

  bool get canRequestFinish =>
      state.completedQuestions >= FlowController.minQuestions;

  String get hrName => state.hrName;

  InterviewEndReason? get endReason => state.endReason;

  // ---------------------------------------------------------------------------
  // Interview flow
  // ---------------------------------------------------------------------------

  String buildOpeningPrompt() {
    return PromptBuilder.buildOpeningPrompt(systemPrompt: _systemPrompt);
  }

  TurnResult processAnswer({
    required String modelQuestion,
    required String userAnswer,
  }) {
    assert(!_isComplete, 'Cannot process answer after interview is complete');

    final candidateWantsEnd =
        FlowController.detectCandidateEndRequest(userAnswer);

    // Record Q&A
    final questionNumber = state.nextQuestionNumber;
    final topic = state.currentTopic ?? 'General';
    final category = state.currentCategory ?? TopicCategory.hybrid;
    final trimmed = userAnswer.trim();
    final wordCount =
        trimmed.isEmpty ? 0 : trimmed.split(RegExp(r'\s+')).length;

    state.addRecord(QuestionRecord(
      questionNumber: questionNumber,
      topic: topic,
      category: category,
      questionStyle: _lastQuestionStyle,
      rawQuestion: modelQuestion,
      rawAnswer: userAnswer,
      answerWordCount: wordCount,
    ));

    // Candidate explicitly asked to end in chat
    if (candidateWantsEnd &&
        state.completedQuestions >= FlowController.minQuestions) {
      state.endReason = InterviewEndReason.candidateAskedInChat;
      return _buildClosingResult(userAnswer);
    }

    // User-initiated early exit: during closing phase, softer closing remarks
    // from the candidate also trigger immediate termination.
    if (state.isClosingPhase &&
        FlowController.detectClosingRemarks(userAnswer)) {
      state.endReason = InterviewEndReason.candidateAskedInChat;
      return _buildClosingResult(userAnswer);
    }

    // Finish was requested via button
    if (state.endReason == InterviewEndReason.userRequestedEnd) {
      return _buildClosingResult(userAnswer);
    }

    // Normal flow decision (quality-based dynamic length)
    final action = FlowController.decide(state);

    return switch (action) {
      InterviewAction.continueInterview =>
        _buildContinueResult(userAnswer, topic),
      InterviewAction.close => () {
          state.endReason ??= InterviewEndReason.naturalCompletion;
          return _buildClosingResult(userAnswer);
        }(),
      InterviewAction.forceClose => () {
          state.endReason = InterviewEndReason.hardCap;
          return _buildForceCloseResult(userAnswer);
        }(),
    };
  }

  // ---------------------------------------------------------------------------
  // User controls
  // ---------------------------------------------------------------------------

  List<String> evaluateFinishRequest() {
    return FlowController.evaluateFinishRequest(state);
  }

  void confirmFinish() {
    state.endReason = InterviewEndReason.userRequestedEnd;
  }

  void terminate({bool byModel = false}) {
    state.endReason = byModel
        ? InterviewEndReason.modelTerminated
        : InterviewEndReason.userTerminated;
    _isComplete = true;
  }

  // ---------------------------------------------------------------------------
  // Model quality scoring
  // ---------------------------------------------------------------------------

  /// Stores the model's quality assessment (parsed from `[EVAL:X]` tag) for
  /// the most recently recorded question.
  void recordModelQualityScore(int score) {
    if (state.records.isNotEmpty) {
      state.modelQualityScores[state.records.last.questionNumber] = score;
    }
  }

  // ---------------------------------------------------------------------------
  // Evaluation
  // ---------------------------------------------------------------------------

  String buildEvaluationPrompt() {
    return FinalEvaluator.buildEvaluationPrompt(state);
  }

  Map<String, String> parseEvaluationResponse(String response) {
    return FinalEvaluator.parseEvaluationResponse(response);
  }

  // ---------------------------------------------------------------------------
  // Private — prompt builders
  // ---------------------------------------------------------------------------

  TurnResult _buildContinueResult(String userAnswer, String previousTopic) {
    // Select next topic
    final (nextTopic, nextCategory) = TopicSelector.selectNext(state);

    // Determine follow-up or new topic
    final followUp = FlowController.shouldFollowUp(userAnswer);

    // Update tracking based on decision
    if (followUp == FollowUpDecision.followUp) {
      // Stay on same topic — currentTopic/currentCategory unchanged
    } else {
      state.currentTopic = nextTopic;
      state.currentCategory = nextCategory;
    }

    // Question style for this phase/level
    final style = PhaseManager.getQuestionStyle(
      state.currentPhase,
      state.level.id,
    );
    _lastQuestionStyle = style;

    // Build instruction
    final instruction = PromptBuilder.buildInstruction(
      topic: nextTopic,
      questionStyle: style,
      followUpDecision: followUp,
      currentTopic: previousTopic,
    );

    // Build conversation context (sliding window)
    final context = MemoryManager.buildConversationContext(state);

    // Compute dynamic injection for closing-phase transitions
    final injection = PromptBuilder.buildDynamicInjection(
      questionCount: state.completedQuestions,
      isClosingPhase: state.isClosingPhase,
      closingTurnCount: state.closingTurnCount,
      averageQuality: state.averageAnswerQuality,
    );

    // Assemble full prompt (with optional hidden system note)
    final prompt = PromptBuilder.buildTurnPrompt(
      systemPrompt: _systemPrompt,
      conversationContext: context,
      candidateAnswer: userAnswer,
      instruction: instruction,
      dynamicInjection: injection,
    );

    return TurnResult(nextPrompt: prompt);
  }

  /// Marks the interview as complete. Called by the provider **after** the
  /// final AI response has finished streaming, preventing the UI from
  /// showing the ending overlay before the farewell message is fully visible.
  void markComplete() {
    _isComplete = true;
  }

  TurnResult _buildClosingResult(String userAnswer) {
    // NOTE: _isComplete is NOT set here — the provider calls markComplete()
    // after the closing response finishes streaming.
    final context = MemoryManager.buildConversationContext(state);
    final prompt = PromptBuilder.buildClosingTurnPrompt(
      systemPrompt: _systemPrompt,
      conversationContext: context,
      candidateAnswer: userAnswer,
      closingStyle: state.hrStyle.closingStyle,
    );
    return TurnResult(nextPrompt: prompt, isFinalTurn: true);
  }

  TurnResult _buildForceCloseResult(String userAnswer) {
    // NOTE: _isComplete is NOT set here — see markComplete().
    final context = MemoryManager.buildConversationContext(state);
    final prompt = PromptBuilder.buildForceClosePrompt(
      systemPrompt: _systemPrompt,
      conversationContext: context,
      candidateAnswer: userAnswer,
      closingStyle: state.hrStyle.closingStyle,
    );
    return TurnResult(nextPrompt: prompt, isFinalTurn: true);
  }
}
