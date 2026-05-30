import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  bool _transliteration = true;
  bool _strictCorrections = true;
  bool _notifications = false;
  bool _highContrast = false;
  bool _voiceConsent = false;
  double _speechSpeed = 0.72;
  String _coachTone = 'Calm coach';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final language = user.activeLanguage;
    final subscription = ref.watch(subscriptionProvider);
    final onboarding = ref.watch(onboardingProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 118),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FluentHeader(
              title: 'Profile',
              subtitle: 'Local mock settings for your speaking coach.',
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
                context.go('/onboarding');
              },
            ),
            const SizedBox(height: 18),
            _LearningPreferencesCard(
              transliteration: _transliteration,
              strictCorrections: _strictCorrections,
              speechSpeed: _speechSpeed,
              coachTone: _coachTone,
              notifications: _notifications,
              onTransliterationChanged: (value) {
                setState(() => _transliteration = value);
              },
              onStrictnessChanged: (value) {
                setState(() => _strictCorrections = value);
              },
              onSpeechSpeedChanged: (value) {
                setState(() => _speechSpeed = value);
              },
              onCoachToneChanged: (value) {
                setState(() => _coachTone = value);
              },
              onNotificationsChanged: (value) {
                setState(() => _notifications = value);
              },
            ),
            const SizedBox(height: 18),
            _PrivacyCard(
              voiceConsent: _voiceConsent,
              onVoiceConsentChanged: (value) {
                setState(() => _voiceConsent = value);
              },
            ),
            const SizedBox(height: 18),
            const _OptivusCard(),
            const SizedBox(height: 18),
            _SettingsCard(
              highContrast: _highContrast,
              onHighContrastChanged: (value) {
                setState(() => _highContrast = value);
              },
              onSignOut: () => _signOut(context),
            ),
          ],
        ),
      ),
    );
  }

  void _signOut(BuildContext context) {
    ref.read(authProvider.notifier).signOut();
    ref.read(userProvider.notifier).resetToFreshUser();
    ref.read(onboardingProvider.notifier).clear();
    ref.read(dailyMissionsProvider.notifier).clear();
    ref.read(reviewsProvider.notifier).clear();
    ref.read(progressProvider.notifier).clear();
    ref.read(speakSessionProvider.notifier).clear();
    ref.read(mainTabProvider.notifier).setIndex(0);
    context.go('/auth');
  }
}

class _UserCard extends StatelessWidget {
  final UserProfile user;
  final LanguageProfile? language;

  const _UserCard({required this.user, required this.language});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppTheme.primaryBlue, AppTheme.primaryViolet],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryCyan.withAlpha(52),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Text(
              user.name.isEmpty ? '?' : user.name[0].toUpperCase(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white60),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    PremiumBadge(subscription: user.subscription),
                    AppPill(
                      label: language?.name ?? 'No active language',
                      icon: Icons.language_rounded,
                      color: AppTheme.primaryCyan,
                      dense: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyCard extends StatelessWidget {
  final LanguageProfile? language;
  final OnboardingProfile? onboarding;

  const _JourneyCard({required this.language, required this.onboarding});

  @override
  Widget build(BuildContext context) {
    if (language == null) {
      return EmptyStateCard(
        icon: Icons.route_rounded,
        title: 'No active journey',
        body: 'Complete onboarding to create your first speaking plan.',
        action: PrimaryActionButton(
          label: 'Create plan',
          icon: Icons.arrow_forward_rounded,
          onPressed: () => context.go('/onboarding'),
          compact: true,
        ),
      );
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Active language journey'),
          const SizedBox(height: 12),
          _InfoRow(label: 'Base language', value: language!.baseLanguageName),
          _InfoRow(label: 'Target language', value: language!.name),
          _InfoRow(label: 'Level', value: language!.level),
          _InfoRow(
            label: 'Goal',
            value: onboarding?.learningGoal ?? 'Speak with confidence',
          ),
          _InfoRow(
            label: 'Daily time',
            value: '${onboarding?.dailyMinutes ?? 10} min',
          ),
          _InfoRow(
            label: 'Confidence',
            value:
                onboarding?.speakingConfidence ??
                '${language!.confidenceScore}%',
          ),
        ],
      ),
    );
  }
}

class _ManageLanguagesCard extends StatelessWidget {
  final SubscriptionState subscription;
  final LanguageProfile? language;
  final VoidCallback onAdd;

