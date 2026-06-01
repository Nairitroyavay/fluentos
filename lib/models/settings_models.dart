// ignore_for_file: prefer_initializing_formals
part of 'models.dart';

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
