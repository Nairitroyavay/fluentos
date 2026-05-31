import '../../models/models.dart';
import '../contracts/progress_repository.dart';
import '../local/local_persistence_repository.dart';

class FakeProgressRepository implements ProgressRepository {
  final LocalPersistenceRepository local;

  const FakeProgressRepository({required this.local});

  @override
  Future<ProgressState?> loadProgress(
    String userId,
    String languageProfileId,
  ) async {
    final progress = local.loadProgress();
    if (progress == null) {
      return null;
    }
    return progress.copyWith(
      userId: userId,
      languageProfileId: languageProfileId,
    );
  }

  @override
  Future<void> saveProgress(
    String userId,
    String languageProfileId,
    ProgressState progress,
  ) {
    return local.saveProgress(
      progress.copyWith(userId: userId, languageProfileId: languageProfileId),
    );
  }

  @override
  Future<void> recordCompletedSession(CompletedSessionEvent event) {
    final current = local.loadProgress();
    if (current == null) {
      return Future<void>.value();
    }
    return local.saveProgress(
      current.copyWith(
        userId: event.userId,
        languageProfileId: event.languageProfileId,
        speakingMinutes: current.speakingMinutes + event.estimatedMinutes,
        completedMissions: current.completedMissions + 1,
        correctionsSaved: event.correction == null
            ? current.correctionsSaved
            : current.correctionsSaved + 1,
      ),
    );
  }

  @override
  Future<List<FluencySnapshot>> loadSnapshots(
    String userId,
    String languageProfileId,
  ) async {
    return local.loadProgress()?.snapshots ?? const [];
  }
}
