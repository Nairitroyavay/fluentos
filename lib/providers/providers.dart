import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_environment.dart';
import '../data/contracts/auth_repository.dart';
import '../data/contracts/language_repository.dart';
import '../data/contracts/mission_repository.dart';
import '../data/contracts/progress_repository.dart';
import '../data/contracts/review_repository.dart';
import '../data/contracts/settings_repository.dart';
import '../data/contracts/speak_repository.dart';
import '../data/contracts/subscription_repository.dart';
import '../data/contracts/user_repository.dart';
import '../data/fake/fake_auth_repository.dart';
import '../data/fake/fake_language_repository.dart';
import '../data/fake/fake_mission_repository.dart';
import '../data/fake/fake_progress_repository.dart';
import '../data/fake/fake_review_repository.dart';
import '../data/fake/fake_settings_repository.dart';
import '../data/fake/fake_speak_repository.dart';
import '../data/fake/fake_subscription_repository.dart';
import '../data/fake/fake_user_repository.dart';
import '../data/local/local_persistence_repository.dart';
import '../models/models.dart';
import '../repositories/fake_fluentos_repository.dart';
import '../repositories/fake_mission_engine.dart';
import '../repositories/mock_persistence_repository.dart';
import '../services/local_storage_service.dart';

final appEnvironmentProvider = Provider<AppEnvironment>((ref) {
  return appEnvironment;
});

final fakeRepositoryProvider = Provider<FakeFluentOSRepository>((ref) {
  return const FakeFluentOSRepository();
});

final fakeMissionEngineProvider = Provider<FakeMissionEngine>((ref) {
  return const FakeMissionEngine();
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  throw StateError('LocalStorageService must be provided before app startup.');
});

final localPersistenceRepositoryProvider = Provider<LocalPersistenceRepository>(
  (ref) {
    return LocalPersistenceRepository(
      storage: ref.read(localStorageServiceProvider),
      defaultUser: ref.read(fakeRepositoryProvider).loadUser(),
    );
  },
);

final mockPersistenceRepositoryProvider = Provider<MockPersistenceRepository>((
  ref,
) {
  return MockPersistenceRepository(
    storage: ref.read(localStorageServiceProvider),
    defaults: ref.read(fakeRepositoryProvider),
  );
});

final fakeAuthRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  return FakeAuthRepository(
    local: ref.read(localPersistenceRepositoryProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ref.read(fakeAuthRepositoryProvider);
});

final fakeUserRepositoryProvider = Provider<FakeUserRepository>((ref) {
  return FakeUserRepository(
    local: ref.read(localPersistenceRepositoryProvider),
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return ref.read(fakeUserRepositoryProvider);
});

final fakeLanguageRepositoryProvider = Provider<FakeLanguageRepository>((ref) {
  return FakeLanguageRepository(
    local: ref.read(localPersistenceRepositoryProvider),
    defaults: ref.read(fakeRepositoryProvider),
  );
});

final languageRepositoryProvider = Provider<LanguageRepository>((ref) {
  return ref.read(fakeLanguageRepositoryProvider);
});

final fakeMissionRepositoryProvider = Provider<FakeMissionRepository>((ref) {
  return FakeMissionRepository(
    local: ref.read(localPersistenceRepositoryProvider),
    defaults: ref.read(fakeRepositoryProvider),
  );
});

final missionRepositoryContractProvider = Provider<MissionRepository>((ref) {
  return ref.read(fakeMissionRepositoryProvider);
});

final fakeSpeakRepositoryProvider = Provider<FakeSpeakRepository>((ref) {
  return FakeSpeakRepository(
    local: ref.read(localPersistenceRepositoryProvider),
    defaults: ref.read(fakeRepositoryProvider),
  );
});

final speakRepositoryProvider = Provider<SpeakRepository>((ref) {
  return ref.read(fakeSpeakRepositoryProvider);
});

final fakeReviewRepositoryProvider = Provider<FakeReviewRepository>((ref) {
  return FakeReviewRepository(
    local: ref.read(localPersistenceRepositoryProvider),
  );
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ref.read(fakeReviewRepositoryProvider);
});

final fakeProgressRepositoryProvider = Provider<FakeProgressRepository>((ref) {
  return FakeProgressRepository(
    local: ref.read(localPersistenceRepositoryProvider),
  );
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ref.read(fakeProgressRepositoryProvider);
});

final fakeSubscriptionRepositoryProvider = Provider<FakeSubscriptionRepository>(
  (ref) {
    return FakeSubscriptionRepository(
      local: ref.read(localPersistenceRepositoryProvider),
    );
  },
);

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return ref.read(fakeSubscriptionRepositoryProvider);
});

