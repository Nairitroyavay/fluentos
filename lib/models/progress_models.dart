// ignore_for_file: prefer_initializing_formals
part of 'models.dart';

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
