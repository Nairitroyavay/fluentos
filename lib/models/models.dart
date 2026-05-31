// ignore_for_file: prefer_initializing_formals

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

DateTime _fallbackDate() {
  return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
}

DateTime _dateValue(Object? value, DateTime fallback) {
  if (value is String) {
    return DateTime.tryParse(value) ?? fallback;
  }

  return fallback;
}

DateTime? _dateOrNull(Object? value) {
  if (value is String) {
    return DateTime.tryParse(value);
  }

  return null;
}

String? _dateJson(DateTime? value) {
  return value?.toIso8601String();
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

class AuthSession {
  final String id;
  final String userId;
  final String email;
  final String provider;
  final DateTime? _createdAt;
  final DateTime? expiresAt;

  const AuthSession({
    required this.id,
    required this.userId,
    required this.email,
    this.provider = 'fake_local',
    DateTime? createdAt,
    this.expiresAt,
  }) : _createdAt = createdAt;

  DateTime get createdAt => _createdAt ?? _fallbackDate();

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      id: _stringValue(json['id'], 'session_mock'),
      userId: _stringValue(json['userId'], 'user_roy'),
      email: _stringValue(json['email'], 'roy@example.com'),
      provider: _stringValue(json['provider'], 'fake_local'),
      createdAt: _dateValue(json['createdAt'], _fallbackDate()),
      expiresAt: _dateOrNull(json['expiresAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'email': email,
      'provider': provider,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': _dateJson(expiresAt),
    };
  }

  AuthSession copyWith({
    String? id,
    String? userId,
    String? email,
    String? provider,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return AuthSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      provider: provider ?? this.provider,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}

class ConsentSettings {
  final bool voiceProcessingAccepted;
  final bool saveTranscriptsAccepted;
  final bool saveAudioAccepted;
  final bool modelImprovementOptIn;
  final bool analyticsOptIn;
  final bool marketingOptIn;
  final DateTime? acceptedAt;
  final DateTime? updatedAt;

  const ConsentSettings({
    this.voiceProcessingAccepted = false,
    this.saveTranscriptsAccepted = false,
    this.saveAudioAccepted = false,
    this.modelImprovementOptIn = false,
    this.analyticsOptIn = false,
    this.marketingOptIn = false,
    this.acceptedAt,
    this.updatedAt,
  });

  factory ConsentSettings.defaults() {
    return const ConsentSettings();
  }

  factory ConsentSettings.fromJson(Map<String, dynamic> json) {
    return ConsentSettings(
      voiceProcessingAccepted: _boolValue(
        json['voiceProcessingAccepted'],
        _boolValue(json['voiceConsent'], false),
      ),
      saveTranscriptsAccepted: _boolValue(
        json['saveTranscriptsAccepted'],
        false,
      ),
      saveAudioAccepted: _boolValue(json['saveAudioAccepted'], false),
      modelImprovementOptIn: _boolValue(
        json['modelImprovementOptIn'],
        _boolValue(json['voiceConsent'], false),
      ),
      analyticsOptIn: _boolValue(json['analyticsOptIn'], false),
      marketingOptIn: _boolValue(json['marketingOptIn'], false),
      acceptedAt: _dateOrNull(json['acceptedAt']),
      updatedAt: _dateOrNull(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voiceProcessingAccepted': voiceProcessingAccepted,
      'saveTranscriptsAccepted': saveTranscriptsAccepted,
      'saveAudioAccepted': saveAudioAccepted,
      'modelImprovementOptIn': modelImprovementOptIn,
      'analyticsOptIn': analyticsOptIn,
      'marketingOptIn': marketingOptIn,
      'acceptedAt': _dateJson(acceptedAt),
      'updatedAt': _dateJson(updatedAt),
    };
  }

  ConsentSettings copyWith({
    bool? voiceProcessingAccepted,
    bool? saveTranscriptsAccepted,
    bool? saveAudioAccepted,
    bool? modelImprovementOptIn,
    bool? analyticsOptIn,
    bool? marketingOptIn,
    DateTime? acceptedAt,
    DateTime? updatedAt,
  }) {
    return ConsentSettings(
      voiceProcessingAccepted:
          voiceProcessingAccepted ?? this.voiceProcessingAccepted,
      saveTranscriptsAccepted:
          saveTranscriptsAccepted ?? this.saveTranscriptsAccepted,
      saveAudioAccepted: saveAudioAccepted ?? this.saveAudioAccepted,
      modelImprovementOptIn:
          modelImprovementOptIn ?? this.modelImprovementOptIn,
      analyticsOptIn: analyticsOptIn ?? this.analyticsOptIn,
      marketingOptIn: marketingOptIn ?? this.marketingOptIn,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final SubscriptionState subscription;
  final LanguageProfile? activeLanguage;
  final String? activeLanguageProfileId;
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
  final ConsentSettings consentSettings;
  final DateTime? _createdAt;
  final DateTime? _updatedAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.subscription,
    required this.activeLanguage,
    this.activeLanguageProfileId,
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
    this.consentSettings = const ConsentSettings(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : _createdAt = createdAt,
       _updatedAt = updatedAt;

  bool get onboardingCompleted => hasCompletedOnboarding;
  SubscriptionState get subscriptionTier => subscription;
  DateTime get createdAt => _createdAt ?? _fallbackDate();
  DateTime get updatedAt => _updatedAt ?? createdAt;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final activeLanguage = json['activeLanguage'];
    final consentSettings = json['consentSettings'];
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
        json['subscription'] ?? json['subscriptionTier'],
        SubscriptionState.free,
      ),
      activeLanguage: activeLanguage is Map<String, dynamic>
          ? LanguageProfile.fromJson(activeLanguage)
          : null,
      activeLanguageProfileId:
          _stringValue(
            json['activeLanguageProfileId'],
            activeLanguage is Map<String, dynamic>
                ? _stringValue(activeLanguage['id'], '')
                : '',
          ).isEmpty
          ? null
          : _stringValue(
              json['activeLanguageProfileId'],
              activeLanguage is Map<String, dynamic>
                  ? _stringValue(activeLanguage['id'], '')
                  : '',
            ),
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
      consentSettings: consentSettings is Map<String, dynamic>
          ? ConsentSettings.fromJson(consentSettings)
          : ConsentSettings.defaults(),
      createdAt: _dateValue(json['createdAt'], _fallbackDate()),
      updatedAt: _dateValue(json['updatedAt'], _fallbackDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'subscription': subscription.name,
      'subscriptionTier': subscriptionTier.name,
      'activeLanguage': activeLanguage?.toJson(),
      'activeLanguageProfileId': activeLanguageProfileId ?? activeLanguage?.id,
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
      'consentSettings': consentSettings.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? name,
    String? email,
    SubscriptionState? subscription,
    LanguageProfile? activeLanguage,
    bool clearActiveLanguage = false,
    String? activeLanguageProfileId,
    bool clearActiveLanguageProfileId = false,
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
    ConsentSettings? consentSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final nextActiveLanguage = clearActiveLanguage
        ? null
        : activeLanguage ?? this.activeLanguage;

    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      subscription: subscription ?? this.subscription,
      activeLanguage: nextActiveLanguage,
      activeLanguageProfileId: clearActiveLanguageProfileId
          ? null
          : activeLanguageProfileId ??
                nextActiveLanguage?.id ??
                this.activeLanguageProfileId,
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
      consentSettings: consentSettings ?? this.consentSettings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
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
  final DateTime? _createdAt;
  final DateTime? _updatedAt;

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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : _createdAt = createdAt,
       _updatedAt = updatedAt;

  bool get isPhaseOne => supportStatus == LanguageSupportStatus.supported;
  String get id => code;
  DateTime get createdAt => _createdAt ?? _fallbackDate();
  DateTime get updatedAt => _updatedAt ?? createdAt;

  factory LanguageOption.fromJson(Map<String, dynamic> json) {
    return LanguageOption(
      code: _stringValue(json['code'], _stringValue(json['id'], 'en')),
      name: _stringValue(json['name'], 'English'),
      nativeName: _stringValue(json['nativeName'], 'English'),
      flag: _stringValue(json['flag'], 'EN'),
      supportStatus: _enumValue(
        LanguageSupportStatus.values,
        json['supportStatus'],
        LanguageSupportStatus.supported,
      ),
      canBeBase: _boolValue(json['canBeBase'], true),
      canBeTarget: _boolValue(json['canBeTarget'], true),
      scriptName: _stringValue(json['scriptName'], 'Latin script'),
      hasRomanization: _boolValue(json['hasRomanization'], false),
      hasTransliteration: _boolValue(json['hasTransliteration'], false),
      commonRegions: _stringList(json['commonRegions']),
      defaultAccentOptions: _stringList(json['defaultAccentOptions']).isEmpty
          ? const ['Global clear']
          : _stringList(json['defaultAccentOptions']),
      createdAt: _dateValue(json['createdAt'], _fallbackDate()),
      updatedAt: _dateValue(json['updatedAt'], _fallbackDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'nativeName': nativeName,
      'flag': flag,
      'supportStatus': supportStatus.name,
      'canBeBase': canBeBase,
      'canBeTarget': canBeTarget,
      'scriptName': scriptName,
      'hasRomanization': hasRomanization,
      'hasTransliteration': hasTransliteration,
      'commonRegions': commonRegions,
      'defaultAccentOptions': defaultAccentOptions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  LanguageOption copyWith({
    String? code,
    String? name,
    String? nativeName,
    String? flag,
    LanguageSupportStatus? supportStatus,
    bool? canBeBase,
    bool? canBeTarget,
    String? scriptName,
    bool? hasRomanization,
    bool? hasTransliteration,
    List<String>? commonRegions,
    List<String>? defaultAccentOptions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LanguageOption(
      code: code ?? this.code,
      name: name ?? this.name,
      nativeName: nativeName ?? this.nativeName,
      flag: flag ?? this.flag,
      supportStatus: supportStatus ?? this.supportStatus,
      canBeBase: canBeBase ?? this.canBeBase,
      canBeTarget: canBeTarget ?? this.canBeTarget,
      scriptName: scriptName ?? this.scriptName,
      hasRomanization: hasRomanization ?? this.hasRomanization,
      hasTransliteration: hasTransliteration ?? this.hasTransliteration,
      commonRegions: commonRegions ?? this.commonRegions,
      defaultAccentOptions: defaultAccentOptions ?? this.defaultAccentOptions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class LanguageProfile {
  final String id;
  final String userId;
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
  final DateTime? _createdAt;
  final DateTime? _updatedAt;

  const LanguageProfile({
    required this.id,
    this.userId = 'user_roy',
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : _createdAt = createdAt,
       _updatedAt = updatedAt;

  String get languageCode => code;
  String get targetLanguageCode => code;
  String get targetLanguageName => name;
  String get emojiFlag => flag;
  bool get active => isActive;
  DateTime get createdAt => _createdAt ?? _fallbackDate();
  DateTime get updatedAt => _updatedAt ?? createdAt;

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
      userId: _stringValue(json['userId'], 'user_roy'),
      code: _stringValue(
        json['languageCode'],
        _stringValue(
          json['targetLanguageCode'],
          _stringValue(json['code'], 'en'),
        ),
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
      createdAt: _dateValue(json['createdAt'], _fallbackDate()),
      updatedAt: _dateValue(json['updatedAt'], _fallbackDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'code': code,
      'languageCode': languageCode,
      'targetLanguageCode': targetLanguageCode,
      'targetLanguageName': targetLanguageName,
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  LanguageProfile copyWith({
    String? userId,
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LanguageProfile(
      id: id,
      userId: userId ?? this.userId,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
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

  VoiceBaseline copyWith({
    int? pronunciationScore,
    int? confidenceScore,
    String? speed,
    String? firstWeakArea,
  }) {
    return VoiceBaseline(
      pronunciationScore: pronunciationScore ?? this.pronunciationScore,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      speed: speed ?? this.speed,
      firstWeakArea: firstWeakArea ?? this.firstWeakArea,
    );
  }
}

class PlanDay {
  final String? _id;
  final int day;
  final String title;
  final String scenario;
  final DateTime? _createdAt;

  const PlanDay({
    String? id,
    required this.day,
    required this.title,
    required this.scenario,
    DateTime? createdAt,
  }) : _id = id,
       _createdAt = createdAt;

  String get id => _id ?? 'plan_day_$day';
  DateTime get createdAt => _createdAt ?? _fallbackDate();

  factory PlanDay.fromJson(Map<String, dynamic> json) {
    return PlanDay(
      id: _stringValue(json['id'], 'plan_day_${_intValue(json['day'], 1)}'),
      day: _intValue(json['day'], 1),
      title: _stringValue(json['title'], 'Introduce yourself'),
      scenario: _stringValue(json['scenario'], 'Speak clearly.'),
      createdAt: _dateValue(json['createdAt'], _fallbackDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'title': title,
      'scenario': scenario,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  PlanDay copyWith({
    String? id,
    int? day,
    String? title,
    String? scenario,
    DateTime? createdAt,
  }) {
    return PlanDay(
      id: id ?? this.id,
      day: day ?? this.day,
      title: title ?? this.title,
      scenario: scenario ?? this.scenario,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class OnboardingProfile {
  final String? _id;
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
  final DateTime? _createdAt;

  const OnboardingProfile({
    String? id,
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
    DateTime? createdAt,
  }) : _id = id,
       _createdAt = createdAt;

  String get id => _id ?? 'onboarding_current';
  DateTime get createdAt => _createdAt ?? _fallbackDate();

  factory OnboardingProfile.fromJson(Map<String, dynamic> json) {
    final voiceBaseline = json['voiceBaseline'];
    final sevenDayPlan = json['sevenDayPlan'];

    return OnboardingProfile(
      id: _stringValue(json['id'], 'onboarding_current'),
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
      createdAt: _dateValue(json['createdAt'], _fallbackDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'createdAt': createdAt.toIso8601String(),
    };
  }

  OnboardingProfile copyWith({
    String? id,
    String? userRegion,
    String? baseLanguageCode,
    String? baseLanguageName,
    String? targetLanguageCode,
    String? targetLanguageName,
    String? targetCulture,
    String? learningGoal,
    String? currentLevel,
    String? speakingConfidence,
    int? dailyMinutes,
    String? accentPreference,
    bool? onboardingCompleted,
    VoiceBaseline? voiceBaseline,
    List<PlanDay>? sevenDayPlan,
    DateTime? createdAt,
  }) {
    return OnboardingProfile(
      id: id ?? this.id,
      userRegion: userRegion ?? this.userRegion,
      baseLanguageCode: baseLanguageCode ?? this.baseLanguageCode,
      baseLanguageName: baseLanguageName ?? this.baseLanguageName,
      targetLanguageCode: targetLanguageCode ?? this.targetLanguageCode,
      targetLanguageName: targetLanguageName ?? this.targetLanguageName,
      targetCulture: targetCulture ?? this.targetCulture,
      learningGoal: learningGoal ?? this.learningGoal,
      currentLevel: currentLevel ?? this.currentLevel,
      speakingConfidence: speakingConfidence ?? this.speakingConfidence,
      dailyMinutes: dailyMinutes ?? this.dailyMinutes,
      accentPreference: accentPreference ?? this.accentPreference,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      voiceBaseline: voiceBaseline ?? this.voiceBaseline,
      sevenDayPlan: sevenDayPlan ?? this.sevenDayPlan,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DailyMission {
  final String id;
  final String userId;
  final String languageProfileId;
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
  final DateTime? scheduledDate;
  final DateTime? completedAt;
  final DateTime? _createdAt;

  const DailyMission({
    required this.id,
    this.userId = 'user_roy',
    this.languageProfileId = '',
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
    this.scheduledDate,
    this.completedAt,
    DateTime? createdAt,
  }) : _createdAt = createdAt;

  DateTime get createdAt => _createdAt ?? _fallbackDate();

  factory DailyMission.fromJson(Map<String, dynamic> json) {
    return DailyMission(
      id: _stringValue(json['id'], 'mission_intro'),
      userId: _stringValue(json['userId'], 'user_roy'),
      languageProfileId: _stringValue(json['languageProfileId'], ''),
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
      scheduledDate: _dateOrNull(json['scheduledDate']),
      completedAt: _dateOrNull(json['completedAt']),
      createdAt: _dateValue(json['createdAt'], _fallbackDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'languageProfileId': languageProfileId,
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
      'scheduledDate': _dateJson(scheduledDate),
      'completedAt': _dateJson(completedAt),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  DailyMission copyWith({
    String? userId,
    String? languageProfileId,
    bool? isCompleted,
    DateTime? scheduledDate,
    DateTime? completedAt,
    DateTime? createdAt,
  }) {
    return DailyMission(
      id: id,
      userId: userId ?? this.userId,
      languageProfileId: languageProfileId ?? this.languageProfileId,
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
      scheduledDate: scheduledDate ?? this.scheduledDate,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

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

class ReviewItem {
  final String id;
  final String userId;
  final String languageProfileId;
  final String missionId;
  final String sessionId;
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
  final DateTime? nextReviewAt;
  final DateTime? _createdAt;
  final DateTime? _updatedAt;

  const ReviewItem({
    required this.id,
    this.userId = 'user_roy',
    this.languageProfileId = '',
    this.missionId = '',
    this.sessionId = '',
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
    this.nextReviewAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : _createdAt = createdAt,
       _updatedAt = updatedAt;

  DateTime get createdAt => _createdAt ?? dateAdded;
  DateTime get updatedAt => _updatedAt ?? createdAt;

  factory ReviewItem.fromJson(Map<String, dynamic> json) {
    final correction = json['correction'];

    return ReviewItem(
      id: _stringValue(json['id'], 'review_mock'),
      userId: _stringValue(json['userId'], 'user_roy'),
      languageProfileId: _stringValue(json['languageProfileId'], ''),
      missionId: _stringValue(json['missionId'], ''),
      sessionId: _stringValue(json['sessionId'], ''),
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
      nextReviewAt: _dateOrNull(json['nextReviewAt']),
      createdAt: _dateValue(
        json['createdAt'],
        _dateValue(json['dateAdded'], _fallbackDate()),
      ),
      updatedAt: _dateValue(json['updatedAt'], _fallbackDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'languageProfileId': languageProfileId,
      'missionId': missionId,
      'sessionId': sessionId,
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
      'nextReviewAt': _dateJson(nextReviewAt),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ReviewItem copyWith({
    String? userId,
    String? languageProfileId,
    String? missionId,
    String? sessionId,
    bool? isMastered,
    bool? isSavedPhrase,
    int? reviewedCount,
    DateTime? nextReviewAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewItem(
      id: id,
      userId: userId ?? this.userId,
      languageProfileId: languageProfileId ?? this.languageProfileId,
      missionId: missionId ?? this.missionId,
      sessionId: sessionId ?? this.sessionId,
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
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class FluencySnapshot {
  final String? _id;
  final String userId;
  final String languageProfileId;
  final DateTime date;
  final int fluencyScore;
  final int confidenceScore;
  final int pronunciationScore;
  final int grammarScore;
  final int conversationReadiness;
  final int speakMinutes;
  final int correctionsSaved;
  final int completedMissions;
  final DateTime? _createdAt;

  const FluencySnapshot({
    String? id,
    this.userId = 'user_roy',
    this.languageProfileId = '',
    required this.date,
    required this.fluencyScore,
    required this.confidenceScore,
    required this.pronunciationScore,
    required this.grammarScore,
    required this.conversationReadiness,
    required this.speakMinutes,
    required this.correctionsSaved,
    required this.completedMissions,
    DateTime? createdAt,
  }) : _id = id,
       _createdAt = createdAt;

  String get id => _id ?? 'snapshot_${date.millisecondsSinceEpoch}';
  DateTime get createdAt => _createdAt ?? date;

  factory FluencySnapshot.fromJson(Map<String, dynamic> json) {
    return FluencySnapshot(
      id: _stringValue(json['id'], ''),
      userId: _stringValue(json['userId'], 'user_roy'),
      languageProfileId: _stringValue(json['languageProfileId'], ''),
      date: _dateValue(json['date'], DateTime.now()),
      fluencyScore: _intValue(json['fluencyScore'], 0),
      confidenceScore: _intValue(json['confidenceScore'], 0),
      pronunciationScore: _intValue(json['pronunciationScore'], 0),
      grammarScore: _intValue(json['grammarScore'], 0),
      conversationReadiness: _intValue(json['conversationReadiness'], 0),
      speakMinutes: _intValue(json['speakMinutes'], 0),
      correctionsSaved: _intValue(json['correctionsSaved'], 0),
      completedMissions: _intValue(json['completedMissions'], 0),
      createdAt: _dateValue(json['createdAt'], _fallbackDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'languageProfileId': languageProfileId,
      'date': date.toIso8601String(),
      'fluencyScore': fluencyScore,
      'confidenceScore': confidenceScore,
      'pronunciationScore': pronunciationScore,
      'grammarScore': grammarScore,
      'conversationReadiness': conversationReadiness,
      'speakMinutes': speakMinutes,
      'correctionsSaved': correctionsSaved,
      'completedMissions': completedMissions,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  int get score => fluencyScore;

  FluencySnapshot copyWith({
    String? id,
    String? userId,
    String? languageProfileId,
    DateTime? date,
    int? fluencyScore,
    int? confidenceScore,
    int? pronunciationScore,
    int? grammarScore,
    int? conversationReadiness,
    int? speakMinutes,
    int? correctionsSaved,
    int? completedMissions,
    DateTime? createdAt,
  }) {
    return FluencySnapshot(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      languageProfileId: languageProfileId ?? this.languageProfileId,
      date: date ?? this.date,
      fluencyScore: fluencyScore ?? this.fluencyScore,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      pronunciationScore: pronunciationScore ?? this.pronunciationScore,
      grammarScore: grammarScore ?? this.grammarScore,
      conversationReadiness:
          conversationReadiness ?? this.conversationReadiness,
      speakMinutes: speakMinutes ?? this.speakMinutes,
      correctionsSaved: correctionsSaved ?? this.correctionsSaved,
      completedMissions: completedMissions ?? this.completedMissions,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ProgressState {
  final String userId;
  final String languageProfileId;
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
  final DateTime? updatedAt;

  const ProgressState({
    this.userId = 'user_roy',
    this.languageProfileId = '',
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
    this.updatedAt,
  });

  factory ProgressState.fromJson(Map<String, dynamic> json) {
    final snapshots = json['snapshots'];

    return ProgressState(
      userId: _stringValue(json['userId'], 'user_roy'),
      languageProfileId: _stringValue(json['languageProfileId'], ''),
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
      updatedAt: _dateOrNull(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'languageProfileId': languageProfileId,
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
      'updatedAt': _dateJson(updatedAt),
    };
  }

  ProgressState copyWith({
    String? userId,
    String? languageProfileId,
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
    DateTime? updatedAt,
  }) {
    return ProgressState(
      userId: userId ?? this.userId,
      languageProfileId: languageProfileId ?? this.languageProfileId,
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
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class UsageQuota {
  final String id;
  final String userId;
  final int dailyAiSecondsLimit;
  final int monthlyAiSecondsLimit;
  final int usedAiSecondsToday;
  final int usedAiSecondsThisMonth;
  final int maxSessionDurationSeconds;
  final int maxCorrectionRequestsPerDay;
  final int correctionRequestsToday;
  final DateTime? quotaDate;
  final DateTime? _createdAt;
  final DateTime? _updatedAt;

  const UsageQuota({
    required this.id,
    required this.userId,
    required this.dailyAiSecondsLimit,
    required this.monthlyAiSecondsLimit,
    this.usedAiSecondsToday = 0,
    this.usedAiSecondsThisMonth = 0,
    this.maxSessionDurationSeconds = 90,
    this.maxCorrectionRequestsPerDay = 20,
    this.correctionRequestsToday = 0,
    this.quotaDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : _createdAt = createdAt,
       _updatedAt = updatedAt;

  DateTime get createdAt => _createdAt ?? _fallbackDate();
  DateTime get updatedAt => _updatedAt ?? createdAt;

  factory UsageQuota.free(String userId) {
    return UsageQuota(
      id: 'quota_$userId',
      userId: userId,
      dailyAiSecondsLimit: 300,
      monthlyAiSecondsLimit: 3600,
      quotaDate: DateTime.now(),
    );
  }

  factory UsageQuota.fromJson(Map<String, dynamic> json) {
    return UsageQuota(
      id: _stringValue(json['id'], 'quota_user_roy'),
      userId: _stringValue(json['userId'], 'user_roy'),
      dailyAiSecondsLimit: _intValue(json['dailyAiSecondsLimit'], 300),
      monthlyAiSecondsLimit: _intValue(json['monthlyAiSecondsLimit'], 3600),
      usedAiSecondsToday: _intValue(json['usedAiSecondsToday'], 0),
      usedAiSecondsThisMonth: _intValue(json['usedAiSecondsThisMonth'], 0),
      maxSessionDurationSeconds: _intValue(
        json['maxSessionDurationSeconds'],
        90,
      ),
      maxCorrectionRequestsPerDay: _intValue(
        json['maxCorrectionRequestsPerDay'],
        20,
      ),
      correctionRequestsToday: _intValue(json['correctionRequestsToday'], 0),
      quotaDate: _dateOrNull(json['quotaDate']),
      createdAt: _dateValue(json['createdAt'], _fallbackDate()),
      updatedAt: _dateValue(json['updatedAt'], _fallbackDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'dailyAiSecondsLimit': dailyAiSecondsLimit,
      'monthlyAiSecondsLimit': monthlyAiSecondsLimit,
      'usedAiSecondsToday': usedAiSecondsToday,
      'usedAiSecondsThisMonth': usedAiSecondsThisMonth,
      'maxSessionDurationSeconds': maxSessionDurationSeconds,
      'maxCorrectionRequestsPerDay': maxCorrectionRequestsPerDay,
      'correctionRequestsToday': correctionRequestsToday,
      'quotaDate': _dateJson(quotaDate),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UsageQuota copyWith({
    String? id,
    String? userId,
    int? dailyAiSecondsLimit,
    int? monthlyAiSecondsLimit,
    int? usedAiSecondsToday,
    int? usedAiSecondsThisMonth,
    int? maxSessionDurationSeconds,
    int? maxCorrectionRequestsPerDay,
    int? correctionRequestsToday,
    DateTime? quotaDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UsageQuota(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dailyAiSecondsLimit: dailyAiSecondsLimit ?? this.dailyAiSecondsLimit,
      monthlyAiSecondsLimit:
          monthlyAiSecondsLimit ?? this.monthlyAiSecondsLimit,
      usedAiSecondsToday: usedAiSecondsToday ?? this.usedAiSecondsToday,
      usedAiSecondsThisMonth:
          usedAiSecondsThisMonth ?? this.usedAiSecondsThisMonth,
      maxSessionDurationSeconds:
          maxSessionDurationSeconds ?? this.maxSessionDurationSeconds,
      maxCorrectionRequestsPerDay:
          maxCorrectionRequestsPerDay ?? this.maxCorrectionRequestsPerDay,
      correctionRequestsToday:
          correctionRequestsToday ?? this.correctionRequestsToday,
      quotaDate: quotaDate ?? this.quotaDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class SubscriptionEntitlement {
  final String userId;
  final SubscriptionState tier;
  final int activeLanguageLimit;
  final int dailyAiSecondsLimit;
  final int monthlyAiSecondsLimit;
  final int usedAiSecondsToday;
  final int usedAiSecondsThisMonth;
  final bool canUseAdvancedCorrections;
  final bool canUseFearBreaker;
  final bool canUseWeeklyReports;
  final DateTime? expiresAt;
  final DateTime? _createdAt;
  final DateTime? _updatedAt;

  const SubscriptionEntitlement({
    required this.userId,
    required this.tier,
    required this.activeLanguageLimit,
    required this.dailyAiSecondsLimit,
    required this.monthlyAiSecondsLimit,
    this.usedAiSecondsToday = 0,
    this.usedAiSecondsThisMonth = 0,
    this.canUseAdvancedCorrections = false,
    this.canUseFearBreaker = false,
    this.canUseWeeklyReports = false,
    this.expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : _createdAt = createdAt,
       _updatedAt = updatedAt;

  String get id => 'entitlement_$userId';
  DateTime get createdAt => _createdAt ?? _fallbackDate();
  DateTime get updatedAt => _updatedAt ?? createdAt;

  factory SubscriptionEntitlement.free(String userId) {
    return SubscriptionEntitlement(
      userId: userId,
      tier: SubscriptionState.free,
      activeLanguageLimit: 1,
      dailyAiSecondsLimit: 300,
      monthlyAiSecondsLimit: 3600,
    );
  }

  factory SubscriptionEntitlement.fromJson(Map<String, dynamic> json) {
    return SubscriptionEntitlement(
      userId: _stringValue(json['userId'], 'user_roy'),
      tier: _enumValue(
        SubscriptionState.values,
        json['tier'],
        SubscriptionState.free,
      ),
      activeLanguageLimit: _intValue(json['activeLanguageLimit'], 1),
      dailyAiSecondsLimit: _intValue(json['dailyAiSecondsLimit'], 300),
      monthlyAiSecondsLimit: _intValue(json['monthlyAiSecondsLimit'], 3600),
      usedAiSecondsToday: _intValue(json['usedAiSecondsToday'], 0),
      usedAiSecondsThisMonth: _intValue(json['usedAiSecondsThisMonth'], 0),
      canUseAdvancedCorrections: _boolValue(
        json['canUseAdvancedCorrections'],
        false,
      ),
      canUseFearBreaker: _boolValue(json['canUseFearBreaker'], false),
      canUseWeeklyReports: _boolValue(json['canUseWeeklyReports'], false),
      expiresAt: _dateOrNull(json['expiresAt']),
      createdAt: _dateValue(json['createdAt'], _fallbackDate()),
      updatedAt: _dateValue(json['updatedAt'], _fallbackDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'tier': tier.name,
      'activeLanguageLimit': activeLanguageLimit,
      'dailyAiSecondsLimit': dailyAiSecondsLimit,
      'monthlyAiSecondsLimit': monthlyAiSecondsLimit,
      'usedAiSecondsToday': usedAiSecondsToday,
      'usedAiSecondsThisMonth': usedAiSecondsThisMonth,
      'canUseAdvancedCorrections': canUseAdvancedCorrections,
      'canUseFearBreaker': canUseFearBreaker,
      'canUseWeeklyReports': canUseWeeklyReports,
      'expiresAt': _dateJson(expiresAt),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  SubscriptionEntitlement copyWith({
    String? userId,
    SubscriptionState? tier,
    int? activeLanguageLimit,
    int? dailyAiSecondsLimit,
    int? monthlyAiSecondsLimit,
    int? usedAiSecondsToday,
    int? usedAiSecondsThisMonth,
    bool? canUseAdvancedCorrections,
    bool? canUseFearBreaker,
    bool? canUseWeeklyReports,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionEntitlement(
      userId: userId ?? this.userId,
      tier: tier ?? this.tier,
      activeLanguageLimit: activeLanguageLimit ?? this.activeLanguageLimit,
      dailyAiSecondsLimit: dailyAiSecondsLimit ?? this.dailyAiSecondsLimit,
      monthlyAiSecondsLimit:
          monthlyAiSecondsLimit ?? this.monthlyAiSecondsLimit,
      usedAiSecondsToday: usedAiSecondsToday ?? this.usedAiSecondsToday,
      usedAiSecondsThisMonth:
          usedAiSecondsThisMonth ?? this.usedAiSecondsThisMonth,
      canUseAdvancedCorrections:
          canUseAdvancedCorrections ?? this.canUseAdvancedCorrections,
      canUseFearBreaker: canUseFearBreaker ?? this.canUseFearBreaker,
      canUseWeeklyReports: canUseWeeklyReports ?? this.canUseWeeklyReports,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
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

class DemoSettings {
  final String userId;
  final bool transliteration;
  final bool strictCorrections;
  final bool notifications;
  final bool highContrast;
  final bool voiceConsent;
  final double speechSpeed;
  final String coachTone;
  final DateTime? _createdAt;
  final DateTime? _updatedAt;

  const DemoSettings({
    this.userId = 'user_roy',
    required this.transliteration,
    required this.strictCorrections,
    required this.notifications,
    required this.highContrast,
    required this.voiceConsent,
    required this.speechSpeed,
    required this.coachTone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : _createdAt = createdAt,
       _updatedAt = updatedAt;

  String get id => 'settings_$userId';
  DateTime get createdAt => _createdAt ?? _fallbackDate();
  DateTime get updatedAt => _updatedAt ?? createdAt;

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
      userId: _stringValue(json['userId'], 'user_roy'),
      transliteration: _boolValue(json['transliteration'], true),
      strictCorrections: _boolValue(json['strictCorrections'], true),
      notifications: _boolValue(json['notifications'], false),
      highContrast: _boolValue(json['highContrast'], false),
      voiceConsent: _boolValue(json['voiceConsent'], false),
      speechSpeed: _doubleValue(json['speechSpeed'], 0.72).clamp(0.45, 1),
      coachTone: _stringValue(json['coachTone'], 'Calm coach'),
      createdAt: _dateValue(json['createdAt'], _fallbackDate()),
      updatedAt: _dateValue(json['updatedAt'], _fallbackDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'transliteration': transliteration,
      'strictCorrections': strictCorrections,
      'notifications': notifications,
      'highContrast': highContrast,
      'voiceConsent': voiceConsent,
      'speechSpeed': speechSpeed,
      'coachTone': coachTone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  DemoSettings copyWith({
    String? userId,
    bool? transliteration,
    bool? strictCorrections,
    bool? notifications,
    bool? highContrast,
    bool? voiceConsent,
    double? speechSpeed,
    String? coachTone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DemoSettings(
      userId: userId ?? this.userId,
      transliteration: transliteration ?? this.transliteration,
      strictCorrections: strictCorrections ?? this.strictCorrections,
      notifications: notifications ?? this.notifications,
      highContrast: highContrast ?? this.highContrast,
      voiceConsent: voiceConsent ?? this.voiceConsent,
      speechSpeed: speechSpeed ?? this.speechSpeed,
      coachTone: coachTone ?? this.coachTone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
