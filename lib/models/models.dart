enum SubscriptionState { free, pro, proPlus }

enum LanguageSupportStatus { supported, preview, comingSoon }

T _enumValue<T extends Enum>(List<T> values, Object? value, T fallback) {
  if (value is String) {
    for (final item in values) {
      if (item.name == value) {
        return item;
      }
    }
  }

  return fallback;
}

String _stringValue(Object? value, String fallback) {
  return value is String ? value : fallback;
}

int _intValue(Object? value, int fallback) {
  return value is num ? value.round() : fallback;
}

double _doubleValue(Object? value, double fallback) {
  return value is num ? value.toDouble() : fallback;
}

bool _boolValue(Object? value, bool fallback) {
  return value is bool ? value : fallback;
}

DateTime _dateValue(Object? value, DateTime fallback) {
  if (value is String) {
    return DateTime.tryParse(value) ?? fallback;
  }

  return fallback;
}

List<String> _stringList(Object? value) {
  if (value is! List) {
    return const [];
  }

  return [
    for (final item in value)
      if (item is String) item,
  ];
}

Map<String, int> _intMap(Object? value) {
  if (value is! Map) {
    return const {};
  }

  return {
    for (final entry in value.entries)
      if (entry.key is String && entry.value is num)
        entry.key as String: (entry.value as num).round(),
  };
}

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

extension LanguageSupportStatusText on LanguageSupportStatus {
  String get label {
    switch (this) {
      case LanguageSupportStatus.supported:
        return 'Supported';
      case LanguageSupportStatus.preview:
        return 'Preview';
      case LanguageSupportStatus.comingSoon:
        return 'Coming soon';
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
  final String userRegion;
  final String baseLanguageCode;
  final String targetLanguageCode;
  final String targetCulture;
  final String learningGoal;
  final String currentLevel;
  final String speakingConfidence;
  final int dailyMinutes;
  final String accentPreference;
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
    required this.userRegion,
    required this.baseLanguageCode,
    required this.targetLanguageCode,
    required this.targetCulture,
    required this.learningGoal,
    required this.currentLevel,
    required this.speakingConfidence,
    required this.dailyMinutes,
    required this.accentPreference,
    required this.speakingGoal,
    required this.streakDays,
    required this.totalSpeakMinutes,
  });

  bool get onboardingCompleted => hasCompletedOnboarding;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final activeLanguage = json['activeLanguage'];
    final hasCompletedOnboarding = _boolValue(
      json['hasCompletedOnboarding'],
      _boolValue(json['onboardingCompleted'], false),
    );
    final learningGoal = _stringValue(
      json['learningGoal'],
      _stringValue(json['speakingGoal'], 'Speak with confidence'),
    );

    return UserProfile(
      id: _stringValue(json['id'], 'user_roy'),
      name: _stringValue(json['name'], 'Roy'),
      email: _stringValue(json['email'], 'roy@example.com'),
      subscription: _enumValue(
        SubscriptionState.values,
        json['subscription'],
        SubscriptionState.free,
      ),
      activeLanguage: activeLanguage is Map<String, dynamic>
          ? LanguageProfile.fromJson(activeLanguage)
          : null,
      hasCompletedOnboarding: hasCompletedOnboarding,
      userRegion: _stringValue(json['userRegion'], 'United States'),
      baseLanguageCode: _stringValue(json['baseLanguageCode'], 'en'),
      targetLanguageCode: _stringValue(json['targetLanguageCode'], 'ja'),
      targetCulture: _stringValue(json['targetCulture'], 'Global culture'),
      learningGoal: learningGoal,
      currentLevel: _stringValue(json['currentLevel'], 'I know some words'),
      speakingConfidence: _stringValue(
        json['speakingConfidence'],
        'A little nervous',
      ),
      dailyMinutes: _intValue(json['dailyMinutes'], 10),
      accentPreference: _stringValue(json['accentPreference'], 'Global clear'),
      speakingGoal: _stringValue(json['speakingGoal'], learningGoal),
      streakDays: _intValue(json['streakDays'], 0),
      totalSpeakMinutes: _intValue(json['totalSpeakMinutes'], 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'subscription': subscription.name,
      'activeLanguage': activeLanguage?.toJson(),
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'onboardingCompleted': onboardingCompleted,
      'userRegion': userRegion,
      'baseLanguageCode': baseLanguageCode,
      'targetLanguageCode': targetLanguageCode,
      'targetCulture': targetCulture,
      'learningGoal': learningGoal,
      'currentLevel': currentLevel,
      'speakingConfidence': speakingConfidence,
      'dailyMinutes': dailyMinutes,
      'accentPreference': accentPreference,
      'speakingGoal': speakingGoal,
      'streakDays': streakDays,
      'totalSpeakMinutes': totalSpeakMinutes,
    };
  }

