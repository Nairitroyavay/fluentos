import '../../models/models.dart';

abstract class ProgressRepository {
  ProgressState createInitialProgress({
    required OnboardingProfile profile,
    required LanguageProfile language,
  });
  Future<ProgressState?> loadProgress(String userId, String languageProfileId);
  Future<void> saveProgress(
    String userId,
    String languageProfileId,
    ProgressState progress,
  );
  Future<void> recordCompletedSession(CompletedSessionEvent event);
  Future<List<FluencySnapshot>> loadSnapshots(
    String userId,
    String languageProfileId,
  );
}