  const _ManageLanguagesCard({
    required this.subscription,
    required this.language,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final locked = subscription == SubscriptionState.free && language != null;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Manage languages'),
          const SizedBox(height: 12),
          if (language == null)
            const Text(
              'No active language yet.',
              style: TextStyle(color: Colors.white60),
            )
          else
            _LanguageJourneyRow(language: language!),
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onAdd,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: locked
                    ? AppTheme.primaryViolet.withAlpha(26)
                    : Colors.white.withAlpha(12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withAlpha(24)),
              ),
              child: Row(
                children: [
                  Icon(
                    locked
                        ? Icons.lock_rounded
                        : Icons.add_circle_outline_rounded,
                    color: locked ? AppTheme.warning : AppTheme.primaryCyan,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locked ? 'Add second language' : 'Add language',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          locked
                              ? 'Free keeps one active language. Preview Pro to unlock multiple journeys.'
                              : 'Create another focused speaking journey.',
                          style: const TextStyle(
                            color: Colors.white60,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white54,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningPreferencesCard extends StatelessWidget {
  final bool transliteration;
  final bool strictCorrections;
  final bool notifications;
  final double speechSpeed;
  final String coachTone;
  final ValueChanged<bool> onTransliterationChanged;
  final ValueChanged<bool> onStrictnessChanged;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<double> onSpeechSpeedChanged;
  final ValueChanged<String> onCoachToneChanged;

  const _LearningPreferencesCard({
    required this.transliteration,
    required this.strictCorrections,
    required this.notifications,
    required this.speechSpeed,
    required this.coachTone,
    required this.onTransliterationChanged,
    required this.onStrictnessChanged,
    required this.onNotificationsChanged,
    required this.onSpeechSpeedChanged,
    required this.onCoachToneChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Learning preferences'),
          const SizedBox(height: 8),
          _SwitchRow(
            title: 'Transliteration support',
            subtitle: 'Show pronunciation help for supported scripts.',
            value: transliteration,
            onChanged: onTransliterationChanged,
          ),
          _SwitchRow(
            title: 'Correction strictness',
            subtitle: strictCorrections
                ? 'Detailed coach notes'
                : 'Gentle essentials only',
            value: strictCorrections,
            onChanged: onStrictnessChanged,
          ),
          _SwitchRow(
            title: 'Reminder time mock',
            subtitle: notifications
                ? 'Evening practice reminder'
                : 'No local reminder',
            value: notifications,
            onChanged: onNotificationsChanged,
          ),
          const SizedBox(height: 10),
          const Text(
            'Coach tone',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tone in const [
                'Calm coach',
                'Direct coach',
                'Exam coach',
              ])
                FluentChip(
                  label: tone,
                  selected: coachTone == tone,
                  onTap: () => onCoachToneChanged(tone),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Speech speed ${(speechSpeed * 100).round()}%',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          Slider(
            value: speechSpeed,
            min: 0.45,
            max: 1,
            divisions: 11,
            onChanged: onSpeechSpeedChanged,
          ),
        ],
      ),
    );
  }
}

class _LanguageJourneyRow extends StatelessWidget {
  final LanguageProfile language;

  const _LanguageJourneyRow({required this.language});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryCyan.withAlpha(72)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              language.flag,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  language.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Active from ${language.baseLanguageName} - ${language.focus}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white60, height: 1.3),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: AppTheme.success),
        ],
      ),
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  final bool voiceConsent;
  final ValueChanged<bool> onVoiceConsentChanged;

  const _PrivacyCard({
    required this.voiceConsent,
    required this.onVoiceConsentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Privacy and voice consent'),
          const SizedBox(height: 10),
          const _InlineNotice(
            title: 'Voice data in mock mode',
            body:
                'No real microphone, speech-to-text, cloud storage, or model training is used in this frontend MVP.',
          ),
          const SizedBox(height: 12),
          _SwitchRow(
            title: 'Model improvement opt-in mock',
            subtitle: voiceConsent ? 'Opt-in shown locally' : 'Off by default',
            value: voiceConsent,
            onChanged: onVoiceConsentChanged,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SecondaryActionButton(
                  label: 'Export placeholder',
                  icon: Icons.file_download_outlined,
                  onPressed: () {},
                  compact: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SecondaryActionButton(
                  label: 'Delete placeholder',
                  icon: Icons.delete_outline_rounded,
                  onPressed: () {},
                  compact: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InlineNotice extends StatelessWidget {
  final String title;
  final String body;

  const _InlineNotice({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withAlpha(22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(24)),
      ),
      child: Row(
        children: [
          const Icon(Icons.privacy_tip_outlined, color: AppTheme.primaryCyan),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: const TextStyle(color: Colors.white60, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OptivusCard extends StatelessWidget {
  const _OptivusCard();

  @override
  Widget build(BuildContext context) {
    return const GlassCard(
      color: Color(0x1821D7FF),
      child: Row(
        children: [
          Icon(Icons.hub_outlined, color: AppTheme.primaryCyan),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connect with Optivus later',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4),
                Text(
                  'Coming later. No sync is implemented in this frontend MVP.',
                  style: TextStyle(color: Colors.white60, height: 1.35),
                ),
              ],
            ),
          ),
          AppPill(
            label: 'Coming later',
            icon: Icons.lock_clock_rounded,
            color: AppTheme.warning,
            dense: true,
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final bool highContrast;
  final ValueChanged<bool> onHighContrastChanged;
  final VoidCallback onSignOut;

  const _SettingsCard({
    required this.highContrast,
    required this.onHighContrastChanged,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Settings'),
          const SizedBox(height: 8),
          _SwitchRow(
            title: 'Theme mock',
            subtitle: highContrast
                ? 'High contrast preview'
                : 'Dark liquid theme',
            value: highContrast,
            onChanged: onHighContrastChanged,
          ),
          const _InfoRow(label: 'Notifications', value: 'Local mock only'),
          const _InfoRow(
            label: 'Accessibility',
            value: 'Captions, large targets, reduced motion aware',
          ),
          const SizedBox(height: 12),
          SecondaryActionButton(
            label: 'Sign out',
            icon: Icons.logout_rounded,
            onPressed: onSignOut,
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white60, height: 1.3),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 118,
            child: Text(label, style: const TextStyle(color: Colors.white54)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w800, height: 1.25),
            ),
          ),
        ],
      ),
    );
  }
}
