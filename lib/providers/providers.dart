import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../repositories/fake_fluentos_repository.dart';

final fakeRepositoryProvider = Provider<FakeFluentOSRepository>((ref) {
  return const FakeFluentOSRepository();
});

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void signIn() => state = true;
}

final authProvider = NotifierProvider<AuthNotifier, bool>(AuthNotifier.new);

class UserProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    return ref.read(fakeRepositoryProvider).loadUser();
  }

  void updateName(String name) {
    state = state.copyWith(
      name: name.trim().isEmpty ? state.name : name.trim(),
    );
  }

  void updateSpeakingGoal(String goal) {
    state = state.copyWith(speakingGoal: goal);
  }

  bool selectActiveLanguage(LanguageProfile language) {
    final activeLanguage = state.activeLanguage;
    final isSecondLanguage =
        activeLanguage != null && activeLanguage.id != language.id;

    if (state.subscription == SubscriptionState.free && isSecondLanguage) {
      return false;
    }

    state = state.copyWith(
      activeLanguage: language.copyWith(isActive: true),
      hasCompletedOnboarding: true,
    );

    return true;
  }

  void completeOnboarding() {
    state = state.copyWith(hasCompletedOnboarding: true);
  }
}

final userProvider = NotifierProvider<UserProfileNotifier, UserProfile>(
  UserProfileNotifier.new,
);

final subscriptionProvider = Provider<SubscriptionState>((ref) {
  return ref.watch(userProvider).subscription;
});

final availableLanguagesProvider = Provider<List<LanguageProfile>>((ref) {
  final languages = ref.read(fakeRepositoryProvider).loadLanguages();
  final activeLanguage = ref.watch(userProvider).activeLanguage;

  return [
    for (final language in languages)
      language.copyWith(isActive: activeLanguage?.id == language.id),
  ];
});

class DailyMissionsNotifier extends Notifier<List<DailyMission>> {
  @override
  List<DailyMission> build() {
    return ref.read(fakeRepositoryProvider).loadDailyMissions();
  }

  void markCompleted(String missionId) {
    state = [
      for (final mission in state)
        mission.id == missionId ? mission.copyWith(isCompleted: true) : mission,
    ];
  }
}

final dailyMissionsProvider =
    NotifierProvider<DailyMissionsNotifier, List<DailyMission>>(
      DailyMissionsNotifier.new,
    );

final dailyMissionProvider = Provider<DailyMission>((ref) {
  final missions = ref.watch(dailyMissionsProvider);

  for (final mission in missions) {
    if (!mission.isCompleted) {
      return mission;
    }
  }

  return missions.first;
});

class SpeakSessionNotifier extends Notifier<SpeakSession> {
  @override
  SpeakSession build() {
    final mission = ref.watch(dailyMissionProvider);
    return ref.read(fakeRepositoryProvider).buildSpeakSession(mission);
  }

  void startMission(DailyMission mission) {
    state = ref.read(fakeRepositoryProvider).buildSpeakSession(mission);
  }

  void startListening() {
    state = state.copyWith(phase: SpeakSessionPhase.listening);
  }

  void finishListening() {
    final correction = ref
        .read(fakeRepositoryProvider)
        .fakeCorrectionForMission(state.missionId);
    final now = DateTime.now();
    final learnerTurn = SpeakTurn(
      id: 'learner_${state.missionId}_${state.attemptCount + 1}',
      speaker: SpeakSpeaker.learner,
      text: correction.originalText,
      createdAt: now,
      correction: correction,
    );

    state = state.copyWith(
      turns: [...state.turns, learnerTurn],
      correction: correction,
      phase: SpeakSessionPhase.corrected,
      attemptCount: state.attemptCount + 1,
      isSavedToReview: false,
    );
  }

  void sayAgain() {
    state = SpeakSession(
      id: state.id,
      missionId: state.missionId,
      title: state.title,
      scenarioPrompt: state.scenarioPrompt,
      coachPrompt: state.coachPrompt,
      turns: [if (state.turns.isNotEmpty) state.turns.first],
      correction: null,
      phase: SpeakSessionPhase.ready,
      attemptCount: state.attemptCount,
      isSavedToReview: false,
    );
  }

  void markSavedToReview() {
    state = state.copyWith(
      phase: SpeakSessionPhase.saved,
      isSavedToReview: true,
    );
  }
}

final speakSessionProvider =
    NotifierProvider<SpeakSessionNotifier, SpeakSession>(
      SpeakSessionNotifier.new,
    );

class ReviewsNotifier extends Notifier<List<ReviewItem>> {
  @override
  List<ReviewItem> build() {
    return ref.read(fakeRepositoryProvider).loadReviewItems();
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
        languageCode: language.code,
        missionTitle: session.title,
        correction: correction,
        dateAdded: DateTime.now(),
      ),
      ...state,
    ];
  }

  void toggleMastered(String reviewId) {
    state = [
      for (final item in state)
        item.id == reviewId
            ? item.copyWith(isMastered: !item.isMastered)
            : item,
    ];
  }
}

final reviewsProvider = NotifierProvider<ReviewsNotifier, List<ReviewItem>>(
  ReviewsNotifier.new,
);

final fluencySnapshotsProvider = Provider<List<FluencySnapshot>>((ref) {
  return ref.read(fakeRepositoryProvider).loadFluencySnapshots();
});

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
