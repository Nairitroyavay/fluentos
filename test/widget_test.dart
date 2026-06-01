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
import 'package:flutter/material.dart';
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

  test('sign-out works', () async {
    final container = await createTestContainer();

    container.read(authProvider.notifier).signIn();
    await flushProviderWork();
    container.read(authProvider.notifier).signOut();
    await flushProviderWork();

    expect(container.read(authProvider).isSignedIn, isFalse);
  });

  test('reset demo data clears local state', () async {
    SharedPreferences.setMockInitialValues({});
    final localStorage = await LocalStorageService.create();
    final container = ProviderContainer(
      overrides: [localStorageServiceProvider.overrideWithValue(localStorage)],
    );
    addTearDown(container.dispose);

    seedOnboardedUser(container);
    await completeSpeakSession(container);
    await container.read(localPersistenceRepositoryProvider).clearAll();

    final resetContainer = ProviderContainer(
      overrides: [localStorageServiceProvider.overrideWithValue(localStorage)],
    );
    addTearDown(resetContainer.dispose);

    expect(resetContainer.read(authProvider).isSignedIn, isFalse);
    expect(resetContainer.read(userProvider).hasCompletedOnboarding, isFalse);
    expect(resetContainer.read(reviewsProvider), isEmpty);
    expect(resetContainer.read(progressProvider).completedMissions, 0);
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
    await flushProviderWork();
    speakNotifier.startListening();
    speakNotifier.finishListening(mission: mission, language: language);
    await flushProviderWork();
    speakNotifier.showCorrection(mission: mission, language: language);
    await flushProviderWork();

    final session = container.read(speakSessionProvider)!;
    expect(session.correction, isNotNull);
    expect(session.correction?.naturalText, isNotEmpty);
    expect(session.transcriptConfidence, isNotNull);
  });

  test('Today mission starts Speak session', () async {
    final container = await createTestContainer();
    seedOnboardedUser(container);

    final mission = container.read(dailyMissionProvider)!;
    container.read(speakSessionProvider.notifier).startMission(mission);
    await flushProviderWork();

    final session = container.read(speakSessionProvider);
    expect(session?.missionId, mission.id);
    expect(session?.phase, SpeakSessionPhase.ready);
  });

  test('speak session creates transcript', () async {
    final container = await createTestContainer();
    seedOnboardedUser(container);

    final language = container.read(languageProvider)!;
    final mission = container.read(dailyMissionProvider)!;
    final speakNotifier = container.read(speakSessionProvider.notifier);

    speakNotifier.startMission(mission);
    await flushProviderWork();
    speakNotifier.startListening();
    speakNotifier.finishListening(mission: mission, language: language);
    await flushProviderWork();

    final session = container.read(speakSessionProvider)!;
    expect(session.transcriptText, isNotEmpty);
    expect(session.phase, SpeakSessionPhase.transcriptReady);
  });

  test('low confidence transcript shows trust message state', () async {
    final container = await createTestContainer();
    seedOnboardedUser(container);

    final language = container.read(languageProvider)!;
    final mission = container.read(dailyMissionProvider)!;
    final speakNotifier = container.read(speakSessionProvider.notifier);

    speakNotifier.startMission(mission, mode: SpeakMode.freeTalk);
    await flushProviderWork();
    speakNotifier.startListening();
    speakNotifier.finishListening(mission: mission, language: language);
    await flushProviderWork();

    final session = container.read(speakSessionProvider)!;
    expect(session.transcriptConfidenceLow, isTrue);
    expect(session.transcriptConfidence, lessThan(0.7));
  });

  test('repeat attempt works and completion works', () async {
    final container = await createTestContainer();
    seedOnboardedUser(container);

    final language = container.read(languageProvider)!;
    final mission = container.read(dailyMissionProvider)!;
    final speakNotifier = container.read(speakSessionProvider.notifier);

    speakNotifier.startMission(mission);
    await flushProviderWork();
    speakNotifier.startListening();
    speakNotifier.finishListening(mission: mission, language: language);
    await flushProviderWork();
    speakNotifier.showCorrection(mission: mission, language: language);
    await flushProviderWork();
    speakNotifier.startRepeatAttempt();

    expect(
      container.read(speakSessionProvider)?.phase,
      SpeakSessionPhase.repeatAttempt,
    );

    speakNotifier.finishRepeatAttempt();
    expect(
      container.read(speakSessionProvider)?.phase,
      SpeakSessionPhase.completed,
    );
  });

  test('completing speak session creates review item', () async {
    final container = await createTestContainer();
    seedOnboardedUser(container);

    expect(container.read(reviewsProvider), isEmpty);

    await completeSpeakSession(container);

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
    await completeSpeakSession(container);
    final after = container.read(progressProvider);

    expect(after.completedMissions, before.completedMissions + 1);
    expect(after.correctionsSaved, before.correctionsSaved + 1);
    expect(after.speakingMinutes, greaterThan(before.speakingMinutes));
    expect(after.streakDays, 1);
  });

  test('save to Review marks mission completed', () async {
    final container = await createTestContainer();
    seedOnboardedUser(container);

    final missionId = container.read(dailyMissionProvider)!.id;
    await completeSpeakSession(container);

    expect(container.read(reviewsProvider), hasLength(1));
    expect(
      container
          .read(dailyMissionsProvider)
          .firstWhere((mission) => mission.id == missionId)
          .isCompleted,
      isTrue,
    );
    expect(
      container.read(speakSessionProvider)?.phase,
      SpeakSessionPhase.savedToReview,
    );
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

  test('signed out protected route redirects to auth', () {
    expect(
      appRedirectFor(
        path: '/home',
        isSignedIn: false,
        hasCompletedOnboarding: false,
      ),
      '/auth',
    );
    expect(
      appRedirectFor(
        path: '/premium',
        isSignedIn: false,
        hasCompletedOnboarding: true,
      ),
      '/auth',
    );
  });

  test('signed in but onboarding incomplete redirects to onboarding', () {
    expect(
      appRedirectFor(
        path: '/home',
        isSignedIn: true,
        hasCompletedOnboarding: false,
      ),
      '/onboarding',
    );
  });

  test('onboarded user routes to home from auth and onboarding', () {
    expect(
      appRedirectFor(
        path: '/auth',
        isSignedIn: true,
        hasCompletedOnboarding: true,
      ),
      '/home',
    );
    expect(
      appRedirectFor(
        path: '/onboarding',
        isSignedIn: true,
        hasCompletedOnboarding: true,
      ),
      '/home',
    );
    expect(
      appRedirectFor(
        path: '/onboarding',
        isSignedIn: true,
        hasCompletedOnboarding: true,
        isAddLanguageFlow: true,
      ),
      isNull,
    );
  });

  test('premium preview can open for signed-in users', () {
    expect(
      appRedirectFor(
        path: '/premium',
        isSignedIn: true,
        hasCompletedOnboarding: true,
      ),
      isNull,
    );
  });

  test('no social map or dating route exists', () {
    const blocked = ['map', 'social', 'dating', 'connect', 'chat', 'meetup'];

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
    await completeSpeakSession(firstContainer);
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

  test('settings survive restart', () async {
    SharedPreferences.setMockInitialValues({});
    final localStorage = await LocalStorageService.create();
    final firstContainer = ProviderContainer(
      overrides: [localStorageServiceProvider.overrideWithValue(localStorage)],
    );
    addTearDown(firstContainer.dispose);

    firstContainer.read(demoSettingsProvider.notifier).setTransliteration(true);
    firstContainer
        .read(demoSettingsProvider.notifier)
        .setStrictCorrections(false);
    firstContainer.read(demoSettingsProvider.notifier).setSpeechSpeed(0.65);
    await flushProviderWork();

    final restartContainer = ProviderContainer(
      overrides: [localStorageServiceProvider.overrideWithValue(localStorage)],
    );
    addTearDown(restartContainer.dispose);

    final settings = restartContainer.read(demoSettingsProvider);
    expect(settings.transliteration, isTrue);
    expect(settings.strictCorrections, isFalse);
    expect(settings.speechSpeed, 0.65);
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

  testWidgets('no real payment is triggered from premium preview', (
    tester,
  ) async {
    await pumpFluentOS(tester);
    final container = appContainer(tester);
    seedOnboardedUser(container);
    await pumpSplashDelay(tester);

    container.read(routerProvider).go('/premium');
    await tester.pumpAndSettle();
    await tapVisibleText(tester, 'Preview Pro');

    expect(container.read(userProvider).subscription, SubscriptionState.free);
    expect(
      find.text('No payment SDK is connected in this mock frontend.'),
      findsOneWidget,
    );
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

  testWidgets('Auth renders', (tester) async {
    await pumpFluentOS(tester);
    await openAuth(tester);

    expect(find.text('Start with your voice.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Onboarding renders', (tester) async {
    await pumpFluentOS(tester);
    await openAuth(tester);
    await tapVisibleText(tester, 'Continue');
    await pumpAuthDelay(tester);

    expect(find.text('Start my fluency journey'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Today renders', (tester) async {
    final container = await pumpOnboardedHome(tester);

    expect(find.textContaining('Good to see you'), findsOneWidget);
    expect(container.read(mainTabProvider), 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Speak renders', (tester) async {
    final container = await pumpOnboardedHome(tester);
    final mission = container.read(dailyMissionProvider)!;
    container.read(speakSessionProvider.notifier).startMission(mission);
    await tester.pump();
    container.read(mainTabProvider.notifier).setIndex(1);
    await tester.pump();

    expect(find.text('Speak'), findsAtLeastNWidgets(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Review renders', (tester) async {
    final container = await pumpOnboardedHome(tester);
    container.read(mainTabProvider.notifier).setIndex(2);
    await tester.pump();

    expect(find.text('Review'), findsAtLeastNWidgets(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Progress renders', (tester) async {
    final container = await pumpOnboardedHome(tester);
    container.read(mainTabProvider.notifier).setIndex(3);
    await tester.pump();

    expect(find.textContaining('speaker'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Profile renders', (tester) async {
    final container = await pumpOnboardedHome(tester);
    container.read(mainTabProvider.notifier).setIndex(4);
    await tester.pump();

    expect(find.text('Profile'), findsAtLeastNWidgets(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Premium renders', (tester) async {
    final container = await pumpOnboardedHome(tester);
    container.read(routerProvider).go('/premium');
    await tester.pumpAndSettle();

    expect(find.text('FluentOS Pro Preview'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('small Android screen smoke has no overflow exception', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final container = await pumpOnboardedHome(tester);
    for (var index = 0; index < 5; index++) {
      container.read(mainTabProvider.notifier).setIndex(index);
      await tester.pump();
      final exception = tester.takeException();
      expect(exception, isNull, reason: 'tab $index');
    }
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

Future<ProviderContainer> pumpOnboardedHome(WidgetTester tester) async {
  await pumpFluentOS(tester);
  final container = appContainer(tester);
  seedOnboardedUser(container);
  await pumpSplashDelay(tester);
  await tester.pumpAndSettle();
  return container;
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

Future<void> completeSpeakSession(ProviderContainer container) async {
  final language = container.read(languageProvider)!;
  final mission = container.read(dailyMissionProvider)!;
  final speakNotifier = container.read(speakSessionProvider.notifier);

  speakNotifier.startMission(mission);
  await flushProviderWork();
  speakNotifier.startListening();
  speakNotifier.finishListening(mission: mission, language: language);
  await flushProviderWork();
  speakNotifier.showCorrection(mission: mission, language: language);
  await flushProviderWork();
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
  await flushProviderWork();
}

Future<void> flushProviderWork() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}
