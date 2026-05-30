import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class TodayTab extends ConsumerStatefulWidget {
  const TodayTab({super.key});

  @override
  ConsumerState<TodayTab> createState() => _TodayTabState();
}

class _TodayTabState extends ConsumerState<TodayTab> {
  bool _showTransliteration = true;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final language = ref.watch(languageProvider);
    final mission = ref.watch(dailyMissionProvider);
    final missions = ref.watch(dailyMissionsProvider);
    final reviews = ref.watch(reviewsProvider);
    final progress = ref.watch(progressProvider);
    final onboarding = ref.watch(onboardingProvider);

    if (language == null || mission == null) {
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 118),
          child: EmptyStateCard(
            icon: Icons.language_rounded,
            title: 'No active language yet',
            body: 'Complete onboarding to create your first speaking mission.',
            action: PrimaryActionButton(
              label: 'Create my plan',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => context.go('/onboarding'),
              compact: true,
            ),
          ),
        ),
      );
    }

    final completedCount = missions.where((item) => item.isCompleted).length;
    final nextReview = reviews.where((item) => !item.isMastered).isEmpty
        ? null
        : reviews.where((item) => !item.isMastered).first;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 118),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FluentHeader(
              title: 'Good to see you, ${user.name}',
              subtitle:
                  '${language.name} from ${language.baseLanguageName} - ${user.streakDays} day streak',
              trailing: PremiumBadge(subscription: user.subscription),
            ),
            const SizedBox(height: 20),
            _ActiveLanguageSummary(language: language, onboarding: onboarding),
            const SizedBox(height: 18),
            MissionCard(
              mission: mission,
              onStart: () {
                ref
                    .read(speakSessionProvider.notifier)
                    .startMission(mission, mode: SpeakMode.dailyMission);
                ref.read(mainTabProvider.notifier).setIndex(1);
              },
            ),
            const SizedBox(height: 18),
            _ReadinessCard(
              language: language,
              confidence: onboarding?.speakingConfidence ?? 'A little nervous',
            ),
            const SizedBox(height: 18),
            const _MissionLoopPreview(),
            const SizedBox(height: 18),
            _ReviewPreview(item: nextReview, count: reviews.length),
            const SizedBox(height: 18),
            _ProgressSnapshot(
              progress: progress,
              completedCount: completedCount,
              missionCount: missions.length,
            ),
            const SizedBox(height: 18),
            _PhrasePackPreview(
              mission: mission,
              language: language,
              showTransliteration: _showTransliteration,
              onToggle: () {
                setState(() => _showTransliteration = !_showTransliteration);
              },
              onPractice: () {
                ref
                    .read(speakSessionProvider.notifier)
                    .startMission(mission, mode: SpeakMode.dailyMission);
                ref.read(mainTabProvider.notifier).setIndex(1);
              },
            ),
            if (user.subscription == SubscriptionState.free) ...[
              const SizedBox(height: 18),
              _PremiumPreviewCard(onTap: () => context.push('/premium')),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActiveLanguageSummary extends StatelessWidget {
  final LanguageProfile language;
  final OnboardingProfile? onboarding;

  const _ActiveLanguageSummary({
    required this.language,
    required this.onboarding,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withAlpha(44),
                  borderRadius: BorderRadius.circular(14),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'From ${language.baseLanguageName} - ${language.level}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              ),
              ProgressRing(
                value: language.fluencyScore / 700,
                center: '${language.fluencyScore}',
                label: 'Fluency',
                size: 82,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppPill(
                label: language.focus,
                icon: Icons.track_changes_rounded,
                color: AppTheme.success,
              ),
              AppPill(
                label: 'Confidence ${language.confidenceScore}%',
                icon: Icons.psychology_alt_rounded,
                color: AppTheme.warning,
              ),
              AppPill(
                label: '${onboarding?.dailyMinutes ?? 10} min/day',
                icon: Icons.timer_outlined,
                color: AppTheme.primaryCyan,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReadinessCard extends StatelessWidget {
  final LanguageProfile language;
  final String confidence;

  const _ReadinessCard({required this.language, required this.confidence});

  @override
  Widget build(BuildContext context) {
    final nervous =
        confidence == 'Very shy' || confidence == 'A little nervous';
    final weakArea = language.weakSounds.isEmpty
        ? 'sentence endings'
        : language.weakSounds.first;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Speak readiness'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  icon: Icons.psychology_alt_rounded,
                  label: 'confidence baseline',
                  value: '${language.confidenceScore}%',
                  color: AppTheme.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  icon: Icons.hearing_rounded,
                  label: 'weak area',
                  value: weakArea,
                  color: AppTheme.primaryCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppPill(
            label: nervous
                ? 'Start slow today. You marked yourself as a little nervous.'
                : 'Use roleplay today. Your baseline can handle longer answers.',
            icon: nervous ? Icons.favorite_outline_rounded : Icons.bolt_rounded,
            color: nervous ? AppTheme.mint : AppTheme.primaryCyan,
          ),
        ],
      ),
    );
  }
}

class _MissionLoopPreview extends StatelessWidget {
  const _MissionLoopPreview();

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('Speak', Icons.mic_rounded),
      ('Correct', Icons.auto_fix_high_rounded),
      ('Repeat', Icons.replay_rounded),
      ('Review', Icons.history_edu_rounded),
    ];

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          for (var index = 0; index < steps.length; index++) ...[
            Expanded(
              child: Column(
                children: [
                  Icon(steps[index].$2, color: AppTheme.primaryCyan),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      steps[index].$1,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
            if (index != steps.length - 1)
              const Icon(Icons.chevron_right_rounded, color: Colors.white38),
          ],
        ],
      ),
    );
  }
}

class _ReviewPreview extends ConsumerWidget {
  final ReviewItem? item;
  final int count;

  const _ReviewPreview({required this.item, required this.count});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => ref.read(mainTabProvider.notifier).setIndex(2),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.history_edu_rounded, color: AppTheme.primaryCyan),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count == 0
                        ? 'Review queue is empty'
                        : '$count review cards',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item == null
                        ? 'Complete a speaking session to create your first review card.'
                        : 'Next: ${item!.correction.focusArea}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white60),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}

class _ProgressSnapshot extends StatelessWidget {
  final ProgressState progress;
  final int completedCount;
  final int missionCount;

  const _ProgressSnapshot({
    required this.progress,
    required this.completedCount,
    required this.missionCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Progress snapshot'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                icon: Icons.timer_outlined,
                label: 'speaking minutes',
                value: '${progress.speakingMinutes}',
                color: AppTheme.primaryCyan,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                icon: Icons.task_alt_rounded,
                label: 'missions',
                value: '$completedCount/$missionCount',
                color: AppTheme.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                icon: Icons.insights_rounded,
                label: 'fluency score',
                value: '${progress.fluencyScore}',
                color: AppTheme.primaryViolet,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                icon: Icons.favorite_outline_rounded,
                label: 'confidence',
                value: '${progress.confidenceScore}%',
                color: AppTheme.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PhrasePackPreview extends StatelessWidget {
  final DailyMission mission;
  final LanguageProfile language;
  final bool showTransliteration;
  final VoidCallback onToggle;
  final VoidCallback onPractice;

  const _PhrasePackPreview({
    required this.mission,
    required this.language,
    required this.showTransliteration,
    required this.onToggle,
    required this.onPractice,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: SectionTitle(title: 'Phrase pack')),
              Switch(
                value: showTransliteration,
                onChanged: language.supportsTransliteration
                    ? (_) => onToggle()
                    : null,
              ),
            ],
          ),
          Text(
            language.supportsTransliteration
                ? showTransliteration
                      ? 'Transliteration shown'
                      : 'Native script mode mock'
                : language.scriptMode,
            style: const TextStyle(color: Colors.white60),
          ),
          const SizedBox(height: 14),
          for (final phrase in mission.targetPhrases.take(3)) ...[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(38),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withAlpha(22)),
              ),
              child: Text(
                phrase,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
          SecondaryActionButton(
            label: 'Practice these in Speak',
            icon: Icons.mic_rounded,
            onPressed: onPractice,
            compact: true,
          ),
        ],
      ),
    );
  }
}

class _PremiumPreviewCard extends StatelessWidget {
  final VoidCallback onTap;

  const _PremiumPreviewCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      color: AppTheme.primaryViolet.withAlpha(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppPill(
            label: 'Pro preview',
            icon: Icons.diamond_rounded,
            color: AppTheme.primaryCyan,
          ),
          const SizedBox(height: 14),
          const Text(
            'Multiple active languages and deeper coaching are locked for Pro.',
            style: TextStyle(
              fontSize: 18,
              height: 1.3,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          SecondaryActionButton(
            label: 'See Pro',
            icon: Icons.arrow_forward_rounded,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
