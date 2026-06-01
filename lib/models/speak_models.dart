// ignore_for_file: prefer_initializing_formals
part of 'models.dart';

enum SpeakMode {
  dailyMission,
  roleplay,
  shadowing,
  pronunciationDrill,
  fearBreaker,
  freeTalk,
}

extension SpeakModeText on SpeakMode {
  String get label {
    switch (this) {
      case SpeakMode.dailyMission:
        return 'Daily Mission';
      case SpeakMode.roleplay:
        return 'Roleplay';
      case SpeakMode.shadowing:
        return 'Shadowing';
      case SpeakMode.pronunciationDrill:
        return 'Pronunciation Drill';
      case SpeakMode.fearBreaker:
        return 'Fear Breaker';
      case SpeakMode.freeTalk:
        return 'Free Talk';
    }
  }

  String get shortLabel {
    switch (this) {
      case SpeakMode.dailyMission:
        return 'Mission';
      case SpeakMode.roleplay:
        return 'Roleplay';
      case SpeakMode.shadowing:
        return 'Shadow';
      case SpeakMode.pronunciationDrill:
        return 'Drill';
      case SpeakMode.fearBreaker:
        return 'Fear';
      case SpeakMode.freeTalk:
        return 'Free';
    }
  }
}

enum SpeakSessionPhase {
  ready,
  listening,
  transcriptReady,
  corrected,
  repeatAttempt,
  completed,
  savedToReview,
}

enum SpeakSpeaker { learner, coach }

class SpeakSession {
  final String id;
  final String userId;
  final String missionId;
  final String languageProfileId;
  final SpeakMode mode;
  final String title;
  final String scenarioPrompt;
  final String coachPrompt;
  final List<SpeakTurn> turns;
  final String? transcriptText;
  final double? transcriptConfidence;
  final Correction? correction;
  final SpeakSessionPhase phase;
  final int attemptCount;
  final int durationSeconds;
  final bool isSavedToReview;
  final bool transcriptConfidenceLow;
  final DateTime? _createdAt;
  final DateTime? completedAt;

  const SpeakSession({
    required this.id,
    this.userId = 'user_roy',
    required this.missionId,
    this.languageProfileId = '',
    required this.mode,
    required this.title,
    required this.scenarioPrompt,
    required this.coachPrompt,
    required this.turns,
    required this.transcriptText,
    this.transcriptConfidence,
    required this.correction,
    required this.phase,
    required this.attemptCount,
    this.durationSeconds = 0,
    required this.isSavedToReview,
    required this.transcriptConfidenceLow,
    DateTime? createdAt,
    this.completedAt,
  }) : _createdAt = createdAt;

  String get scenario => scenarioPrompt;
  DateTime get createdAt => _createdAt ?? _fallbackDate();