  UserProfile copyWith({
    String? name,
    String? email,
    SubscriptionState? subscription,
    LanguageProfile? activeLanguage,
    bool clearActiveLanguage = false,
    bool? hasCompletedOnboarding,
    String? userRegion,
    String? baseLanguageCode,
    String? targetLanguageCode,
    String? targetCulture,
    String? learningGoal,
    String? currentLevel,
    String? speakingConfidence,
    int? dailyMinutes,
    String? accentPreference,
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
      userRegion: userRegion ?? this.userRegion,
      baseLanguageCode: baseLanguageCode ?? this.baseLanguageCode,
      targetLanguageCode: targetLanguageCode ?? this.targetLanguageCode,
      targetCulture: targetCulture ?? this.targetCulture,
      learningGoal: learningGoal ?? this.learningGoal,
      currentLevel: currentLevel ?? this.currentLevel,
      speakingConfidence: speakingConfidence ?? this.speakingConfidence,
      dailyMinutes: dailyMinutes ?? this.dailyMinutes,
      accentPreference: accentPreference ?? this.accentPreference,
      speakingGoal: speakingGoal ?? learningGoal ?? this.speakingGoal,
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
  final LanguageSupportStatus supportStatus;
  final bool canBeBase;
  final bool canBeTarget;
  final String scriptName;
  final bool hasRomanization;
  final bool hasTransliteration;
  final List<String> commonRegions;
  final List<String> defaultAccentOptions;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    this.supportStatus = LanguageSupportStatus.supported,
    required this.canBeBase,
    required this.canBeTarget,
    this.scriptName = 'Latin script',
    this.hasRomanization = false,
    this.hasTransliteration = false,
    this.commonRegions = const [],
    this.defaultAccentOptions = const ['Global clear'],
  });

  bool get isPhaseOne => supportStatus == LanguageSupportStatus.supported;
}

class LanguageProfile {
  final String id;
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final LanguageSupportStatus supportStatus;
  final String baseLanguageCode;
  final String baseLanguageName;
  final String userRegion;
  final String targetCulture;
  final String level;
  final String focus;
  final String goal;
  final int fluencyScore;
  final int confidenceScore;
  final int pronunciationScore;
  final List<String> weakSounds;
  final String scriptMode;
  final String scriptName;
  final bool hasRomanization;
  final bool hasTransliteration;
  final bool supportsTransliteration;
  final List<String> commonRegions;
  final List<String> defaultAccentOptions;
  final String accentPreference;
  final bool isActive;

  const LanguageProfile({
    required this.id,
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.supportStatus,
    required this.baseLanguageCode,
    required this.baseLanguageName,
    required this.userRegion,
    required this.targetCulture,
    required this.level,
    required this.focus,
    required this.goal,
    required this.fluencyScore,
    required this.confidenceScore,
    required this.pronunciationScore,
    required this.weakSounds,
    required this.scriptMode,
    required this.scriptName,
    required this.hasRomanization,
    required this.hasTransliteration,
    required this.supportsTransliteration,
    required this.commonRegions,
    required this.defaultAccentOptions,
    required this.accentPreference,
    this.isActive = false,
  });

  String get languageCode => code;
  String get emojiFlag => flag;
  bool get active => isActive;

