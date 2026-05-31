import '../../models/models.dart';
import '../../repositories/fake_fluentos_repository.dart';
import '../contracts/mission_repository.dart';
import '../local/local_persistence_repository.dart';

class FakeMissionRepository implements MissionRepository {
  final LocalPersistenceRepository local;
  final FakeFluentOSRepository defaults;

  const FakeMissionRepository({required this.local, required this.defaults});

  @override
  Future<List<DailyMission>> loadMissions(
    String userId,
    String languageProfileId,
  ) async {
    return local
        .loadDailyMissions()
        .where(
          (mission) =>
              mission.languageProfileId.isEmpty ||
              mission.languageProfileId == languageProfileId,
        )
        .toList();
  }

  @override
  Future<DailyMission?> loadTodayMission(
    String userId,
    String languageProfileId,
  ) async {
    final missions = await loadMissions(userId, languageProfileId);
    if (missions.isEmpty) {
      return null;
    }
    for (final mission in missions) {
      if (!mission.isCompleted) {
        return mission;
      }
    }
    return missions.first;
  }

  @override
  Future<List<DailyMission>> generateInitialPlan(
    OnboardingProfile profile,
  ) async {
    final user = local.loadUser();
    final language = defaults
        .createLanguageProfile(profile)
        .copyWith(userId: user.id);
    return defaults
        .buildMissions(profile: profile, language: language)
        .map(
          (mission) => mission.copyWith(
            userId: user.id,
            languageProfileId: language.id,
            scheduledDate: DateTime.now(),
          ),
        )
        .toList();
  }

  @override
  Future<void> saveMissions(String userId, List<DailyMission> missions) {
    return local.saveDailyMissions([
      for (final mission in missions) mission.copyWith(userId: userId),
    ]);
  }

  @override
  Future<void> markMissionCompleted(String userId, String missionId) {
    final now = DateTime.now();
    return local.saveDailyMissions([
      for (final mission in local.loadDailyMissions())
        mission.id == missionId
            ? mission.copyWith(
                userId: userId,
                isCompleted: true,
                completedAt: now,
              )
            : mission,
    ]);
  }
}