final fakeSettingsRepositoryProvider = Provider<FakeSettingsRepository>((ref) {
  return FakeSettingsRepository(
    local: ref.read(localPersistenceRepositoryProvider),
  );
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return ref.read(fakeSettingsRepositoryProvider);
});

class AuthState {
  final bool isSignedIn;
  final bool isLoading;

  const AuthState({required this.isSignedIn, required this.isLoading});

  AuthState copyWith({bool? isSignedIn, bool? isLoading}) {
    return AuthState(
      isSignedIn: isSignedIn ?? this.isSignedIn,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState(
      isSignedIn: ref.read(localPersistenceRepositoryProvider).loadSignedIn(),
      isLoading: false,
    );
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void signIn() {
    state = const AuthState(isSignedIn: true, isLoading: false);
    final user = ref.read(userProvider);
    unawaited(
      ref
          .read(authRepositoryProvider)
          .signInWithEmail(user.email, 'mock_password'),
    );
  }

  void signOut() {
    state = const AuthState(isSignedIn: false, isLoading: false);
    unawaited(ref.read(authRepositoryProvider).signOut());
  }

  void resetForDemo() {
    state = const AuthState(isSignedIn: false, isLoading: false);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class UserProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    return ref.read(localPersistenceRepositoryProvider).loadUser();
  }

  void updateName(String name) {
    state = state.copyWith(
      name: name.trim().isEmpty ? state.name : name.trim(),
    );
    _save();
  }

  void updateEmail(String email) {
    state = state.copyWith(
      email: email.trim().isEmpty ? state.email : email.trim(),
    );
    _save();
  }

  void completeOnboarding({
    required OnboardingProfile profile,
    required LanguageProfile language,
  }) {
    state = state.copyWith(
      activeLanguage: language,
      hasCompletedOnboarding: true,
      userRegion: profile.userRegion,
      baseLanguageCode: profile.baseLanguageCode,
      targetLanguageCode: profile.targetLanguageCode,
      targetCulture: profile.targetCulture,
      learningGoal: profile.learningGoal,
      currentLevel: profile.currentLevel,
      speakingConfidence: profile.speakingConfidence,
      dailyMinutes: profile.dailyMinutes,
      accentPreference: profile.accentPreference,
      speakingGoal: profile.learningGoal,
      streakDays: 0,
      totalSpeakMinutes: 0,
    );
    _save();
  }

  bool selectActiveLanguage(LanguageProfile language) {
    final activeLanguage = state.activeLanguage;
    final isSecondLanguage =
        activeLanguage != null && activeLanguage.id != language.id;

    if (state.subscription == SubscriptionState.free && isSecondLanguage) {
      return false;
    }

    state = state.copyWith(activeLanguage: language.copyWith(isActive: true));
    _save();
    return true;
  }

  void updateProgressTotals({
    required int totalSpeakMinutes,
    required int streakDays,
    LanguageProfile? activeLanguage,
  }) {
    state = state.copyWith(
      totalSpeakMinutes: totalSpeakMinutes,
      streakDays: streakDays,
      activeLanguage: activeLanguage,
    );
    _save();
  }

  void resetToFreshUser({bool persist = true}) {
    state = ref.read(fakeRepositoryProvider).loadUser();
    if (persist) {
      _save();
    }
  }

  void _save() {
    unawaited(ref.read(userRepositoryProvider).saveUser(state));
  }
}

final userProvider = NotifierProvider<UserProfileNotifier, UserProfile>(
  UserProfileNotifier.new,
);

class OnboardingNotifier extends Notifier<OnboardingProfile?> {
  @override
  OnboardingProfile? build() {
    return ref.read(localPersistenceRepositoryProvider).loadOnboardingProfile();
  }

  void save(OnboardingProfile profile) {
    state = profile;
    unawaited(
      ref
          .read(localPersistenceRepositoryProvider)
          .saveOnboardingProfile(profile),
    );
  }

  void clear({bool persist = true}) {
    state = null;
    if (persist) {
      unawaited(
        ref
            .read(localPersistenceRepositoryProvider)
            .saveOnboardingProfile(null),
      );
    }
  }
}

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingProfile?>(
      OnboardingNotifier.new,
    );

final subscriptionProvider = Provider<SubscriptionState>((ref) {
  return ref.watch(userProvider).subscription;
});

final languageOptionsProvider = Provider<List<LanguageOption>>((ref) {
  return ref.read(fakeRepositoryProvider).loadLanguageOptions();
});

final baseLanguageOptionsProvider = Provider<List<LanguageOption>>((ref) {
  return ref
      .watch(languageOptionsProvider)
      .where((option) => option.canBeBase)
      .toList();
});

final targetLanguageOptionsProvider = Provider<List<LanguageOption>>((ref) {
  return ref
      .watch(languageOptionsProvider)
      .where((option) => option.canBeTarget)
      .toList();
});

final languageProvider = Provider<LanguageProfile?>((ref) {
  return ref.watch(userProvider).activeLanguage;
});

class DailyMissionsNotifier extends Notifier<List<DailyMission>> {
  @override
  List<DailyMission> build() {
    return ref.read(localPersistenceRepositoryProvider).loadDailyMissions();
  }

  void createFor({
    required OnboardingProfile profile,
    required LanguageProfile language,
  }) {
    state = ref
        .read(fakeRepositoryProvider)
        .buildMissions(profile: profile, language: language);
    _save();
  }

  void markCompleted(String missionId) {
    state = [
      for (final mission in state)
        mission.id == missionId
            ? mission.copyWith(isCompleted: true, completedAt: DateTime.now())
            : mission,
    ];
    unawaited(
      ref
          .read(missionRepositoryContractProvider)
          .markMissionCompleted(ref.read(userProvider).id, missionId),
    );
    _save();
  }

  void clear({bool persist = true}) {
    state = const [];
    if (persist) {
      _save();
    }
  }

  void _save() {
    unawaited(
      ref
          .read(missionRepositoryContractProvider)
          .saveMissions(ref.read(userProvider).id, state),
    );
  }
}

final dailyMissionsProvider =
    NotifierProvider<DailyMissionsNotifier, List<DailyMission>>(
      DailyMissionsNotifier.new,
    );

final missionProvider = dailyMissionsProvider;

final dailyMissionProvider = Provider<DailyMission?>((ref) {
  final missions = ref.watch(dailyMissionsProvider);
  if (missions.isEmpty) {
    return null;
  }

  for (final mission in missions) {
    if (!mission.isCompleted) {
      return mission;
    }
  }

  return missions.first;
});

class SpeakSessionNotifier extends Notifier<SpeakSession?> {
  @override
  SpeakSession? build() => null;

  void startMission(
    DailyMission mission, {
    SpeakMode mode = SpeakMode.dailyMission,
  }) {
    state = ref
        .read(fakeRepositoryProvider)
        .buildSpeakSession(mission, mode: mode);
  }

  void changeMode(SpeakMode mode, DailyMission? mission) {
    final selectedMission = mission;
    if (selectedMission == null) {
      state = null;
      return;
    }

    state = ref
        .read(fakeRepositoryProvider)
        .buildSpeakSession(selectedMission, mode: mode);
  }

  void startListening() {
    final session = state;
    if (session == null) {
      return;
    }

    state = session.copyWith(phase: SpeakSessionPhase.listening);
  }

  void finishListening({
    required DailyMission mission,
    required LanguageProfile language,
  }) {
    final session = state;
    if (session == null) {
      return;
    }

    final transcript = ref
        .read(fakeRepositoryProvider)
        .fakeTranscriptForMission(
          mission: mission,
          language: language,
          mode: session.mode,
        );
    final now = DateTime.now();
    final learnerTurn = SpeakTurn(
      id: 'learner_${session.missionId}_${session.attemptCount + 1}',
      speaker: SpeakSpeaker.learner,
      text: transcript,
      createdAt: now,
    );

    state = session.copyWith(
      turns: [...session.turns, learnerTurn],
      transcriptText: transcript,
      transcriptConfidence:
          session.mode == SpeakMode.freeTalk ||
              session.mode == SpeakMode.pronunciationDrill
          ? 0.64
          : 0.91,
      clearCorrection: true,
      phase: SpeakSessionPhase.transcriptReady,
      attemptCount: session.attemptCount + 1,
      isSavedToReview: false,
      transcriptConfidenceLow:
          session.mode == SpeakMode.freeTalk ||
          session.mode == SpeakMode.pronunciationDrill,
    );
  }

  void showCorrection({
    required DailyMission mission,
    required LanguageProfile language,
  }) {
    final session = state;
    final transcript = session?.transcriptText;
    if (session == null || transcript == null) {
      return;
    }

    final correction = ref
        .read(fakeRepositoryProvider)
        .fakeCorrectionForSession(
          mission: mission,
          language: language,
          mode: session.mode,
          transcript: transcript,
        );

    state = session.copyWith(
      correction: correction,
      phase: SpeakSessionPhase.corrected,
    );
  }

  void startRepeatAttempt() {
    final session = state;
    if (session == null) {
      return;
    }

    state = session.copyWith(phase: SpeakSessionPhase.repeatAttempt);
  }

  void finishRepeatAttempt() {
    final session = state;
    if (session == null) {
      return;
    }

    state = session.copyWith(
      phase: SpeakSessionPhase.completed,
      attemptCount: session.attemptCount + 1,
    );
  }

  void markSavedToReview() {
    final session = state;
    if (session == null) {
      return;
    }

    state = session.copyWith(
      phase: SpeakSessionPhase.savedToReview,
      isSavedToReview: true,
    );
  }

  void clear() {
    state = null;
  }
}

final speakSessionProvider =
    NotifierProvider<SpeakSessionNotifier, SpeakSession?>(
      SpeakSessionNotifier.new,
    );

final speakSessionPhaseProvider = Provider<SpeakSessionPhase?>((ref) {
  return ref.watch(speakSessionProvider)?.phase;
});

class ReviewsNotifier extends Notifier<List<ReviewItem>> {
  @override
  List<ReviewItem> build() {
    return ref.read(localPersistenceRepositoryProvider).loadReviewItems();
  }

  void saveFromSession({
    required SpeakSession session,
    required LanguageProfile language,
  }) {
    final correction = session.correction;

    if (correction == null) {
      return;
    }

    final alreadySaved = state.any(
      (item) =>
          item.correction.id == correction.id &&
          item.missionTitle == session.title,
    );

    if (alreadySaved) {
      return;
    }

    state = [
      ReviewItem(
        id: 'review_${session.id}_${DateTime.now().millisecondsSinceEpoch}',
        userId: session.userId,
        languageProfileId: language.id,
        missionId: session.missionId,
        sessionId: session.id,
        region: language.userRegion,
        baseLanguageCode: language.baseLanguageCode,
        baseLanguageName: language.baseLanguageName,
        targetLanguageCode: language.code,
        targetLanguageName: language.name,
        languageCode: language.code,
        languageName: language.name,
        missionTitle: session.title,
        correction: correction,
        dateAdded: DateTime.now(),
        nextReviewAt: DateTime.now().add(const Duration(days: 1)),
      ),
      ...state,
    ];
    _save();
  }

  void toggleMastered(String reviewId) {
    state = [
      for (final item in state)
        item.id == reviewId
            ? item.copyWith(isMastered: !item.isMastered)
            : item,
    ];
    _save();

    final mastered = state.where((item) => item.isMastered).length;
    ref.read(progressProvider.notifier).setMasteredReviewItems(mastered);
  }

  void toggleSavedPhrase(String reviewId) {
    state = [
      for (final item in state)
        item.id == reviewId
            ? item.copyWith(isSavedPhrase: !item.isSavedPhrase)
            : item,
    ];
    _save();
  }

  void markReviewed(String reviewId) {
    state = [
      for (final item in state)
        item.id == reviewId
            ? item.copyWith(reviewedCount: item.reviewedCount + 1)
            : item,
    ];
    _save();
    ref.read(progressProvider.notifier).incrementRepeatedCorrections();
  }

  void clear({bool persist = true}) {
    state = const [];
    if (persist) {
      _save();
    }
  }

  void _save() {
    unawaited(
      ref.read(localPersistenceRepositoryProvider).saveReviewItems(state),
    );
  }
}

final reviewsProvider = NotifierProvider<ReviewsNotifier, List<ReviewItem>>(
  ReviewsNotifier.new,
);

final reviewProvider = reviewsProvider;

class ProgressNotifier extends Notifier<ProgressState> {
  @override
  ProgressState build() {
    return ref.read(localPersistenceRepositoryProvider).loadProgress() ??
        _emptyProgress();
  }

  void initialize({
    required OnboardingProfile profile,
    required LanguageProfile language,
  }) {
    state = ref
        .read(fakeRepositoryProvider)
        .loadInitialProgress(profile: profile, language: language)
        .copyWith(userId: language.userId, languageProfileId: language.id);
    _save();
  }

  void recordCompletedSession({
    required SpeakSession session,
    required DailyMission mission,
    required LanguageProfile language,
  }) {
    final correction = session.correction;
    final minutes = state.speakingMinutes + mission.estimatedMinutes;
    final completed = state.completedMissions + 1;
    final saved = correction == null
        ? state.correctionsSaved
        : state.correctionsSaved + 1;
    final repeated = state.repeatedCorrections + 1;
    final fluency = (state.fluencyScore + 14).clamp(0, 700);
    final confidence = (state.confidenceScore + 5).clamp(0, 100);
    final pronunciation = (state.pronunciationScore + 3).clamp(0, 100);
    final grammar = (state.grammarScore + 3).clamp(0, 100);
    final readiness = (state.conversationReadiness + 4).clamp(0, 100);
    final updatedSkills = Map<String, int>.from(state.skillScores)
      ..update(
        'Speaking',
        (value) => (value + 5).clamp(0, 100),
        ifAbsent: () => confidence,
      )
      ..update(
        'Pronunciation',
        (value) => (value + 3).clamp(0, 100),
        ifAbsent: () => pronunciation,
      )
      ..update(
        'Grammar',
        (value) => (value + 2).clamp(0, 100),
        ifAbsent: () => grammar,
      )
      ..update(
        'Response speed',
        (value) => (value + 4).clamp(0, 100),
        ifAbsent: () => readiness,
      );

    final today = DateTime.now();
    final snapshots = [...state.snapshots];
    final todaySnapshot = FluencySnapshot(
      userId: language.userId,
      languageProfileId: language.id,
      date: today,
      fluencyScore: fluency,
      confidenceScore: confidence,
      pronunciationScore: pronunciation,
      grammarScore: grammar,
      conversationReadiness: readiness,
      speakMinutes: minutes,
      correctionsSaved: saved,
      completedMissions: completed,
    );

    if (snapshots.isEmpty) {
      snapshots.add(todaySnapshot);
    } else {
      snapshots[snapshots.length - 1] = todaySnapshot;
    }

    state = state.copyWith(
      speakingMinutes: minutes,
      completedMissions: completed,
      correctionsSaved: saved,
      repeatedCorrections: repeated,
      scenarioCount: completed,
      streakDays: state.streakDays == 0 ? 1 : state.streakDays,
      fluencyScore: fluency,
      confidenceScore: confidence,
      pronunciationScore: pronunciation,
      grammarScore: grammar,
      conversationReadiness: readiness,
      skillScores: updatedSkills,
      snapshots: snapshots,
    );

    ref
        .read(userProvider.notifier)
        .updateProgressTotals(
          totalSpeakMinutes: minutes,
          streakDays: state.streakDays,
          activeLanguage: language.copyWith(
            fluencyScore: fluency,
            confidenceScore: confidence,
          ),
        );
    _save();
  }

  void setMasteredReviewItems(int count) {
    state = state.copyWith(masteredReviewItems: count);
    _save();
  }

  void incrementRepeatedCorrections() {
    state = state.copyWith(repeatedCorrections: state.repeatedCorrections + 1);
    _save();
  }

  void clear({bool persist = true}) {
    state = _emptyProgress();
    if (persist) {
      _save();
    }
  }

  void _save() {
    unawaited(
      ref
          .read(progressRepositoryProvider)
          .saveProgress(state.userId, state.languageProfileId, state),
    );
  }
}

final progressProvider = NotifierProvider<ProgressNotifier, ProgressState>(
  ProgressNotifier.new,
);

ProgressState _emptyProgress() {
  return const ProgressState(
    speakingMinutes: 0,
    completedMissions: 0,
    correctionsSaved: 0,
    repeatedCorrections: 0,
    masteredReviewItems: 0,
    scenarioCount: 0,
    streakDays: 0,
    fluencyScore: 0,
    confidenceScore: 0,
    pronunciationScore: 0,
    grammarScore: 0,
    conversationReadiness: 0,
    skillScores: {
      'Speaking': 0,
      'Listening': 0,
      'Pronunciation': 0,
      'Grammar': 0,
      'Vocabulary': 0,
      'Response speed': 0,
    },
    snapshots: [],
  );
}

final fluencySnapshotsProvider = Provider<List<FluencySnapshot>>((ref) {
  return ref.watch(progressProvider).snapshots;
});

class DemoSettingsNotifier extends Notifier<DemoSettings> {
  @override
  DemoSettings build() {
    return ref.read(localPersistenceRepositoryProvider).loadSettings();
  }

  void setTransliteration(bool value) {
    state = state.copyWith(transliteration: value);
    _save();
  }

  void setStrictCorrections(bool value) {
    state = state.copyWith(strictCorrections: value);
    _save();
  }

  void setNotifications(bool value) {
    state = state.copyWith(notifications: value);
    _save();
  }

  void setHighContrast(bool value) {
    state = state.copyWith(highContrast: value);
    _save();
  }

  void setVoiceConsent(bool value) {
    state = state.copyWith(voiceConsent: value);
    _save();
  }

  void setSpeechSpeed(double value) {
    state = state.copyWith(speechSpeed: value.clamp(0.45, 1));
    _save();
  }

  void setCoachTone(String value) {
    state = state.copyWith(coachTone: value);
    _save();
  }

  void resetForDemo() {
    state = DemoSettings.defaults();
  }

  void _save() {
    unawaited(
      ref.read(settingsRepositoryProvider).saveSettings(state.userId, state),
    );
  }
}

final demoSettingsProvider =
    NotifierProvider<DemoSettingsNotifier, DemoSettings>(
      DemoSettingsNotifier.new,
    );

class MainTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

final mainTabProvider = NotifierProvider<MainTabNotifier, int>(
  MainTabNotifier.new,
);
