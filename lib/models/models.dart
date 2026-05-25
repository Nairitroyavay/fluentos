class UserProfile {
  final String id;
  final String name;
  final SubscriptionState subscription;
  final LanguageProfile? activeLanguage;

  UserProfile({
    required this.id,
    required this.name,
    required this.subscription,
    this.activeLanguage,
  });
}

enum SubscriptionState { free, premium }

class LanguageProfile {
  final String id;
  final String code;
  final String name;
  final int fluencyScore;

  LanguageProfile({
    required this.id,
    required this.code,
    required this.name,
    required this.fluencyScore,
  });
}

class DailyMission {
  final String title;
  final String description;
  final bool isCompleted;

  DailyMission({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}

class SpeakSession {
  final String id;
  final String scenarioPrompt;
  final List<SpeakTurn> turns;

  SpeakSession({
    required this.id,
    required this.scenarioPrompt,
    required this.turns,
  });
}

class SpeakTurn {
  final String speaker; // 'user' or 'ai'
  final String text;
  final Correction? correction;

  SpeakTurn({
    required this.speaker,
    required this.text,
    this.correction,
  });
}

class Correction {
  final String originalText;
  final String correctedText;
  final String explanation;

  Correction({
    required this.originalText,
    required this.correctedText,
    required this.explanation,
  });
}

class ReviewItem {
  final String id;
  final Correction correction;
  final DateTime dateAdded;

  ReviewItem({
    required this.id,
    required this.correction,
    required this.dateAdded,
  });
}

class FluencySnapshot {
  final DateTime date;
  final int score;

  FluencySnapshot({
    required this.date,
    required this.score,
  });
}