  factory SpeakSession.fromJson(Map<String, dynamic> json) {
    final turns = json['turns'];
    final correction = json['correction'];

    return SpeakSession(
      id: _stringValue(json['id'], 'session_mock'),
      userId: _stringValue(json['userId'], 'user_roy'),
      missionId: _stringValue(json['missionId'], 'mission_intro'),
      languageProfileId: _stringValue(json['languageProfileId'], ''),
      mode: _enumValue(SpeakMode.values, json['mode'], SpeakMode.dailyMission),
      title: _stringValue(json['title'], 'Daily Mission'),
      scenarioPrompt: _stringValue(
        json['scenarioPrompt'],
        _stringValue(json['scenario'], 'Speak clearly.'),
      ),
      coachPrompt: _stringValue(json['coachPrompt'], 'Introduce yourself.'),
      turns: turns is List
          ? [
              for (final item in turns)
                if (item is Map<String, dynamic>) SpeakTurn.fromJson(item),
            ]
          : const [],
      transcriptText: json['transcriptText'] is String
          ? json['transcriptText'] as String
          : null,
      transcriptConfidence: json['transcriptConfidence'] is num
          ? (json['transcriptConfidence'] as num).toDouble()
          : null,
      correction: correction is Map<String, dynamic>
          ? Correction.fromJson(correction)
          : null,
      phase: _enumValue(
        SpeakSessionPhase.values,
        json['phase'],
        SpeakSessionPhase.ready,
      ),
      attemptCount: _intValue(json['attemptCount'], 0),
      durationSeconds: _intValue(json['durationSeconds'], 0),
      isSavedToReview: _boolValue(json['isSavedToReview'], false),
      transcriptConfidenceLow: _boolValue(
        json['transcriptConfidenceLow'],
        false,
      ),
      createdAt: _dateValue(json['createdAt'], _fallbackDate()),
      completedAt: _dateOrNull(json['completedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'missionId': missionId,
      'languageProfileId': languageProfileId,
      'mode': mode.name,
      'title': title,
      'scenario': scenario,
      'scenarioPrompt': scenarioPrompt,
      'coachPrompt': coachPrompt,
      'turns': [for (final turn in turns) turn.toJson()],
      'transcriptText': transcriptText,
      'transcriptConfidence': transcriptConfidence,
      'correction': correction?.toJson(),
      'phase': phase.name,
      'attemptCount': attemptCount,
      'durationSeconds': durationSeconds,
      'isSavedToReview': isSavedToReview,
      'transcriptConfidenceLow': transcriptConfidenceLow,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': _dateJson(completedAt),
    };
  }

  SpeakSession copyWith({
    String? userId,
    String? languageProfileId,
    SpeakMode? mode,
    List<SpeakTurn>? turns,
    String? transcriptText,
    bool clearTranscript = false,
    double? transcriptConfidence,
    bool clearTranscriptConfidence = false,
    Correction? correction,
    bool clearCorrection = false,
    SpeakSessionPhase? phase,
    int? attemptCount,
    int? durationSeconds,
    bool? isSavedToReview,
    bool? transcriptConfidenceLow,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return SpeakSession(
      id: id,
      userId: userId ?? this.userId,
      missionId: missionId,
      languageProfileId: languageProfileId ?? this.languageProfileId,
      mode: mode ?? this.mode,
      title: title,
      scenarioPrompt: scenarioPrompt,
      coachPrompt: coachPrompt,
      turns: turns ?? this.turns,
      transcriptText: clearTranscript
          ? null
          : transcriptText ?? this.transcriptText,
      transcriptConfidence: clearTranscriptConfidence
          ? null
          : transcriptConfidence ?? this.transcriptConfidence,
      correction: clearCorrection ? null : correction ?? this.correction,
      phase: phase ?? this.phase,
      attemptCount: attemptCount ?? this.attemptCount,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      isSavedToReview: isSavedToReview ?? this.isSavedToReview,
      transcriptConfidenceLow:
          transcriptConfidenceLow ?? this.transcriptConfidenceLow,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class SpeakTurn {
  final String id;
  final SpeakSpeaker speaker;
  final String text;
  final DateTime createdAt;
  final Correction? correction;

  const SpeakTurn({
    required this.id,
    required this.speaker,
    required this.text,
    required this.createdAt,
    this.correction,
  });

  factory SpeakTurn.fromJson(Map<String, dynamic> json) {
    final correction = json['correction'];

    return SpeakTurn(
      id: _stringValue(json['id'], 'turn_mock'),
      speaker: _enumValue(
        SpeakSpeaker.values,
        json['speaker'],
        SpeakSpeaker.coach,
      ),
      text: _stringValue(json['text'], ''),
      createdAt: _dateValue(json['createdAt'], DateTime.now()),
      correction: correction is Map<String, dynamic>
          ? Correction.fromJson(correction)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'speaker': speaker.name,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'correction': correction?.toJson(),
    };
  }

  SpeakTurn copyWith({
    String? id,
    SpeakSpeaker? speaker,
    String? text,
    DateTime? createdAt,
    Correction? correction,
    bool clearCorrection = false,
  }) {
    return SpeakTurn(
      id: id ?? this.id,
      speaker: speaker ?? this.speaker,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      correction: clearCorrection ? null : correction ?? this.correction,
    );
  }
}

class Correction {
  final String id;
  final String originalText;
  final String correctedText;
  final String naturalText;
  final String explanation;
  final String focusArea;
  final int confidenceScore;
  final int pronunciationScore;
  final int grammarScore;
  final int fluencyScore;
  final int vocabularyScore;
  final int responseSpeedScore;
  final double modelConfidence;
  final DateTime? _createdAt;
  final String coachNote;

  const Correction({
    required this.id,
    required this.originalText,
    required this.correctedText,
    required this.naturalText,
    required this.explanation,
    required this.focusArea,
    required this.confidenceScore,
    required this.pronunciationScore,
    required this.grammarScore,
    required this.fluencyScore,
    this.vocabularyScore = 0,
    this.responseSpeedScore = 0,
    this.modelConfidence = 1,
    required this.coachNote,
    DateTime? createdAt,
  }) : _createdAt = createdAt;

  DateTime get createdAt => _createdAt ?? _fallbackDate();

  factory Correction.fromJson(Map<String, dynamic> json) {
    return Correction(
      id: _stringValue(json['id'], 'correction_mock'),
      originalText: _stringValue(json['originalText'], ''),
      correctedText: _stringValue(json['correctedText'], ''),
      naturalText: _stringValue(json['naturalText'], ''),
      explanation: _stringValue(json['explanation'], ''),
      focusArea: _stringValue(json['focusArea'], 'Speaking confidence'),
      confidenceScore: _intValue(json['confidenceScore'], 0),
      pronunciationScore: _intValue(json['pronunciationScore'], 0),
      grammarScore: _intValue(json['grammarScore'], 0),
      fluencyScore: _intValue(json['fluencyScore'], 0),
      vocabularyScore: _intValue(json['vocabularyScore'], 0),
      responseSpeedScore: _intValue(json['responseSpeedScore'], 0),
      modelConfidence: _doubleValue(json['modelConfidence'], 1),
      coachNote: _stringValue(json['coachNote'], ''),
      createdAt: _dateValue(json['createdAt'], _fallbackDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originalText': originalText,
      'correctedText': correctedText,
      'naturalText': naturalText,
      'explanation': explanation,
      'focusArea': focusArea,
      'confidenceScore': confidenceScore,
      'pronunciationScore': pronunciationScore,
      'grammarScore': grammarScore,
      'fluencyScore': fluencyScore,
      'vocabularyScore': vocabularyScore,
      'responseSpeedScore': responseSpeedScore,
      'modelConfidence': modelConfidence,
      'coachNote': coachNote,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Correction copyWith({
    String? id,
    String? originalText,
    String? correctedText,
    String? naturalText,
    String? explanation,
    String? focusArea,
    String? coachNote,
    int? confidenceScore,
    int? pronunciationScore,
    int? grammarScore,
    int? fluencyScore,
    int? vocabularyScore,
    int? responseSpeedScore,
    double? modelConfidence,
    DateTime? createdAt,
  }) {
    return Correction(
      id: id ?? this.id,
      originalText: originalText ?? this.originalText,
      correctedText: correctedText ?? this.correctedText,
      naturalText: naturalText ?? this.naturalText,
      explanation: explanation ?? this.explanation,
      focusArea: focusArea ?? this.focusArea,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      pronunciationScore: pronunciationScore ?? this.pronunciationScore,
      grammarScore: grammarScore ?? this.grammarScore,
      fluencyScore: fluencyScore ?? this.fluencyScore,
      vocabularyScore: vocabularyScore ?? this.vocabularyScore,
      responseSpeedScore: responseSpeedScore ?? this.responseSpeedScore,
      modelConfidence: modelConfidence ?? this.modelConfidence,
      coachNote: coachNote ?? this.coachNote,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TranscriptResult {
  final String id;
  final String sessionId;
  final String transcriptText;
  final double transcriptConfidence;
  final bool confidenceLow;
  final String languageDetected;
  final String provider;
  final String requestId;
  final DateTime? _createdAt;

  const TranscriptResult({
    required this.id,
    required this.sessionId,
    required this.transcriptText,
    required this.transcriptConfidence,
    required this.confidenceLow,
    this.languageDetected = 'unknown',
    this.provider = 'mock',
    this.requestId = 'mock_request',
    DateTime? createdAt,
  }) : _createdAt = createdAt;

  DateTime get createdAt => _createdAt ?? _fallbackDate();

  factory TranscriptResult.fromJson(Map<String, dynamic> json) {
    return TranscriptResult(
      id: _stringValue(json['id'], 'transcript_mock'),
      sessionId: _stringValue(json['sessionId'], 'session_mock'),
      transcriptText: _stringValue(json['transcriptText'], ''),
      transcriptConfidence: _doubleValue(json['transcriptConfidence'], 0),
      confidenceLow: _boolValue(
        json['confidenceLow'],
        _boolValue(json['transcriptConfidenceLow'], false),
      ),
      languageDetected: _stringValue(json['languageDetected'], 'unknown'),
      provider: _stringValue(json['provider'], 'mock'),
      requestId: _stringValue(json['requestId'], 'mock_request'),
      createdAt: _dateValue(json['createdAt'], _fallbackDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'transcriptText': transcriptText,
      'transcriptConfidence': transcriptConfidence,
      'confidenceLow': confidenceLow,
      'languageDetected': languageDetected,
      'provider': provider,
      'requestId': requestId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  TranscriptResult copyWith({
    String? id,
    String? sessionId,
    String? transcriptText,
    double? transcriptConfidence,
    bool? confidenceLow,
    String? languageDetected,
    String? provider,
    String? requestId,
    DateTime? createdAt,
  }) {
    return TranscriptResult(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      transcriptText: transcriptText ?? this.transcriptText,
      transcriptConfidence: transcriptConfidence ?? this.transcriptConfidence,
      confidenceLow: confidenceLow ?? this.confidenceLow,
      languageDetected: languageDetected ?? this.languageDetected,
      provider: provider ?? this.provider,
      requestId: requestId ?? this.requestId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CorrectionRequest {
  final String id;
  final String userId;
  final String languageProfileId;
  final String missionId;
  final String sessionId;
  final SpeakMode mode;
  final String region;
  final String baseLanguageCode;
  final String targetLanguageCode;
  final String learningGoal;
  final String currentLevel;
  final String transcriptText;
  final double transcriptConfidence;
  final List<String> userWeakAreas;
  final String correctionStrictness;
  final DateTime? _createdAt;

  const CorrectionRequest({
    required this.id,
    required this.userId,
    required this.languageProfileId,
    required this.missionId,
    required this.sessionId,
    required this.mode,
    required this.region,
    required this.baseLanguageCode,
    required this.targetLanguageCode,
    required this.learningGoal,
    required this.currentLevel,
    required this.transcriptText,
    this.transcriptConfidence = 1,
    this.userWeakAreas = const [],
    this.correctionStrictness = 'balanced',
    DateTime? createdAt,
  }) : _createdAt = createdAt;

  DateTime get createdAt => _createdAt ?? _fallbackDate();

  factory CorrectionRequest.fromJson(Map<String, dynamic> json) {
    return CorrectionRequest(
      id: _stringValue(json['id'], 'correction_request_mock'),
      userId: _stringValue(json['userId'], 'user_roy'),
      languageProfileId: _stringValue(json['languageProfileId'], ''),
      missionId: _stringValue(json['missionId'], 'mission_intro'),
      sessionId: _stringValue(json['sessionId'], 'session_mock'),
      mode: _enumValue(SpeakMode.values, json['mode'], SpeakMode.dailyMission),
      region: _stringValue(json['region'], 'Global'),
      baseLanguageCode: _stringValue(json['baseLanguageCode'], 'en'),
      targetLanguageCode: _stringValue(json['targetLanguageCode'], 'en'),
      learningGoal: _stringValue(json['learningGoal'], 'Speak with confidence'),
      currentLevel: _stringValue(json['currentLevel'], 'I know some words'),
      transcriptText: _stringValue(json['transcriptText'], ''),
      transcriptConfidence: _doubleValue(json['transcriptConfidence'], 1),
      userWeakAreas: _stringList(json['userWeakAreas']),
      correctionStrictness: _stringValue(
        json['correctionStrictness'],
        'balanced',
      ),
      createdAt: _dateValue(json['createdAt'], _fallbackDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'languageProfileId': languageProfileId,
      'missionId': missionId,
      'sessionId': sessionId,
      'mode': mode.name,
      'region': region,
      'baseLanguageCode': baseLanguageCode,
      'targetLanguageCode': targetLanguageCode,
      'learningGoal': learningGoal,
      'currentLevel': currentLevel,
      'transcriptText': transcriptText,
      'transcriptConfidence': transcriptConfidence,
      'userWeakAreas': userWeakAreas,
      'correctionStrictness': correctionStrictness,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  CorrectionRequest copyWith({
    String? id,
    String? userId,
    String? languageProfileId,
    String? missionId,
    String? sessionId,
    SpeakMode? mode,
    String? region,
    String? baseLanguageCode,
    String? targetLanguageCode,
    String? learningGoal,
    String? currentLevel,
    String? transcriptText,
    double? transcriptConfidence,
    List<String>? userWeakAreas,
    String? correctionStrictness,
    DateTime? createdAt,
  }) {
    return CorrectionRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      languageProfileId: languageProfileId ?? this.languageProfileId,
      missionId: missionId ?? this.missionId,
      sessionId: sessionId ?? this.sessionId,
      mode: mode ?? this.mode,
      region: region ?? this.region,
      baseLanguageCode: baseLanguageCode ?? this.baseLanguageCode,
      targetLanguageCode: targetLanguageCode ?? this.targetLanguageCode,
      learningGoal: learningGoal ?? this.learningGoal,
      currentLevel: currentLevel ?? this.currentLevel,
      transcriptText: transcriptText ?? this.transcriptText,
      transcriptConfidence: transcriptConfidence ?? this.transcriptConfidence,
      userWeakAreas: userWeakAreas ?? this.userWeakAreas,
      correctionStrictness: correctionStrictness ?? this.correctionStrictness,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CompletedSessionEvent {
  final String id;
  final String userId;
  final String languageProfileId;
  final String missionId;
  final String sessionId;
  final int durationSeconds;
  final int estimatedMinutes;
  final Correction? correction;
  final DateTime completedAt;

  const CompletedSessionEvent({
    required this.id,
    required this.userId,
    required this.languageProfileId,
    required this.missionId,
    required this.sessionId,
    required this.durationSeconds,
    required this.estimatedMinutes,
    this.correction,
    required this.completedAt,
  });

  factory CompletedSessionEvent.fromJson(Map<String, dynamic> json) {
    final correction = json['correction'];
    return CompletedSessionEvent(
      id: _stringValue(json['id'], 'completed_session_mock'),
      userId: _stringValue(json['userId'], 'user_roy'),
      languageProfileId: _stringValue(json['languageProfileId'], ''),
      missionId: _stringValue(json['missionId'], ''),
      sessionId: _stringValue(json['sessionId'], ''),
      durationSeconds: _intValue(json['durationSeconds'], 0),
      estimatedMinutes: _intValue(json['estimatedMinutes'], 0),
      correction: correction is Map<String, dynamic>
          ? Correction.fromJson(correction)
          : null,
      completedAt: _dateValue(json['completedAt'], DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'languageProfileId': languageProfileId,
      'missionId': missionId,
      'sessionId': sessionId,
      'durationSeconds': durationSeconds,
      'estimatedMinutes': estimatedMinutes,
      'correction': correction?.toJson(),
      'completedAt': completedAt.toIso8601String(),
    };
  }

  CompletedSessionEvent copyWith({
    String? id,
    String? userId,
    String? languageProfileId,
    String? missionId,
    String? sessionId,
    int? durationSeconds,
    int? estimatedMinutes,
    Correction? correction,
    bool clearCorrection = false,
    DateTime? completedAt,
  }) {
    return CompletedSessionEvent(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      languageProfileId: languageProfileId ?? this.languageProfileId,
      missionId: missionId ?? this.missionId,
      sessionId: sessionId ?? this.sessionId,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      correction: clearCorrection ? null : correction ?? this.correction,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
