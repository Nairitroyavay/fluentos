import '../../models/models.dart';
import '../contracts/settings_repository.dart';
import '../local/local_persistence_repository.dart';

class FakeSettingsRepository implements SettingsRepository {
  final LocalPersistenceRepository local;

  const FakeSettingsRepository({required this.local});

  @override
  Future<DemoSettings> loadSettings(String userId) async {
    return local.loadSettings().copyWith(userId: userId);
  }

  @override
  Future<void> saveSettings(String userId, DemoSettings settings) {
    return local.saveSettings(settings.copyWith(userId: userId));
  }
}
