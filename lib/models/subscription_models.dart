// ignore_for_file: prefer_initializing_formals
part of 'models.dart';

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
