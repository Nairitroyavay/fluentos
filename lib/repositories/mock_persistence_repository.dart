import '../models/models.dart';
import '../services/local_storage_service.dart';
import 'fake_fluentos_repository.dart';

class MockPersistenceRepository {
  static const _signedInKey = 'fluentos.auth.signedIn';
  static const _userKey = 'fluentos.user';
  static const _onboardingKey = 'fluentos.onboarding';
  static const _missionsKey = 'fluentos.dailyMissions';
  static const _reviewsKey = 'fluentos.reviewItems';
  static const _progressKey = 'fluentos.progress';
  static const _settingsKey = 'fluentos.settings';

  final LocalStorageService storage;
  final FakeFluentOSRepository defaults;

  const MockPersistenceRepository({
    required this.storage,
    required this.defaults,
  });

  bool loadSignedIn() {
    return storage.readBool(_signedInKey) ?? false;
  }

  Future<void> saveSignedIn(bool isSignedIn) {
    return storage.writeBool(_signedInKey, isSignedIn);
  }

  UserProfile loadUser() {
    final json = storage.readJsonMap(_userKey);
    return json == null ? defaults.loadUser() : UserProfile.fromJson(json);
  }

  Future<void> saveUser(UserProfile user) {
    return storage.writeJson(_userKey, user.toJson());
  }

  OnboardingProfile? loadOnboardingProfile() {
    final json = storage.readJsonMap(_onboardingKey);
    return json == null ? null : OnboardingProfile.fromJson(json);
  }

  Future<void> saveOnboardingProfile(OnboardingProfile? profile) {
    if (profile == null) {
      return storage.remove(_onboardingKey);
    }

    return storage.writeJson(_onboardingKey, profile.toJson());
  }

  List<DailyMission> loadDailyMissions() {
    return [
      for (final json in storage.readJsonMapList(_missionsKey))
        DailyMission.fromJson(json),
    ];
  }

  Future<void> saveDailyMissions(List<DailyMission> missions) {
    return storage.writeJson(_missionsKey, [
      for (final mission in missions) mission.toJson(),
    ]);
  }

  List<ReviewItem> loadReviewItems() {
    return [
      for (final json in storage.readJsonMapList(_reviewsKey))
        ReviewItem.fromJson(json),
    ];
  }

  Future<void> saveReviewItems(List<ReviewItem> reviews) {
    return storage.writeJson(_reviewsKey, [
      for (final review in reviews) review.toJson(),
    ]);
  }

  ProgressState? loadProgress() {
    final json = storage.readJsonMap(_progressKey);
    return json == null ? null : ProgressState.fromJson(json);
  }

  Future<void> saveProgress(ProgressState progress) {
    return storage.writeJson(_progressKey, progress.toJson());
  }

  DemoSettings loadSettings() {
    final json = storage.readJsonMap(_settingsKey);
    return json == null ? DemoSettings.defaults() : DemoSettings.fromJson(json);
  }

  Future<void> saveSettings(DemoSettings settings) {
    return storage.writeJson(_settingsKey, settings.toJson());
  }

  Future<void> clearAll() {
    return storage.clear();
  }
}
