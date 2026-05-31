import 'dart:io';

import 'package:fluentos_app/core/config/backend_mode.dart';
import 'package:fluentos_app/core/router.dart';
import 'package:fluentos_app/data/fake/fake_auth_repository.dart';
import 'package:fluentos_app/data/fake/fake_language_repository.dart';
import 'package:fluentos_app/data/fake/fake_mission_repository.dart';
import 'package:fluentos_app/data/fake/fake_progress_repository.dart';
import 'package:fluentos_app/data/fake/fake_review_repository.dart';
import 'package:fluentos_app/data/fake/fake_settings_repository.dart';
import 'package:fluentos_app/data/fake/fake_speak_repository.dart';
import 'package:fluentos_app/data/fake/fake_subscription_repository.dart';
import 'package:fluentos_app/data/fake/fake_user_repository.dart';
import 'package:fluentos_app/main.dart';
import 'package:fluentos_app/models/models.dart';
import 'package:fluentos_app/providers/providers.dart';
import 'package:fluentos_app/services/local_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('app starts in mockLocal mode', () async {
    final container = await createTestContainer();
    final environment = container.read(appEnvironmentProvider);

    expect(environment.backendMode, BackendMode.mockLocal);
    expect(environment.isBackendEnabled, isFalse);
    expect(environment.isAiEnabled, isFalse);
    expect(environment.isPaymentEnabled, isFalse);
    expect(environment.isSocialEnabled, isFalse);
  });

  testWidgets('splash opens auth', (tester) async {
    await pumpFluentOS(tester);

    expect(find.text('FluentOS'), findsOneWidget);
    expect(
      find.text('Global-first. Native-language-aware. Speaking-first.'),
      findsOneWidget,
    );

    await pumpSplashDelay(tester);

    expect(find.text('Start with your voice.'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('fake sign in opens onboarding', (tester) async {
    await pumpFluentOS(tester);
    await openAuth(tester);
    await tapVisibleText(tester, 'Continue');
    await pumpAuthDelay(tester);

    expect(find.text('Start my fluency journey'), findsOneWidget);
  });

  test('fake sign-in persists', () async {
    SharedPreferences.setMockInitialValues({});
    final localStorage = await LocalStorageService.create();
    final firstContainer = ProviderContainer(
      overrides: [localStorageServiceProvider.overrideWithValue(localStorage)],
    );
    addTearDown(firstContainer.dispose);

    firstContainer.read(authProvider.notifier).signIn();
    await Future<void>.delayed(const Duration(milliseconds: 10));

    final restartContainer = ProviderContainer(
      overrides: [localStorageServiceProvider.overrideWithValue(localStorage)],
    );
    addTearDown(restartContainer.dispose);

    expect(restartContainer.read(authProvider).isSignedIn, isTrue);
  });

  test('onboarding creates active language and missions', () async {
    final container = await createTestContainer();
    seedOnboardedUser(container);

    final language = container.read(languageProvider);
    final missions = container.read(dailyMissionsProvider);

    expect(language?.name, 'English');
    expect(language?.userRegion, 'India');
    expect(missions, isNotEmpty);
    expect(missions.first.region, 'India');
    expect(container.read(userProvider).hasCompletedOnboarding, isTrue);
  });

  test(
    'onboarding and selected region/base/target persist after restart',
    () async {
      SharedPreferences.setMockInitialValues({});
      final localStorage = await LocalStorageService.create();
      final firstContainer = ProviderContainer(
        overrides: [
          localStorageServiceProvider.overrideWithValue(localStorage),
        ],
      );
      addTearDown(firstContainer.dispose);

      seedOnboardedUser(firstContainer);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final restartContainer = ProviderContainer(
        overrides: [
          localStorageServiceProvider.overrideWithValue(localStorage),
        ],
      );
      addTearDown(restartContainer.dispose);

      final onboarding = restartContainer.read(onboardingProvider);
      final user = restartContainer.read(userProvider);

      expect(onboarding?.userRegion, 'India');
      expect(onboarding?.baseLanguageCode, 'hi');
      expect(onboarding?.targetLanguageCode, 'en');
      expect(user.activeLanguageProfileId, user.activeLanguage?.id);
      expect(user.hasCompletedOnboarding, isTrue);
    },
  );

  test('global language options expose support status', () async {
    final container = await createTestContainer();
    final options = container.read(languageOptionsProvider);

    expect(
      options.firstWhere((option) => option.code == 'ja').canBeBase,
      isTrue,
    );
    expect(
      options.firstWhere((option) => option.code == 'ko').supportStatus,
      LanguageSupportStatus.supported,
    );
    expect(
      options.firstWhere((option) => option.code == 'zh').supportStatus,
      LanguageSupportStatus.preview,
    );
    expect(
      options.firstWhere((option) => option.code == 'other').supportStatus,
      LanguageSupportStatus.comingSoon,
    );
  });

  test('mission generation is region-aware', () async {
    final container = await createTestContainer();
    seedOnboardedUser(container);

    final mission = container.read(dailyMissionProvider)!;

    expect(mission.region, 'India');
    expect(mission.baseLanguageCode, 'hi');
    expect(mission.targetLanguageCode, 'en');
    expect(mission.title, contains('assignment extension'));
  });

  test('speak session creates correction', () async {
    final container = await createTestContainer();
    seedOnboardedUser(container);

    final language = container.read(languageProvider)!;
    final mission = container.read(dailyMissionProvider)!;
    final speakNotifier = container.read(speakSessionProvider.notifier);

    speakNotifier.startMission(mission);
    speakNotifier.startListening();
    speakNotifier.finishListening(mission: mission, language: language);
    speakNotifier.showCorrection(mission: mission, language: language);

    final session = container.read(speakSessionProvider)!;
    expect(session.correction, isNotNull);
    expect(session.correction?.naturalText, isNotEmpty);
    expect(session.transcriptConfidence, isNotNull);
  });

  test('completing speak session creates review item', () async {
    final container = await createTestContainer();
    seedOnboardedUser(container);

    expect(container.read(reviewsProvider), isEmpty);

    completeSpeakSession(container);

    final reviews = container.read(reviewsProvider);
    expect(reviews, hasLength(1));
    expect(reviews.first.languageName, 'English');
    expect(reviews.first.baseLanguageName, 'Hindi');
    expect(reviews.first.region, 'India');
  });

  test('completing speak session updates progress', () async {
    final container = await createTestContainer();
    seedOnboardedUser(container);

    final before = container.read(progressProvider);
    completeSpeakSession(container);
    final after = container.read(progressProvider);

    expect(after.completedMissions, before.completedMissions + 1);
    expect(after.correctionsSaved, before.correctionsSaved + 1);
    expect(after.speakingMinutes, greaterThan(before.speakingMinutes));
    expect(after.streakDays, 1);
  });

  test('free user cannot add second active language', () async {
    final container = await createTestContainer();
    seedOnboardedUser(container);

    final secondProfile = testOnboardingProfile().copyWith(
      targetLanguageCode: 'ja',
      targetLanguageName: 'Japanese',
      targetCulture: 'Japan',
      learningGoal: 'Travel',
    );
    final secondLanguage = container
        .read(fakeLanguageRepositoryProvider)
        .createLanguageProfile(container.read(userProvider).id, secondProfile);

    final allowed = container
        .read(userProvider.notifier)
        .selectActiveLanguage(secondLanguage);

    expect(allowed, isFalse);
    expect(container.read(languageProvider)?.targetLanguageCode, 'en');
  });

  test('repository interfaces are bound to fake implementations', () async {
    final container = await createTestContainer();

    expect(container.read(authRepositoryProvider), isA<FakeAuthRepository>());
    expect(container.read(userRepositoryProvider), isA<FakeUserRepository>());
    expect(
      container.read(languageRepositoryProvider),
      isA<FakeLanguageRepository>(),
    );
    expect(
      container.read(missionRepositoryContractProvider),
      isA<FakeMissionRepository>(),
    );
    expect(container.read(speakRepositoryProvider), isA<FakeSpeakRepository>());
    expect(
      container.read(reviewRepositoryProvider),
      isA<FakeReviewRepository>(),
    );
    expect(
      container.read(progressRepositoryProvider),
      isA<FakeProgressRepository>(),
    );
    expect(
      container.read(subscriptionRepositoryProvider),
      isA<FakeSubscriptionRepository>(),
    );
    expect(
      container.read(settingsRepositoryProvider),
      isA<FakeSettingsRepository>(),
    );
  });

  test('no social map or dating route exists', () {
    const blocked = ['map', 'social', 'dating', 'nearby', 'chat'];

    for (final route in appRoutePaths) {
      for (final token in blocked) {
        expect(route.toLowerCase().contains(token), isFalse);
      }
    }
  });

  test('no backend or payment dependency is added', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    const blocked = [
      'firebase_core',
      'firebase_auth',
      'cloud_firestore',
      'firebase_app_check',
      'firebase_storage',
      'cloud_functions',
      'in_app_purchase',
      'revenuecat',
      'openai',
      'google_maps',
      'geolocator',
    ];

    for (final dependency in blocked) {
      expect(pubspec.toLowerCase().contains(dependency), isFalse);
    }
  });

  test('local persistence reloads and reset clears demo state', () async {
    SharedPreferences.setMockInitialValues({});
    final localStorage = await LocalStorageService.create();
    final firstContainer = ProviderContainer(
      overrides: [localStorageServiceProvider.overrideWithValue(localStorage)],
    );
    addTearDown(firstContainer.dispose);

    seedOnboardedUser(firstContainer);
    completeSpeakSession(firstContainer);
    await Future<void>.delayed(Duration.zero);

    final restartContainer = ProviderContainer(
      overrides: [localStorageServiceProvider.overrideWithValue(localStorage)],
    );
    addTearDown(restartContainer.dispose);

    expect(restartContainer.read(authProvider).isSignedIn, isTrue);
    expect(restartContainer.read(languageProvider)?.name, 'English');
    expect(restartContainer.read(reviewsProvider), hasLength(1));
    expect(restartContainer.read(progressProvider).completedMissions, 1);

    await restartContainer.read(localPersistenceRepositoryProvider).clearAll();
    final resetContainer = ProviderContainer(
      overrides: [localStorageServiceProvider.overrideWithValue(localStorage)],
    );
    addTearDown(resetContainer.dispose);

    expect(resetContainer.read(authProvider).isSignedIn, isFalse);
    expect(resetContainer.read(userProvider).hasCompletedOnboarding, isFalse);
    expect(resetContainer.read(reviewsProvider), isEmpty);
    expect(resetContainer.read(progressProvider).completedMissions, 0);
  });

  testWidgets('adding second language as free user opens premium preview', (
    tester,
  ) async {
    await pumpFluentOS(tester);
    final container = appContainer(tester);
    seedOnboardedUser(container);

    await pumpSplashDelay(tester);
    container.read(mainTabProvider.notifier).setIndex(4);
    await tester.pump(const Duration(milliseconds: 150));

    await tapVisibleText(tester, 'Add second language');
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('FluentOS Pro Preview'), findsOneWidget);
  });

  testWidgets('coming soon languages do not complete target selection', (
    tester,
  ) async {
    await pumpFluentOS(tester);
    await openAuth(tester);
    await tapVisibleText(tester, 'Continue');
    await pumpAuthDelay(tester);

    await tapVisibleText(tester, 'Start my fluency journey');
    await tester.pump(const Duration(milliseconds: 400));
    await tapVisibleText(tester, 'India');
    await tapVisibleText(tester, 'Continue');
    await tester.pump(const Duration(milliseconds: 400));
    await tapVisibleText(tester, 'Hindi');
    await tapVisibleText(tester, 'Continue');
    await tester.pump(const Duration(milliseconds: 400));
    await tapVisibleText(tester, 'Other');

    expect(
      find.text(
        'This language is coming later. Choose a supported language for this mock demo.',
      ),
      findsOneWidget,
    );

    await tapVisibleText(tester, 'Continue');

    expect(
      find.text('Choose a supported or preview target language.'),
      findsOneWidget,
    );
  });
}

Future<void> pumpFluentOS(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final localStorage = await LocalStorageService.create();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [localStorageServiceProvider.overrideWithValue(localStorage)],
      child: const FluentOSApp(),
    ),
  );
}

