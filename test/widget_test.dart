import 'package:fluentos_app/main.dart';
import 'package:fluentos_app/models/models.dart';
import 'package:fluentos_app/providers/providers.dart';
import 'package:fluentos_app/services/local_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
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

    await restartContainer.read(mockPersistenceRepositoryProvider).clearAll();
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
      .read(fakeRepositoryProvider)
      .createLanguageProfile(profile);

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
