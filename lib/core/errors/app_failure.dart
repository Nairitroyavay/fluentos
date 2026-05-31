class AppFailure {
  final String message;
  final String code;
  final bool retryable;
  final String source;

  const AppFailure({
    required this.message,
    required this.code,
    this.retryable = false,
    this.source = 'client',
  });

  factory AppFailure.fromJson(Map<String, dynamic> json) {
    return AppFailure(
      message: json['message'] is String
          ? json['message'] as String
          : 'Something went wrong.',
      code: json['code'] is String ? json['code'] as String : 'unknown',
      retryable: json['retryable'] is bool ? json['retryable'] as bool : false,
      source: json['source'] is String ? json['source'] as String : 'client',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      'retryable': retryable,
      'source': source,
    };
  }

  AppFailure copyWith({
    String? message,
    String? code,
    bool? retryable,
    String? source,
  }) {
    return AppFailure(
      message: message ?? this.message,
      code: code ?? this.code,
      retryable: retryable ?? this.retryable,
      source: source ?? this.source,
    );
  }
}