ProviderContainer appContainer(WidgetTester tester) {
  final context = tester.element(find.byType(FluentOSApp));
  return ProviderScope.containerOf(context, listen: false);
}

Future<void> pumpSplashDelay(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 1300));
  await tester.pump(const Duration(milliseconds: 100));
}

Future<void> openAuth(WidgetTester tester) async {
  await pumpSplashDelay(tester);
  expect(find.text('Start with your voice.'), findsOneWidget);
}

Future<void> tapVisibleText(WidgetTester tester, String text) async {
  final textFinder = find.text(text);
  if (textFinder.evaluate().isNotEmpty &&
      textFinder.hitTestable().evaluate().isEmpty) {
    await tester.ensureVisible(textFinder.first);
    await tester.pump(const Duration(milliseconds: 100));
  }

  final hitTestable = textFinder.hitTestable();
  expect(hitTestable, findsAtLeastNWidgets(1));
  await tester.tap(hitTestable.first);
  await tester.pump(const Duration(milliseconds: 350));
}

Future<void> pumpAuthDelay(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 750));
  await tester.pump(const Duration(milliseconds: 300));
}

Future<ProviderContainer> createTestContainer() async {
  SharedPreferences.setMockInitialValues({});
  final localStorage = await LocalStorageService.create();
  final container = ProviderContainer(
    overrides: [localStorageServiceProvider.overrideWithValue(localStorage)],
  );
  addTearDown(container.dispose);
  return container;
}

