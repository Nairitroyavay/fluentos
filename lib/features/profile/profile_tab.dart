import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../core/router.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

part 'widgets/user_card.dart';
part 'widgets/journey_card.dart';
part 'widgets/manage_languages_card.dart';
part 'widgets/learning_preferences_card.dart';
part 'widgets/privacy_card.dart';
part 'widgets/settings_card.dart';
part 'widgets/optivus_card.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final language = user.activeLanguage;
    final subscription = ref.watch(subscriptionProvider);
    final onboarding = ref.watch(onboardingProvider);
    final settings = ref.watch(demoSettingsProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 118),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FluentHeader(
              title: 'Profile',
              subtitle: 'Your global speaking-first mock profile.',
              trailing: PremiumBadge(subscription: subscription),
            ),
            const SizedBox(height: 20),
            _UserCard(user: user, language: language),
            const SizedBox(height: 18),
            _JourneyCard(language: language, onboarding: onboarding),
            const SizedBox(height: 18),
            _ManageLanguagesCard(
              subscription: subscription,
              language: language,
              onAdd: () {
                if (subscription == SubscriptionState.free &&
                    language != null) {
                  context.push('/premium');
                  return;
                }
                context.go('/onboarding?flow=$addLanguageFlowQueryValue');
              },
            ),
            const SizedBox(height: 18),
            _LearningPreferencesCard(
              transliteration: settings.transliteration,
              strictCorrections: settings.strictCorrections,
              speechSpeed: settings.speechSpeed,
              coachTone: settings.coachTone,
              notifications: settings.notifications,
              scriptMode: language?.scriptMode ?? 'Latin script',
              hasRomanization: language?.hasRomanization ?? false,
              hasTransliteration: language?.hasTransliteration ?? false,
              accentPreference:
                  onboarding?.accentPreference ??
                  language?.accentPreference ??
                  'Global clear',
              onTransliterationChanged: (value) {
                ref
                    .read(demoSettingsProvider.notifier)
                    .setTransliteration(value);
              },
              onStrictnessChanged: (value) {
                ref
                    .read(demoSettingsProvider.notifier)
                    .setStrictCorrections(value);
              },
              onSpeechSpeedChanged: (value) {
                ref.read(demoSettingsProvider.notifier).setSpeechSpeed(value);
              },
              onCoachToneChanged: (value) {
                ref.read(demoSettingsProvider.notifier).setCoachTone(value);
              },
              onNotificationsChanged: (value) {
                ref.read(demoSettingsProvider.notifier).setNotifications(value);
              },
            ),
            const SizedBox(height: 18),
            _PrivacyCard(
              voiceConsent: settings.voiceConsent,
              onVoiceConsentChanged: (value) {
                ref.read(demoSettingsProvider.notifier).setVoiceConsent(value);
              },
            ),
            const SizedBox(height: 18),
            const _OptivusCard(),
            const SizedBox(height: 18),
            _SettingsCard(
              highContrast: settings.highContrast,
              onHighContrastChanged: (value) {
                ref.read(demoSettingsProvider.notifier).setHighContrast(value);
              },
              onSignOut: () => _signOut(context),
              onResetDemoData: _resetDemoData,
            ),
          ],
        ),
      ),
    );
  }

  void _signOut(BuildContext context) {
    ref.read(authProvider.notifier).signOut();
    ref.read(speakSessionProvider.notifier).clear();
    ref.read(mainTabProvider.notifier).setIndex(0);
    context.go('/auth');
  }

  Future<void> _resetDemoData() async {
    await ref.read(localPersistenceRepositoryProvider).clearAll();
    if (!mounted) {
      return;
    }

    ref.read(authProvider.notifier).resetForDemo();
    ref.read(userProvider.notifier).resetToFreshUser(persist: false);
    ref.read(onboardingProvider.notifier).clear(persist: false);
    ref.read(dailyMissionsProvider.notifier).clear(persist: false);
    ref.read(reviewsProvider.notifier).clear(persist: false);
    ref.read(progressProvider.notifier).clear(persist: false);
    ref.read(demoSettingsProvider.notifier).resetForDemo();
    ref.read(speakSessionProvider.notifier).clear();
    ref.read(mainTabProvider.notifier).setIndex(0);
    context.go('/auth');
  }
}
