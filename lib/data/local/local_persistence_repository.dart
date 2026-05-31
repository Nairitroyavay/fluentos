import '../../models/models.dart';
import 'local_storage_service.dart';

class LocalPersistenceRepository {
  static const signedInKey = 'fluentos.auth.signedIn';
  static const userKey = 'fluentos.user';
  static const onboardingKey = 'fluentos.onboarding';
  static const missionsKey = 'fluentos.dailyMissions';
  static const speakSessionsKey = 'fluentos.speakSessions';
  static const reviewsKey = 'fluentos.reviewItems';
  static const progressKey = 'fluentos.progress';
  static const settingsKey = 'fluentos.settings';
  static const quotaKey = 'fluentos.quota';
  static const entitlementKey = 'fluentos.entitlement';

  final LocalStorageService storage;
  final UserProfile defaultUser;

  const LocalPersistenceRepository({
    required this.storage,
    required this.defaultUser,
  });

  bool loadSignedIn() {
    return storage.readBool(signedInKey) ?? false;
  }

  Future<void> saveSignedIn(bool isSignedIn) {
    return storage.writeBool(signedInKey, isSignedIn);
  }

  UserProfile loadUser() {
    final json = storage.readJsonMap(userKey);
    return json == null ? defaultUser : UserProfile.fromJson(json);
  }

  Future<void> saveUser(UserProfile user) {
    return storage.writeJson(userKey, user.toJson());
  }

  OnboardingProfile? loadOnboardingProfile() {
    final json = storage.readJsonMap(onboardingKey);
    return json == null ? null : OnboardingProfile.fromJson(json);
  }

  Future<void> saveOnboardingProfile(OnboardingProfile? profile) {
    if (profile == null) {
      return storage.remove(onboardingKey);
    }

    return storage.writeJson(onboardingKey, profile.toJson());
  }

  List<DailyMission> loadDailyMissions() {
    return [
      for (final json in storage.readJsonMapList(missionsKey))
        DailyMission.fromJson(json),
    ];
  }

  Future<void> saveDailyMissions(List<DailyMission> missions) {
    return storage.writeJson(missionsKey, [
      for (final mission in missions) mission.toJson(),
    ]);
  }

  List<SpeakSession> loadSpeakSessions() {
    return [
      for (final json in storage.readJsonMapList(speakSessionsKey))
        SpeakSession.fromJson(json),
    ];
  }

  Future<void> saveSpeakSessions(List<SpeakSession> sessions) {
    return storage.writeJson(speakSessionsKey, [
      for (final session in sessions) session.toJson(),
    ]);
  }

  Future<void> saveSpeakSession(SpeakSession session) {
    final sessions = [
      session,
      for (final existing in loadSpeakSessions())
        if (existing.id != session.id) existing,
    ];
    return saveSpeakSessions(sessions);
  }

  List<ReviewItem> loadReviewItems() {
    return [
      for (final json in storage.readJsonMapList(reviewsKey))
        ReviewItem.fromJson(json),
    ];
  }

  Future<void> saveReviewItems(List<ReviewItem> reviews) {
    return storage.writeJson(reviewsKey, [
      for (final review in reviews) review.toJson(),
    ]);
  }

  ProgressState? loadProgress() {
    final json = storage.readJsonMap(progressKey);
    return json == null ? null : ProgressState.fromJson(json);
  }

  Future<void> saveProgress(ProgressState progress) {
    return storage.writeJson(progressKey, progress.toJson());
  }

  DemoSettings loadSettings() {
    final json = storage.readJsonMap(settingsKey);
    return json == null ? DemoSettings.defaults() : DemoSettings.fromJson(json);
  }

  Future<void> saveSettings(DemoSettings settings) {
    return storage.writeJson(settingsKey, settings.toJson());
  }

  UsageQuota loadQuota(String userId) {
    final json = storage.readJsonMap(quotaKey);
    return json == null ? UsageQuota.free(userId) : UsageQuota.fromJson(json);
  }

  Future<void> saveQuota(UsageQuota quota) {
    return storage.writeJson(quotaKey, quota.toJson());
  }

  SubscriptionEntitlement loadEntitlement(String userId) {
    final json = storage.readJsonMap(entitlementKey);
    return json == null
        ? SubscriptionEntitlement.free(userId)
        : SubscriptionEntitlement.fromJson(json);
  }

  Future<void> saveEntitlement(SubscriptionEntitlement entitlement) {
    return storage.writeJson(entitlementKey, entitlement.toJson());
  }

  Future<void> clearAll() {
    return storage.clear();
  }
}
