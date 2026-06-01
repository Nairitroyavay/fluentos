// ignore_for_file: prefer_initializing_formals
part of 'models.dart';

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
