enum SubscriptionState { free, pro, proPlus }

extension SubscriptionStateText on SubscriptionState {
  String get label {
    switch (this) {
      case SubscriptionState.free:
        return 'Free';
      case SubscriptionState.pro:
        return 'Pro';
      case SubscriptionState.proPlus:
        return 'Pro Plus';
    }
  }
}

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

class UserProfile {
  final String id;
  final String name;
  final String email;
  final SubscriptionState subscription;
  final LanguageProfile? activeLanguage;
  final bool hasCompletedOnboarding;
  final String speakingGoal;
  final int streakDays;
  final int totalSpeakMinutes;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.subscription,
    required this.activeLanguage,
    required this.hasCompletedOnboarding,
    required this.speakingGoal,
    required this.streakDays,
    required this.totalSpeakMinutes,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    SubscriptionState? subscription,
    LanguageProfile? activeLanguage,
    bool clearActiveLanguage = false,
    bool? hasCompletedOnboarding,
    String? speakingGoal,
    int? streakDays,
    int? totalSpeakMinutes,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      subscription: subscription ?? this.subscription,
      activeLanguage: clearActiveLanguage
          ? null
          : activeLanguage ?? this.activeLanguage,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      speakingGoal: speakingGoal ?? this.speakingGoal,
      streakDays: streakDays ?? this.streakDays,
      totalSpeakMinutes: totalSpeakMinutes ?? this.totalSpeakMinutes,
    );
  }
}

class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final bool isPhaseOne;
  final bool canBeBase;
  final bool canBeTarget;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.isPhaseOne,
    required this.canBeBase,
    required this.canBeTarget,
  });
}

class LanguageProfile {
  final String id;
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final String baseLanguageCode;
  final String baseLanguageName;
  final String level;
  final String focus;
  final int fluencyScore;
  final int confidenceScore;
  final List<String> weakSounds;
  final String scriptMode;
  final bool supportsTransliteration;
  final bool isActive;

  const LanguageProfile({
    required this.id,
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.baseLanguageCode,
    required this.baseLanguageName,
    required this.level,
    required this.focus,
    required this.fluencyScore,
    required this.confidenceScore,
    required this.weakSounds,
    required this.scriptMode,
    required this.supportsTransliteration,
    this.isActive = false,
  });

  LanguageProfile copyWith({
    String? level,
    String? focus,
    int? fluencyScore,
    int? confidenceScore,
    List<String>? weakSounds,
    String? scriptMode,
    bool? supportsTransliteration,
    bool? isActive,
  }) {
    return LanguageProfile(
      id: id,
      code: code,
      name: name,
      nativeName: nativeName,
      flag: flag,
      baseLanguageCode: baseLanguageCode,
      baseLanguageName: baseLanguageName,
      level: level ?? this.level,
      focus: focus ?? this.focus,
      fluencyScore: fluencyScore ?? this.fluencyScore,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      weakSounds: weakSounds ?? this.weakSounds,
      scriptMode: scriptMode ?? this.scriptMode,
      supportsTransliteration:
          supportsTransliteration ?? this.supportsTransliteration,
      isActive: isActive ?? this.isActive,
    );
  }
}

class VoiceBaseline {
  final int pronunciationScore;
  final int confidenceScore;
  final String speed;
  final String firstWeakArea;

  const VoiceBaseline({
    required this.pronunciationScore,
    required this.confidenceScore,
    required this.speed,
    required this.firstWeakArea,
  });
}

class PlanDay {
  final int day;
  final String title;
  final String scenario;

  const PlanDay({
    required this.day,
    required this.title,
    required this.scenario,
  });
}

class OnboardingProfile {
  final String baseLanguageCode;
  final String baseLanguageName;
  final String targetLanguageCode;
  final String targetLanguageName;
  final String learningGoal;
  final String currentLevel;
  final String speakingConfidence;
  final int dailyMinutes;
  final VoiceBaseline voiceBaseline;
  final List<PlanDay> sevenDayPlan;

  const OnboardingProfile({
    required this.baseLanguageCode,
    required this.baseLanguageName,
    required this.targetLanguageCode,
    required this.targetLanguageName,
    required this.learningGoal,
    required this.currentLevel,
    required this.speakingConfidence,
    required this.dailyMinutes,
    required this.voiceBaseline,
    required this.sevenDayPlan,
  });
}

class DailyMission {
  final String id;
  final String languageCode;
  final String title;
  final String description;
  final String scenario;
  final String coachPrompt;
  final String successCue;
  final List<String> targetPhrases;
  final int estimatedMinutes;
  final String difficulty;
  final String focusArea;
  final String category;
  final bool isCompleted;

  const DailyMission({
    required this.id,
    required this.languageCode,
    required this.title,
    required this.description,
    required this.scenario,
    required this.coachPrompt,
    required this.successCue,
    required this.targetPhrases,
    required this.estimatedMinutes,
    required this.difficulty,
    required this.focusArea,
    required this.category,
    this.isCompleted = false,
  });

