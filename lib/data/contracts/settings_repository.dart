import '../../models/models.dart';

abstract class SettingsRepository {
  Future<DemoSettings> loadSettings(String userId);
  Future<void> saveSettings(String userId, DemoSettings settings);
}
