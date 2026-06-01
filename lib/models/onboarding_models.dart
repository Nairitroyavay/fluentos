// ignore_for_file: prefer_initializing_formals
part of 'models.dart';

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
