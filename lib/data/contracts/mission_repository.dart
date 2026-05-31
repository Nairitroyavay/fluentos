import '../../models/models.dart';

abstract class MissionRepository {
  Future<List<DailyMission>> loadMissions(
    String userId,
    String languageProfileId,
  );
  Future<DailyMission?> loadTodayMission(
    String userId,
    String languageProfileId,
  );
  Future<List<DailyMission>> generateInitialPlan(OnboardingProfile profile);
  Future<void> saveMissions(String userId, List<DailyMission> missions);
  Future<void> markMissionCompleted(String userId, String missionId);
}