void seedOnboardedUser(ProviderContainer container) {
  final profile = testOnboardingProfile();
  final language = container
      .read(fakeLanguageRepositoryProvider)
      .createLanguageProfile(container.read(userProvider).id, profile);

  container.read(authProvider.notifier).signIn();
  container.read(onboardingProvider.notifier).save(profile);
  container
      .read(userProvider.notifier)
      .completeOnboarding(profile: profile, language: language);
  container
      .read(dailyMissionsProvider.notifier)
      .createFor(profile: profile, language: language);
  container
      .read(progressProvider.notifier)
      .initialize(profile: profile, language: language);
  container.read(reviewsProvider.notifier).clear();
}

OnboardingProfile testOnboardingProfile() {
  return const OnboardingProfile(
    userRegion: 'India',
    baseLanguageCode: 'hi',
    baseLanguageName: 'Hindi',
    targetLanguageCode: 'en',
    targetLanguageName: 'English',
    targetCulture: 'Global workplace and travel',
    learningGoal: 'College',
    currentLevel: 'I know some words',
    speakingConfidence: 'A little nervous',
    dailyMinutes: 10,
    accentPreference: 'Indian English',
    onboardingCompleted: true,
    voiceBaseline: VoiceBaseline(
      pronunciationScore: 54,
      confidenceScore: 42,
      speed: 'Careful and slow',
      firstWeakArea: 'sentence endings',
    ),
    sevenDayPlan: [
      PlanDay(
        day: 1,
        title: 'Introduce yourself',
        scenario: 'Start a clear first conversation in English.',
      ),
    ],
  );
}

void completeSpeakSession(ProviderContainer container) {
  final language = container.read(languageProvider)!;
  final mission = container.read(dailyMissionProvider)!;
  final speakNotifier = container.read(speakSessionProvider.notifier);

  speakNotifier.startMission(mission);
  speakNotifier.startListening();
  speakNotifier.finishListening(mission: mission, language: language);
  speakNotifier.showCorrection(mission: mission, language: language);
  speakNotifier.startRepeatAttempt();
  speakNotifier.finishRepeatAttempt();

  final session = container.read(speakSessionProvider)!;
  container
      .read(reviewsProvider.notifier)
      .saveFromSession(session: session, language: language);
  container.read(dailyMissionsProvider.notifier).markCompleted(mission.id);
  container
      .read(progressProvider.notifier)
      .recordCompletedSession(
        session: session,
        mission: mission,
        language: language,
      );
  speakNotifier.markSavedToReview();
}
