// ignore_for_file: prefer_initializing_formals
part of 'models.dart';

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
