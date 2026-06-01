// ignore_for_file: prefer_initializing_formals
part of 'models.dart';

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
