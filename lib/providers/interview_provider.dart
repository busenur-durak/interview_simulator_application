import 'package:flutter/material.dart';
import '../interview/engine/interview_manager.dart';
import '../interview/models/enums.dart';
import '../models/interview_model.dart';
import '../models/message_model.dart';
import '../models/report_model.dart';
import '../services/api_service.dart';
import '../services/firestore_service.dart';
import '../services/local_storage.dart';

class InterviewProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FirestoreService _firestoreService = FirestoreService();
  final LocalStorage _localStorage = LocalStorage();

  InterviewManager? _manager;
  InterviewModel? _currentInterview;
  final List<MessageModel> _messages = [];
  ReportModel? _report;
  bool _isLoading = false;
  bool _isStreaming = false;
  String? _errorMessage;

  // Interview history
  List<InterviewModel> _interviewHistory = [];
  Map<String, ReportModel> _reportsCache = {};

  // Model-initiated termination detection
  bool _endTokenDetected = false;
  static final _endTokenPattern = RegExp(
    r'model_finish_interview',
    caseSensitive: false,
  );

  // Model quality evaluation tag (parsed and stripped from display)
  static final _evalPattern = RegExp(r'\[EVAL:\s*([1-3])\s*\]');
  static final _evalStripPattern = RegExp(r'\[EVAL:\s*[1-3]\s*\]\s*');

  // Setup selections
  String? _selectedSector;
  String? _selectedPosition;
  String? _selectedLevel;
  int _durationMinutes = 10;
  int _durationSeconds = 0;
  String? _selectedDifficulty;
  String? _selectedLanguage;

  // User ID for Firestore operations
  String? _uid;
  String? _candidateName;

  // ---------------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------------

  InterviewModel? get currentInterview => _currentInterview;
  List<MessageModel> get messages => List.unmodifiable(_messages);
  ReportModel? get report => _report;
  bool get isLoading => _isLoading;
  bool get isStreaming => _isStreaming;
  String? get errorMessage => _errorMessage;
  String? get selectedSector => _selectedSector;
  String? get selectedPosition => _selectedPosition;
  String? get selectedLevel => _selectedLevel;
  int get durationMinutes => _durationMinutes;
  int get durationSeconds => _durationSeconds;
  int get totalDurationSeconds => _durationMinutes * 60 + _durationSeconds;
  String? get selectedDifficulty => _selectedDifficulty;
  String? get selectedLanguage => _selectedLanguage;

  bool get isInterviewComplete => _manager?.isInterviewComplete ?? false;
  bool get canRequestFinish => _manager?.canRequestFinish ?? false;
  String get hrName => _manager?.hrName ?? '';
  InterviewEndReason? get endReason => _manager?.endReason;

  // History getters
  List<InterviewModel> get interviewHistory => List.unmodifiable(_interviewHistory);
  int get totalSessions => _interviewHistory.length;
  int get averageScore {
    final completed = _interviewHistory.where((i) => i.isCompleted).toList();
    if (completed.isEmpty) return 0;
    int sum = 0;
    int count = 0;
    for (final interview in completed) {
      final report = _reportsCache[interview.id];
      if (report != null) {
        sum += report.overallScore;
        count++;
      }
    }
    return count > 0 ? (sum / count).round() : 0;
  }
  InterviewModel? get lastInterview =>
      _interviewHistory.isNotEmpty ? _interviewHistory.first : null;
  ReportModel? getReportForInterview(String interviewId) =>
      _reportsCache[interviewId];

  // ---------------------------------------------------------------------------
  // Setup setters
  // ---------------------------------------------------------------------------

  void setUid(String? uid) {
    _uid = uid;
  }

  void setCandidateName(String? name) {
    _candidateName = name;
  }

  void setSector(String sector) {
    _selectedSector = sector;
    _selectedPosition = null;
    notifyListeners();
  }

  void setPosition(String position) {
    _selectedPosition = position;
    _selectedLevel = null;
    notifyListeners();
  }

  void setLevel(String level) {
    _selectedLevel = level;
    notifyListeners();
  }

  /// Snaps the current duration into a valid range.
  /// Valid states: 0:00 (unlimited) or 5:00–60:00.
  void _enforceRange() {
    final total = _durationMinutes * 60 + _durationSeconds;
    if (total > 3600) {
      _durationMinutes = 10;
      _durationSeconds = 0;
    } else if (total > 0 && total < 300) {
      _durationMinutes = 0;
      _durationSeconds = 0;
    }
  }

  void incrementMinutes() {
    if (_durationMinutes == 0 && _durationSeconds == 0) {
      _durationMinutes = 5;
      _durationSeconds = 0;
    } else {
      _durationMinutes++;
    }
    _enforceRange();
    notifyListeners();
  }

  void decrementMinutes() {
    if (_durationMinutes == 0 && _durationSeconds == 0) {
      _durationMinutes = 60;
      _durationSeconds = 0;
    } else {
      _durationMinutes--;
    }
    _enforceRange();
    notifyListeners();
  }

  void incrementSeconds() {
    if (_durationMinutes == 0 && _durationSeconds == 0) {
      _durationMinutes = 5;
      _durationSeconds = 0;
    } else {
      _durationSeconds = _durationSeconds >= 59 ? 0 : _durationSeconds + 1;
    }
    _enforceRange();
    notifyListeners();
  }

  void decrementSeconds() {
    if (_durationMinutes == 0 && _durationSeconds == 0) {
      _durationMinutes = 60;
      _durationSeconds = 0;
    } else {
      _durationSeconds = _durationSeconds <= 0 ? 59 : _durationSeconds - 1;
    }
    _enforceRange();
    notifyListeners();
  }

  void setDifficulty(String difficulty) {
    _selectedDifficulty = difficulty;
    _selectedLanguage = null;
    notifyListeners();
  }

  void setLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Interview lifecycle
  // ---------------------------------------------------------------------------

  /// Creates the InterviewManager and streams the opening greeting.
  /// Call this and navigate immediately — streaming updates via notifyListeners.
  Future<void> startInterview() async {
    _messages.clear();
    _report = null;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // IDs are now stored directly (no mapping needed)
      final sectorId = _selectedSector!;
      final positionId = _selectedPosition!;
      final levelId = _selectedLevel!;
      final language = _selectedLanguage == 'tr' ? 'Turkish' : 'English';

      // Create the orchestrator
      _manager = InterviewManager(
        sectorId: sectorId,
        positionId: positionId,
        levelId: levelId,
        hrStyleId: _selectedDifficulty!,
        language: language,
        candidateName: _candidateName,
      );

      // Save interview record to Firestore (non-blocking)
      _currentInterview = InterviewModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sector: _selectedSector!,
        position: _selectedPosition!,
        level: _selectedLevel!,
        questionCount: 0,
        createdAt: DateTime.now(),
      );

      // Save to local storage always, Firebase if logged in
      _localStorage.initialize().then((_) {
        _localStorage.saveInterview(_currentInterview!);
      });
      if (_uid != null && _uid != 'guest') {
        _firestoreService
            .saveInterview(_uid!, _currentInterview!)
            .catchError((_) {});
      }

      // Stream the opening greeting
      final openingPrompt = _manager!.buildOpeningPrompt();
      await _streamAiResponse(openingPrompt);
    } catch (e) {
      _isStreaming = false;
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Processes the user's answer and streams the model's next response.
  Future<void> sendMessage(String content) async {
    if (_manager == null || _manager!.isInterviewComplete) return;

    _isLoading = true;
    _errorMessage = null;
    _endTokenDetected = false;
    TurnResult? result;

    // Add user message immediately so it appears in the chat
    _messages.add(MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    ));
    notifyListeners();

    try {
      // The last AI message is the question the model asked
      final lastAiMessage = _messages.lastWhere((m) => !m.isUser).content;

      // InterviewManager: record Q&A, decide flow, build next prompt
      result = _manager!.processAnswer(
        modelQuestion: lastAiMessage,
        userAnswer: content,
      );

      // Stream the model's response with typewriter effect
      final accumulated = await _streamAiResponse(result.nextPrompt);

      // Parse model quality score from [EVAL:X] tag and store it
      final evalMatch = _evalPattern.firstMatch(accumulated);
      if (evalMatch != null && _manager != null) {
        _manager!.recordModelQualityScore(int.parse(evalMatch.group(1)!));
      }

      // Check for model-initiated termination after full response
      if (_endTokenDetected || _endTokenPattern.hasMatch(accumulated)) {
        final cleanResponse =
            accumulated.replaceAll(_endTokenPattern, '').trim();
        if (cleanResponse.isEmpty) {
          _messages.removeLast();
        }
        _manager!.terminate(byModel: true);
      }
      // Mark interview complete AFTER streaming finishes so the ending
      // overlay never appears while the farewell message is still typing.
      else if (result.isFinalTurn) {
        _manager!.markComplete();
      }
    } catch (e) {
      _isStreaming = false;
      // If token was detected during streaming before the error,
      // still terminate the interview gracefully
      if (_endTokenDetected &&
          _manager != null &&
          !_manager!.isInterviewComplete) {
        _manager!.terminate(byModel: true);
      } else if (result != null &&
          result.isFinalTurn &&
          _manager != null &&
          !_manager!.isInterviewComplete) {
        // Final turn errored mid-stream — still mark complete so the
        // interview doesn't get stuck.
        _manager!.markComplete();
      } else {
        _errorMessage = e.toString();
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Streaming helper
  // ---------------------------------------------------------------------------

  /// Streams an AI response chunk by chunk, adding/updating the last AI
  /// message in the list. Returns the full accumulated text.
  Future<String> _streamAiResponse(String prompt) async {
    String accumulated = '';
    bool messageAdded = false;
    String? aiMsgId;
    int? aiMsgIdx;

    await for (final chunk
        in _apiService.generateContentStream(prompt)) {
      accumulated += chunk;

      // Detect termination token during streaming (resilient to stream errors)
      if (!_endTokenDetected && _endTokenPattern.hasMatch(accumulated)) {
        _endTokenDetected = true;
      }

      final displayText = accumulated
          .replaceAll(_evalStripPattern, '')
          .replaceAll(_endTokenPattern, '')
          .trim();

      if (!messageAdded) {
        // First chunk — create the AI message bubble
        aiMsgId = DateTime.now().millisecondsSinceEpoch.toString();
        aiMsgIdx = _messages.length;
        _messages.add(MessageModel(
          id: aiMsgId,
          content: displayText,
          role: MessageRole.ai,
          timestamp: DateTime.now(),
        ));
        messageAdded = true;
        _isStreaming = true;
      } else {
        // Subsequent chunks — update in place
        _messages[aiMsgIdx!] = MessageModel(
          id: aiMsgId!,
          content: displayText,
          role: MessageRole.ai,
          timestamp: _messages[aiMsgIdx].timestamp,
        );
      }
      notifyListeners();
    }

    _isStreaming = false;
    return accumulated;
  }

  // ---------------------------------------------------------------------------
  // User controls
  // ---------------------------------------------------------------------------

  /// Returns uncovered topic names. Empty list = safe to end.
  List<String> evaluateFinishRequest() {
    return _manager?.evaluateFinishRequest() ?? [];
  }

  /// User confirmed they want to finish → next processAnswer will close.
  void confirmFinish() {
    _manager?.confirmFinish();
  }

  /// Hard terminate — interview ends immediately.
  void terminate() {
    _manager?.terminate();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Evaluation
  // ---------------------------------------------------------------------------

  /// Sends the full interview data to the model for final evaluation,
  /// parses the structured response into a ReportModel.
  Future<void> generateReport() async {
    if (_manager == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final evalPrompt = _manager!.buildEvaluationPrompt();
      final evalResponse = await _apiService.generateContent(evalPrompt);
      final parsed = _manager!.parseEvaluationResponse(evalResponse);

      int commScore =
          int.tryParse(parsed['communication_score'] ?? '') ?? 0;

      // Apply -20 penalty for early termination
      final reason = _manager!.endReason;
      if (reason == InterviewEndReason.userTerminated ||
          reason == InterviewEndReason.modelTerminated) {
        commScore = (commScore - 20).clamp(0, 100);
      }

      final weaknesses = _parseList(parsed['weaknesses'] ?? '');

      // Build fallback advice from weaknesses if SUMMARY is empty
      String advice = (parsed['summary'] ?? '').trim();
      if (advice.isEmpty && weaknesses.isNotEmpty) {
        final lang = _manager!.state.language;
        final isTurkish = lang.toLowerCase().contains('turkish') ||
            lang.toLowerCase().contains('türkçe');
        final buffer = StringBuffer();
        for (int i = 0; i < weaknesses.length; i++) {
          if (isTurkish) {
            buffer.writeln(
                '${i + 1}. ${weaknesses[i]}: Bu alanda kendinizi geliştirmek için pratik yapın ve ilgili kaynaklardan çalışın.');
          } else {
            buffer.writeln(
                '${i + 1}. ${weaknesses[i]}: Practice and study relevant resources to improve in this area.');
          }
        }
        advice = buffer.toString().trim();
      }

      _report = ReportModel(
        interviewId: _currentInterview?.id ?? '',
        technicalScore: int.tryParse(parsed['technical_score'] ?? '') ?? 0,
        communicationScore: commScore,
        strengths: _parseList(parsed['strengths'] ?? ''),
        weaknesses: weaknesses,
        advice: advice,
        createdAt: DateTime.now(),
      );

      // Mark interview as completed with endReason
      if (_currentInterview != null) {
        _currentInterview = InterviewModel(
          id: _currentInterview!.id,
          sector: _currentInterview!.sector,
          position: _currentInterview!.position,
          level: _currentInterview!.level,
          questionCount: _manager!.state.records.length,
          createdAt: _currentInterview!.createdAt,
          isCompleted: true,
          endReason: _manager!.endReason?.name,
        );
      }

      // Save to local storage
      await _saveCurrentToHistory();

      // Save report to Firestore
      if (_uid != null && _uid != 'guest' && _report != null) {
        try {
          await Future.wait([
            _firestoreService.saveReport(
                _uid!, _currentInterview!.id, _report!),
            _firestoreService.updateInterviewCompleted(
                _uid!, _currentInterview!.id),
          ]);
        } catch (_) {}
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Parses a bulleted list string into a list of clean strings.
  List<String> _parseList(String raw) {
    return raw
        .split('\n')
        .map((line) => line.replaceFirst(RegExp(r'^[-•]\s*'), '').trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  // ---------------------------------------------------------------------------
  // History management
  // ---------------------------------------------------------------------------

  /// Loads interview history from local storage (and merges Firebase if uid).
  Future<void> loadHistory() async {
    await _localStorage.initialize();
    _interviewHistory = _localStorage.getInterviews();
    _reportsCache = _localStorage.getReportsMap();

    // If user is logged in, also fetch from Firebase and merge
    if (_uid != null && _uid != 'guest') {
      try {
        final firebaseInterviews =
            await _firestoreService.getInterviews(_uid!);
        // Merge: add any Firebase interviews not already in local
        final localIds = _interviewHistory.map((i) => i.id).toSet();
        for (final fi in firebaseInterviews) {
          if (!localIds.contains(fi.id)) {
            _interviewHistory.add(fi);
            await _localStorage.saveInterview(fi);
          }
        }
        // Fetch reports for Firebase interviews
        for (final fi in firebaseInterviews) {
          if (!_reportsCache.containsKey(fi.id) && fi.isCompleted) {
            final report =
                await _firestoreService.getReport(_uid!, fi.id);
            if (report != null) {
              _reportsCache[fi.id] = report;
              await _localStorage.saveReport(report);
            }
          }
        }
      } catch (_) {}
    }

    // Sort by date descending
    _interviewHistory.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  /// Saves current interview + report + messages to local storage.
  Future<void> _saveCurrentToHistory() async {
    if (_currentInterview == null) return;
    await _localStorage.initialize();
    await _localStorage.saveInterview(_currentInterview!);
    if (_report != null) {
      await _localStorage.saveReport(_report!);
      _reportsCache[_currentInterview!.id] = _report!;
    }
    // Save messages for later viewing
    if (_messages.isNotEmpty) {
      await _localStorage.saveMessages(_currentInterview!.id, _messages);
    }
    // Refresh history
    _interviewHistory = _localStorage.getInterviews();
    _interviewHistory.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<void> deleteInterviewFromHistory(String id) async {
    await _localStorage.initialize();
    await _localStorage.deleteInterview(id);
    await _localStorage.deleteMessages(id);
    _reportsCache.remove(id);
    _interviewHistory.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  /// Loads saved messages for a given interview ID.
  List<MessageModel> getMessagesForInterview(String interviewId) {
    return _localStorage.getMessages(interviewId);
  }

  // ---------------------------------------------------------------------------
  // Reset
  // ---------------------------------------------------------------------------

  void resetInterview() {
    _currentInterview = null;
    _manager = null;
    _messages.clear();
    _report = null;
    _selectedSector = null;
    _selectedPosition = null;
    _selectedLevel = null;
    _durationMinutes = 10;
    _durationSeconds = 0;
    _selectedDifficulty = null;
    _selectedLanguage = null;
    _errorMessage = null;
    notifyListeners();
  }
}
