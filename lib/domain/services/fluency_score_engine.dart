import '../../models/models.dart';

class FluencyScoreEngine {
  const FluencyScoreEngine();

  ProgressState applyCompletedSession({
    required ProgressState current,
    required DailyMission mission,
    Correction? correction,
  }) {
    final minutes = current.speakingMinutes + mission.estimatedMinutes;
    final completed = current.completedMissions + 1;
    final saved = correction == null
        ? current.correctionsSaved
        : current.correctionsSaved + 1;

    return current.copyWith(
      speakingMinutes: minutes,
      completedMissions: completed,
      correctionsSaved: saved,
      repeatedCorrections: current.repeatedCorrections + 1,
      scenarioCount: completed,
      streakDays: current.streakDays == 0 ? 1 : current.streakDays,
      fluencyScore: (current.fluencyScore + 14).clamp(0, 700),
      confidenceScore: (current.confidenceScore + 5).clamp(0, 100),
      pronunciationScore: (current.pronunciationScore + 3).clamp(0, 100),
      grammarScore: (current.grammarScore + 3).clamp(0, 100),
      conversationReadiness: (current.conversationReadiness + 4).clamp(0, 100),
    );
  }
}