  DailyMission copyWith({bool? isCompleted}) {
    return DailyMission(
      id: id,
      languageCode: languageCode,
      title: title,
      description: description,
      scenario: scenario,
      coachPrompt: coachPrompt,
      successCue: successCue,
      targetPhrases: targetPhrases,
      estimatedMinutes: estimatedMinutes,
      difficulty: difficulty,
      focusArea: focusArea,
      category: category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class SpeakSession {
  final String id;
  final String missionId;
  final SpeakMode mode;
  final String title;
  final String scenarioPrompt;
  final String coachPrompt;
  final List<SpeakTurn> turns;
  final String? transcriptText;
  final Correction? correction;
  final SpeakSessionPhase phase;
  final int attemptCount;
  final bool isSavedToReview;
  final bool transcriptConfidenceLow;

  const SpeakSession({
    required this.id,
    required this.missionId,
    required this.mode,
    required this.title,
    required this.scenarioPrompt,
    required this.coachPrompt,
    required this.turns,
    required this.transcriptText,
    required this.correction,
    required this.phase,
    required this.attemptCount,
    required this.isSavedToReview,
    required this.transcriptConfidenceLow,
  });

  SpeakSession copyWith({
    SpeakMode? mode,
    List<SpeakTurn>? turns,
    String? transcriptText,
    bool clearTranscript = false,
    Correction? correction,
    bool clearCorrection = false,
    SpeakSessionPhase? phase,
    int? attemptCount,
    bool? isSavedToReview,
    bool? transcriptConfidenceLow,
  }) {
    return SpeakSession(
      id: id,
      missionId: missionId,
      mode: mode ?? this.mode,
      title: title,
      scenarioPrompt: scenarioPrompt,
      coachPrompt: coachPrompt,
      turns: turns ?? this.turns,
      transcriptText: clearTranscript
          ? null
          : transcriptText ?? this.transcriptText,
      correction: clearCorrection ? null : correction ?? this.correction,
      phase: phase ?? this.phase,
      attemptCount: attemptCount ?? this.attemptCount,
      isSavedToReview: isSavedToReview ?? this.isSavedToReview,
      transcriptConfidenceLow:
          transcriptConfidenceLow ?? this.transcriptConfidenceLow,
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
    required this.coachNote,
  });
}

class ReviewItem {
  final String id;
  final String languageCode;
  final String languageName;
  final String missionTitle;
  final Correction correction;
  final DateTime dateAdded;
  final bool isMastered;
  final bool isSavedPhrase;
  final int reviewedCount;

  const ReviewItem({
    required this.id,
    required this.languageCode,
    required this.languageName,
    required this.missionTitle,
    required this.correction,
    required this.dateAdded,
    this.isMastered = false,
    this.isSavedPhrase = false,
    this.reviewedCount = 0,
  });

  ReviewItem copyWith({
    bool? isMastered,
    bool? isSavedPhrase,
    int? reviewedCount,
  }) {
    return ReviewItem(
      id: id,
      languageCode: languageCode,
      languageName: languageName,
      missionTitle: missionTitle,
      correction: correction,
      dateAdded: dateAdded,
      isMastered: isMastered ?? this.isMastered,
      isSavedPhrase: isSavedPhrase ?? this.isSavedPhrase,
      reviewedCount: reviewedCount ?? this.reviewedCount,
    );
  }
}

class FluencySnapshot {
  final DateTime date;
  final int fluencyScore;
  final int confidenceScore;
  final int pronunciationScore;
  final int grammarScore;
  final int conversationReadiness;
  final int speakMinutes;
  final int correctionsSaved;
  final int completedMissions;

  const FluencySnapshot({
    required this.date,
    required this.fluencyScore,
    required this.confidenceScore,
    required this.pronunciationScore,
    required this.grammarScore,
    required this.conversationReadiness,
    required this.speakMinutes,
    required this.correctionsSaved,
    required this.completedMissions,
  });

  int get score => fluencyScore;
}

class ProgressState {
  final int speakingMinutes;
  final int completedMissions;
  final int correctionsSaved;
  final int repeatedCorrections;
  final int masteredReviewItems;
  final int scenarioCount;
  final int streakDays;
  final int fluencyScore;
  final int confidenceScore;
  final int pronunciationScore;
  final int grammarScore;
  final int conversationReadiness;
  final Map<String, int> skillScores;
  final List<FluencySnapshot> snapshots;

  const ProgressState({
    required this.speakingMinutes,
    required this.completedMissions,
    required this.correctionsSaved,
    required this.repeatedCorrections,
    required this.masteredReviewItems,
    required this.scenarioCount,
    required this.streakDays,
    required this.fluencyScore,
    required this.confidenceScore,
    required this.pronunciationScore,
    required this.grammarScore,
    required this.conversationReadiness,
    required this.skillScores,
    required this.snapshots,
  });

  ProgressState copyWith({
    int? speakingMinutes,
    int? completedMissions,
    int? correctionsSaved,
    int? repeatedCorrections,
    int? masteredReviewItems,
    int? scenarioCount,
    int? streakDays,
    int? fluencyScore,
    int? confidenceScore,
    int? pronunciationScore,
    int? grammarScore,
    int? conversationReadiness,
    Map<String, int>? skillScores,
    List<FluencySnapshot>? snapshots,
  }) {
    return ProgressState(
      speakingMinutes: speakingMinutes ?? this.speakingMinutes,
      completedMissions: completedMissions ?? this.completedMissions,
      correctionsSaved: correctionsSaved ?? this.correctionsSaved,
      repeatedCorrections: repeatedCorrections ?? this.repeatedCorrections,
      masteredReviewItems: masteredReviewItems ?? this.masteredReviewItems,
      scenarioCount: scenarioCount ?? this.scenarioCount,
      streakDays: streakDays ?? this.streakDays,
      fluencyScore: fluencyScore ?? this.fluencyScore,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      pronunciationScore: pronunciationScore ?? this.pronunciationScore,
      grammarScore: grammarScore ?? this.grammarScore,
      conversationReadiness:
          conversationReadiness ?? this.conversationReadiness,
      skillScores: skillScores ?? this.skillScores,
      snapshots: snapshots ?? this.snapshots,
    );
  }
}
