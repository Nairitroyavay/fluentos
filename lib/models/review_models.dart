// ignore_for_file: prefer_initializing_formals
part of 'models.dart';

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
