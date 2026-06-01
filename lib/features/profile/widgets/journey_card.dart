part of '../profile_tab.dart';

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
          _InfoRow(label: 'Region / country', value: language!.userRegion),
          _InfoRow(label: 'Base language', value: language!.baseLanguageName),
          _InfoRow(label: 'Target language', value: language!.name),
          _InfoRow(label: 'Target culture', value: language!.targetCulture),
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
          _InfoRow(
            label: 'Accent',
            value: onboarding?.accentPreference ?? language!.accentPreference,
          ),
        ],
      ),
    );
  }
}
