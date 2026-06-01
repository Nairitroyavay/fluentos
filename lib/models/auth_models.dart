// ignore_for_file: prefer_initializing_formals
part of 'models.dart';

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
