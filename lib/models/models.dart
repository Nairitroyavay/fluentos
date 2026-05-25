enum SubscriptionState { free, premium }

extension SubscriptionStateText on SubscriptionState {
  String get label {
    switch (this) {
      case SubscriptionState.free:
        return 'Free';
      case SubscriptionState.premium:
        return 'Premium';
    }
  }
}

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
      activeLanguage: activeLanguage ?? this.activeLanguage,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      speakingGoal: speakingGoal ?? this.speakingGoal,
      streakDays: streakDays ?? this.streakDays,
      totalSpeakMinutes: totalSpeakMinutes ?? this.totalSpeakMinutes,
    );
  }
}

class LanguageProfile {
  final String id;
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final String level;
  final String focus;
  final int fluencyScore;
  final bool isActive;

  const LanguageProfile({
    required this.id,
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.level,
    required this.focus,
    required this.fluencyScore,
    this.isActive = false,
  });

  LanguageProfile copyWith({
    String? level,
    String? focus,
    int? fluencyScore,
    bool? isActive,
  }) {
    return LanguageProfile(
      id: id,
      code: code,
      name: name,
      nativeName: nativeName,
      flag: flag,
      level: level ?? this.level,
      focus: focus ?? this.focus,
      fluencyScore: fluencyScore ?? this.fluencyScore,
      isActive: isActive ?? this.isActive,
    );
  }
}

class DailyMission {
  final String id;
  final String title;
  final String description;
  final String scenario;
  final String successCue;
  final List<String> targetPhrases;
  final int estimatedMinutes;
  final bool isCompleted;

  const DailyMission({
    required this.id,
    required this.title,
    required this.description,
    required this.scenario,
    required this.successCue,
    required this.targetPhrases,
    required this.estimatedMinutes,
    this.isCompleted = false,
  });

  DailyMission copyWith({bool? isCompleted}) {
    return DailyMission(
      id: id,
      title: title,
      description: description,
      scenario: scenario,
      successCue: successCue,
      targetPhrases: targetPhrases,
      estimatedMinutes: estimatedMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

enum SpeakSpeaker { learner, coach }

enum SpeakSessionPhase { ready, listening, corrected, saved }

class SpeakSession {
  final String id;
  final String missionId;
  final String title;
  final String scenarioPrompt;
  final String coachPrompt;
  final List<SpeakTurn> turns;
  final Correction? correction;
  final SpeakSessionPhase phase;
  final int attemptCount;
  final bool isSavedToReview;

  const SpeakSession({
    required this.id,
    required this.missionId,
    required this.title,
    required this.scenarioPrompt,
    required this.coachPrompt,
    required this.turns,
    required this.correction,
    required this.phase,
    required this.attemptCount,
    required this.isSavedToReview,
  });

  SpeakSession copyWith({
    List<SpeakTurn>? turns,
    Correction? correction,
    SpeakSessionPhase? phase,
    int? attemptCount,
    bool? isSavedToReview,
  }) {
    return SpeakSession(
      id: id,
      missionId: missionId,
      title: title,
      scenarioPrompt: scenarioPrompt,
      coachPrompt: coachPrompt,
      turns: turns ?? this.turns,
      correction: correction ?? this.correction,
      phase: phase ?? this.phase,
      attemptCount: attemptCount ?? this.attemptCount,
      isSavedToReview: isSavedToReview ?? this.isSavedToReview,
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
  final String explanation;
  final String focusArea;

  const Correction({
    required this.id,
    required this.originalText,
    required this.correctedText,
    required this.explanation,
    required this.focusArea,
  });
}

class ReviewItem {
  final String id;
  final String languageCode;
  final String missionTitle;
  final Correction correction;
  final DateTime dateAdded;
  final bool isMastered;

  const ReviewItem({
    required this.id,
    required this.languageCode,
    required this.missionTitle,
    required this.correction,
    required this.dateAdded,
    this.isMastered = false,
  });

  ReviewItem copyWith({bool? isMastered}) {
    return ReviewItem(
      id: id,
      languageCode: languageCode,
      missionTitle: missionTitle,
      correction: correction,
      dateAdded: dateAdded,
      isMastered: isMastered ?? this.isMastered,
    );
  }
}

class FluencySnapshot {
  final DateTime date;
  final int score;
  final int speakMinutes;
  final int correctionsSaved;

  const FluencySnapshot({
    required this.date,
    required this.score,
    required this.speakMinutes,
    required this.correctionsSaved,
  });
}