  factory LanguageProfile.fromJson(Map<String, dynamic> json) {
    final supportStatus = _enumValue(
      LanguageSupportStatus.values,
      json['supportStatus'],
      LanguageSupportStatus.supported,
    );
    final scriptName = _stringValue(
      json['scriptName'],
      _stringValue(json['scriptMode'], 'Latin script'),
    );
    final hasTransliteration = _boolValue(
      json['hasTransliteration'],
      _boolValue(json['supportsTransliteration'], false),
    );
    final goal = _stringValue(
      json['goal'],
      _stringValue(json['focus'], 'English speaking confidence'),
    );

    return LanguageProfile(
      id: _stringValue(json['id'], 'lang_en_en'),
      code: _stringValue(
        json['languageCode'],
        _stringValue(json['code'], 'en'),
      ),
      name: _stringValue(json['name'], 'English'),
      nativeName: _stringValue(json['nativeName'], 'English'),
      flag: _stringValue(json['emojiFlag'], _stringValue(json['flag'], 'EN')),
      supportStatus: supportStatus,
      baseLanguageCode: _stringValue(json['baseLanguageCode'], 'en'),
      baseLanguageName: _stringValue(json['baseLanguageName'], 'English'),
      userRegion: _stringValue(json['userRegion'], 'United States'),
      targetCulture: _stringValue(json['targetCulture'], 'Global culture'),
      level: _stringValue(json['level'], 'Starter'),
      focus: _stringValue(json['focus'], goal),
      goal: goal,
      fluencyScore: _intValue(json['fluencyScore'], 160),
      confidenceScore: _intValue(json['confidenceScore'], 42),
      pronunciationScore: _intValue(json['pronunciationScore'], 58),
      weakSounds: _stringList(json['weakSounds']),
      scriptMode: _stringValue(json['scriptMode'], scriptName),
      scriptName: scriptName,
      hasRomanization: _boolValue(json['hasRomanization'], false),
      hasTransliteration: hasTransliteration,
      supportsTransliteration: hasTransliteration,
      commonRegions: _stringList(json['commonRegions']),
      defaultAccentOptions: _stringList(json['defaultAccentOptions']).isEmpty
          ? const ['Global clear']
          : _stringList(json['defaultAccentOptions']),
      accentPreference: _stringValue(json['accentPreference'], 'Global clear'),
      isActive: _boolValue(json['active'], _boolValue(json['isActive'], false)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'languageCode': languageCode,
      'name': name,
      'nativeName': nativeName,
      'flag': flag,
      'emojiFlag': emojiFlag,
      'supportStatus': supportStatus.name,
      'baseLanguageCode': baseLanguageCode,
      'baseLanguageName': baseLanguageName,
      'userRegion': userRegion,
      'targetCulture': targetCulture,
      'level': level,
      'focus': focus,
      'goal': goal,
      'fluencyScore': fluencyScore,
      'confidenceScore': confidenceScore,
      'pronunciationScore': pronunciationScore,
      'weakSounds': weakSounds,
      'scriptMode': scriptMode,
      'scriptName': scriptName,
      'hasRomanization': hasRomanization,
      'hasTransliteration': hasTransliteration,
      'supportsTransliteration': supportsTransliteration,
      'commonRegions': commonRegions,
      'defaultAccentOptions': defaultAccentOptions,
      'accentPreference': accentPreference,
      'isActive': isActive,
      'active': active,
    };
  }

  LanguageProfile copyWith({
    LanguageSupportStatus? supportStatus,
    String? userRegion,
    String? targetCulture,
    String? level,
    String? focus,
    String? goal,
    int? fluencyScore,
    int? confidenceScore,
    int? pronunciationScore,
    List<String>? weakSounds,
    String? scriptMode,
    String? scriptName,
    bool? hasRomanization,
    bool? hasTransliteration,
    bool? supportsTransliteration,
    List<String>? commonRegions,
    List<String>? defaultAccentOptions,
    String? accentPreference,
    bool? isActive,
  }) {
    return LanguageProfile(
      id: id,
      code: code,
      name: name,
      nativeName: nativeName,
      flag: flag,
      supportStatus: supportStatus ?? this.supportStatus,
      baseLanguageCode: baseLanguageCode,
      baseLanguageName: baseLanguageName,
      userRegion: userRegion ?? this.userRegion,
      targetCulture: targetCulture ?? this.targetCulture,
      level: level ?? this.level,
      focus: focus ?? this.focus,
      goal: goal ?? this.goal,
      fluencyScore: fluencyScore ?? this.fluencyScore,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      pronunciationScore: pronunciationScore ?? this.pronunciationScore,
      weakSounds: weakSounds ?? this.weakSounds,
      scriptMode: scriptMode ?? this.scriptMode,
      scriptName: scriptName ?? this.scriptName,
      hasRomanization: hasRomanization ?? this.hasRomanization,
      hasTransliteration: hasTransliteration ?? this.hasTransliteration,
      supportsTransliteration:
          supportsTransliteration ?? this.supportsTransliteration,
      commonRegions: commonRegions ?? this.commonRegions,
      defaultAccentOptions: defaultAccentOptions ?? this.defaultAccentOptions,
      accentPreference: accentPreference ?? this.accentPreference,
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

  factory VoiceBaseline.fromJson(Map<String, dynamic> json) {
    return VoiceBaseline(
      pronunciationScore: _intValue(json['pronunciationScore'], 58),
      confidenceScore: _intValue(json['confidenceScore'], 46),
      speed: _stringValue(json['speed'], 'Careful and slow'),
      firstWeakArea: _stringValue(json['firstWeakArea'], 'sentence endings'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pronunciationScore': pronunciationScore,
      'confidenceScore': confidenceScore,
      'speed': speed,
      'firstWeakArea': firstWeakArea,
    };
  }
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

  factory PlanDay.fromJson(Map<String, dynamic> json) {
    return PlanDay(
      day: _intValue(json['day'], 1),
      title: _stringValue(json['title'], 'Introduce yourself'),
      scenario: _stringValue(json['scenario'], 'Speak clearly.'),
    );
  }

  Map<String, dynamic> toJson() {
    return {'day': day, 'title': title, 'scenario': scenario};
  }
}

class OnboardingProfile {
  final String userRegion;
  final String baseLanguageCode;
  final String baseLanguageName;
  final String targetLanguageCode;
  final String targetLanguageName;
  final String targetCulture;
  final String learningGoal;
  final String currentLevel;
  final String speakingConfidence;
  final int dailyMinutes;
  final String accentPreference;
  final bool onboardingCompleted;
  final VoiceBaseline voiceBaseline;
  final List<PlanDay> sevenDayPlan;

  const OnboardingProfile({
    required this.userRegion,
    required this.baseLanguageCode,
    required this.baseLanguageName,
    required this.targetLanguageCode,
    required this.targetLanguageName,
    required this.targetCulture,
    required this.learningGoal,
    required this.currentLevel,
    required this.speakingConfidence,
    required this.dailyMinutes,
    required this.accentPreference,
    required this.onboardingCompleted,
    required this.voiceBaseline,
    required this.sevenDayPlan,
  });

  factory OnboardingProfile.fromJson(Map<String, dynamic> json) {
    final voiceBaseline = json['voiceBaseline'];
    final sevenDayPlan = json['sevenDayPlan'];

    return OnboardingProfile(
      userRegion: _stringValue(json['userRegion'], 'United States'),
      baseLanguageCode: _stringValue(json['baseLanguageCode'], 'en'),
      baseLanguageName: _stringValue(json['baseLanguageName'], 'English'),
      targetLanguageCode: _stringValue(json['targetLanguageCode'], 'ja'),
      targetLanguageName: _stringValue(json['targetLanguageName'], 'Japanese'),
      targetCulture: _stringValue(json['targetCulture'], 'Global culture'),
      learningGoal: _stringValue(json['learningGoal'], 'Self-improvement'),
      currentLevel: _stringValue(json['currentLevel'], 'I know some words'),
      speakingConfidence: _stringValue(
        json['speakingConfidence'],
        'A little nervous',
      ),
      dailyMinutes: _intValue(json['dailyMinutes'], 10),
      accentPreference: _stringValue(json['accentPreference'], 'Global clear'),
      onboardingCompleted: _boolValue(json['onboardingCompleted'], true),
      voiceBaseline: voiceBaseline is Map<String, dynamic>
          ? VoiceBaseline.fromJson(voiceBaseline)
          : const VoiceBaseline(
              pronunciationScore: 58,
              confidenceScore: 46,
              speed: 'Careful and slow',
              firstWeakArea: 'sentence endings',
            ),
      sevenDayPlan: sevenDayPlan is List
          ? [
              for (final item in sevenDayPlan)
                if (item is Map<String, dynamic>) PlanDay.fromJson(item),
            ]
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userRegion': userRegion,
      'baseLanguageCode': baseLanguageCode,
      'baseLanguageName': baseLanguageName,
      'targetLanguageCode': targetLanguageCode,
      'targetLanguageName': targetLanguageName,
      'targetCulture': targetCulture,
      'learningGoal': learningGoal,
      'currentLevel': currentLevel,
      'speakingConfidence': speakingConfidence,
      'dailyMinutes': dailyMinutes,
      'accentPreference': accentPreference,
      'onboardingCompleted': onboardingCompleted,
      'voiceBaseline': voiceBaseline.toJson(),
      'sevenDayPlan': [for (final day in sevenDayPlan) day.toJson()],
    };
  }
}

class DailyMission {
  final String id;
  final String region;
  final String baseLanguageCode;
  final String targetLanguageCode;
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
    this.region = 'Global',
    this.baseLanguageCode = 'en',
    this.targetLanguageCode = 'en',
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

  factory DailyMission.fromJson(Map<String, dynamic> json) {
    return DailyMission(
      id: _stringValue(json['id'], 'mission_intro'),
      region: _stringValue(json['region'], 'Global'),
      baseLanguageCode: _stringValue(json['baseLanguageCode'], 'en'),
      targetLanguageCode: _stringValue(
        json['targetLanguageCode'],
        _stringValue(json['languageCode'], 'en'),
      ),
      languageCode: _stringValue(json['languageCode'], 'en'),
      title: _stringValue(json['title'], 'Introduce yourself'),
      description: _stringValue(json['description'], 'Practice speaking.'),
      scenario: _stringValue(json['scenario'], 'Start a clear conversation.'),
      coachPrompt: _stringValue(json['coachPrompt'], 'Introduce yourself.'),
      successCue: _stringValue(json['successCue'], 'Speak clearly.'),
      targetPhrases: _stringList(json['targetPhrases']),
      estimatedMinutes: _intValue(json['estimatedMinutes'], 10),
      difficulty: _stringValue(json['difficulty'], 'Starter'),
      focusArea: _stringValue(json['focusArea'], 'Speaking confidence'),
      category: _stringValue(json['category'], 'Introduction'),
      isCompleted: _boolValue(json['isCompleted'], false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'region': region,
      'baseLanguageCode': baseLanguageCode,
      'targetLanguageCode': targetLanguageCode,
      'languageCode': languageCode,
      'title': title,
      'description': description,
      'scenario': scenario,
      'coachPrompt': coachPrompt,
      'successCue': successCue,
      'targetPhrases': targetPhrases,
      'estimatedMinutes': estimatedMinutes,
      'difficulty': difficulty,
      'focusArea': focusArea,
      'category': category,
      'isCompleted': isCompleted,
    };
  }

  DailyMission copyWith({bool? isCompleted}) {
    return DailyMission(
      id: id,
      region: region,
      baseLanguageCode: baseLanguageCode,
      targetLanguageCode: targetLanguageCode,
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

  factory SpeakSession.fromJson(Map<String, dynamic> json) {
    final turns = json['turns'];
    final correction = json['correction'];

    return SpeakSession(
      id: _stringValue(json['id'], 'session_mock'),
      missionId: _stringValue(json['missionId'], 'mission_intro'),
      mode: _enumValue(SpeakMode.values, json['mode'], SpeakMode.dailyMission),
      title: _stringValue(json['title'], 'Daily Mission'),
      scenarioPrompt: _stringValue(json['scenarioPrompt'], 'Speak clearly.'),
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
      correction: correction is Map<String, dynamic>
          ? Correction.fromJson(correction)
          : null,
      phase: _enumValue(
        SpeakSessionPhase.values,
        json['phase'],
        SpeakSessionPhase.ready,
      ),
      attemptCount: _intValue(json['attemptCount'], 0),
      isSavedToReview: _boolValue(json['isSavedToReview'], false),
      transcriptConfidenceLow: _boolValue(
        json['transcriptConfidenceLow'],
        false,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'missionId': missionId,
      'mode': mode.name,
      'title': title,
      'scenarioPrompt': scenarioPrompt,
      'coachPrompt': coachPrompt,
      'turns': [for (final turn in turns) turn.toJson()],
      'transcriptText': transcriptText,
      'correction': correction?.toJson(),
      'phase': phase.name,
      'attemptCount': attemptCount,
      'isSavedToReview': isSavedToReview,
      'transcriptConfidenceLow': transcriptConfidenceLow,
    };
  }

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
      coachNote: _stringValue(json['coachNote'], ''),
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
      'coachNote': coachNote,
    };
  }
}

class ReviewItem {
  final String id;
  final String region;
  final String baseLanguageCode;
  final String baseLanguageName;
  final String targetLanguageCode;
  final String targetLanguageName;
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
    this.region = 'Global',
    this.baseLanguageCode = 'en',
    this.baseLanguageName = 'English',
    this.targetLanguageCode = 'en',
    this.targetLanguageName = 'English',
    required this.languageCode,
    required this.languageName,
    required this.missionTitle,
    required this.correction,
    required this.dateAdded,
    this.isMastered = false,
    this.isSavedPhrase = false,
    this.reviewedCount = 0,
  });

  factory ReviewItem.fromJson(Map<String, dynamic> json) {
    final correction = json['correction'];

    return ReviewItem(
      id: _stringValue(json['id'], 'review_mock'),
      region: _stringValue(json['region'], 'Global'),
      baseLanguageCode: _stringValue(json['baseLanguageCode'], 'en'),
      baseLanguageName: _stringValue(json['baseLanguageName'], 'English'),
      targetLanguageCode: _stringValue(
        json['targetLanguageCode'],
        _stringValue(json['languageCode'], 'en'),
      ),
      targetLanguageName: _stringValue(
        json['targetLanguageName'],
        _stringValue(json['languageName'], 'English'),
      ),
      languageCode: _stringValue(json['languageCode'], 'en'),
      languageName: _stringValue(json['languageName'], 'English'),
      missionTitle: _stringValue(json['missionTitle'], 'Daily Mission'),
      correction: correction is Map<String, dynamic>
          ? Correction.fromJson(correction)
          : const Correction(
              id: 'correction_mock',
              originalText: '',
              correctedText: '',
              naturalText: '',
              explanation: '',
              focusArea: 'Speaking confidence',
              confidenceScore: 0,
              pronunciationScore: 0,
              grammarScore: 0,
              fluencyScore: 0,
              coachNote: '',
            ),
      dateAdded: _dateValue(json['dateAdded'], DateTime.now()),
      isMastered: _boolValue(json['isMastered'], false),
      isSavedPhrase: _boolValue(json['isSavedPhrase'], false),
      reviewedCount: _intValue(json['reviewedCount'], 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'region': region,
      'baseLanguageCode': baseLanguageCode,
      'baseLanguageName': baseLanguageName,
      'targetLanguageCode': targetLanguageCode,
      'targetLanguageName': targetLanguageName,
      'languageCode': languageCode,
      'languageName': languageName,
      'missionTitle': missionTitle,
      'correction': correction.toJson(),
      'dateAdded': dateAdded.toIso8601String(),
      'isMastered': isMastered,
      'isSavedPhrase': isSavedPhrase,
      'reviewedCount': reviewedCount,
    };
  }

  ReviewItem copyWith({
    bool? isMastered,
    bool? isSavedPhrase,
    int? reviewedCount,
  }) {
    return ReviewItem(
      id: id,
      region: region,
      baseLanguageCode: baseLanguageCode,
      baseLanguageName: baseLanguageName,
      targetLanguageCode: targetLanguageCode,
      targetLanguageName: targetLanguageName,
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

  factory FluencySnapshot.fromJson(Map<String, dynamic> json) {
    return FluencySnapshot(
      date: _dateValue(json['date'], DateTime.now()),
      fluencyScore: _intValue(json['fluencyScore'], 0),
      confidenceScore: _intValue(json['confidenceScore'], 0),
      pronunciationScore: _intValue(json['pronunciationScore'], 0),
      grammarScore: _intValue(json['grammarScore'], 0),
      conversationReadiness: _intValue(json['conversationReadiness'], 0),
      speakMinutes: _intValue(json['speakMinutes'], 0),
      correctionsSaved: _intValue(json['correctionsSaved'], 0),
      completedMissions: _intValue(json['completedMissions'], 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'fluencyScore': fluencyScore,
      'confidenceScore': confidenceScore,
      'pronunciationScore': pronunciationScore,
      'grammarScore': grammarScore,
      'conversationReadiness': conversationReadiness,
      'speakMinutes': speakMinutes,
      'correctionsSaved': correctionsSaved,
      'completedMissions': completedMissions,
    };
  }

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

  factory ProgressState.fromJson(Map<String, dynamic> json) {
    final snapshots = json['snapshots'];

    return ProgressState(
      speakingMinutes: _intValue(json['speakingMinutes'], 0),
      completedMissions: _intValue(json['completedMissions'], 0),
      correctionsSaved: _intValue(json['correctionsSaved'], 0),
      repeatedCorrections: _intValue(json['repeatedCorrections'], 0),
      masteredReviewItems: _intValue(json['masteredReviewItems'], 0),
      scenarioCount: _intValue(json['scenarioCount'], 0),
      streakDays: _intValue(json['streakDays'], 0),
      fluencyScore: _intValue(json['fluencyScore'], 0),
      confidenceScore: _intValue(json['confidenceScore'], 0),
      pronunciationScore: _intValue(json['pronunciationScore'], 0),
      grammarScore: _intValue(json['grammarScore'], 0),
      conversationReadiness: _intValue(json['conversationReadiness'], 0),
      skillScores: {
        'Speaking': 0,
        'Listening': 0,
        'Pronunciation': 0,
        'Grammar': 0,
        'Vocabulary': 0,
        'Response speed': 0,
        ..._intMap(json['skillScores']),
      },
      snapshots: snapshots is List
          ? [
              for (final item in snapshots)
                if (item is Map<String, dynamic>)
                  FluencySnapshot.fromJson(item),
            ]
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'speakingMinutes': speakingMinutes,
      'completedMissions': completedMissions,
      'correctionsSaved': correctionsSaved,
      'repeatedCorrections': repeatedCorrections,
      'masteredReviewItems': masteredReviewItems,
      'scenarioCount': scenarioCount,
      'streakDays': streakDays,
      'fluencyScore': fluencyScore,
      'confidenceScore': confidenceScore,
      'pronunciationScore': pronunciationScore,
      'grammarScore': grammarScore,
      'conversationReadiness': conversationReadiness,
      'skillScores': skillScores,
      'snapshots': [for (final snapshot in snapshots) snapshot.toJson()],
    };
  }

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

class DemoSettings {
  final bool transliteration;
  final bool strictCorrections;
  final bool notifications;
  final bool highContrast;
  final bool voiceConsent;
  final double speechSpeed;
  final String coachTone;

  const DemoSettings({
    required this.transliteration,
    required this.strictCorrections,
    required this.notifications,
    required this.highContrast,
    required this.voiceConsent,
    required this.speechSpeed,
    required this.coachTone,
  });

  factory DemoSettings.defaults() {
    return const DemoSettings(
      transliteration: true,
      strictCorrections: true,
      notifications: false,
      highContrast: false,
      voiceConsent: false,
      speechSpeed: 0.72,
      coachTone: 'Calm coach',
    );
  }

  factory DemoSettings.fromJson(Map<String, dynamic> json) {
    return DemoSettings(
      transliteration: _boolValue(json['transliteration'], true),
      strictCorrections: _boolValue(json['strictCorrections'], true),
      notifications: _boolValue(json['notifications'], false),
      highContrast: _boolValue(json['highContrast'], false),
      voiceConsent: _boolValue(json['voiceConsent'], false),
      speechSpeed: _doubleValue(json['speechSpeed'], 0.72).clamp(0.45, 1),
      coachTone: _stringValue(json['coachTone'], 'Calm coach'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transliteration': transliteration,
      'strictCorrections': strictCorrections,
      'notifications': notifications,
      'highContrast': highContrast,
      'voiceConsent': voiceConsent,
      'speechSpeed': speechSpeed,
      'coachTone': coachTone,
    };
  }

  DemoSettings copyWith({
    bool? transliteration,
    bool? strictCorrections,
    bool? notifications,
    bool? highContrast,
    bool? voiceConsent,
    double? speechSpeed,
    String? coachTone,
  }) {
    return DemoSettings(
      transliteration: transliteration ?? this.transliteration,
      strictCorrections: strictCorrections ?? this.strictCorrections,
      notifications: notifications ?? this.notifications,
      highContrast: highContrast ?? this.highContrast,
      voiceConsent: voiceConsent ?? this.voiceConsent,
      speechSpeed: speechSpeed ?? this.speechSpeed,
      coachTone: coachTone ?? this.coachTone,
    );
  }
}
