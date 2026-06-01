part of '../speak_tab.dart';

class _CompletionCard extends StatelessWidget {
  final SpeakSession session;
  final DailyMission mission;
  final VoidCallback onSave;
  final VoidCallback onNextMission;

  const _CompletionCard({
    required this.session,
    required this.mission,
    required this.onSave,
    required this.onNextMission,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      color: AppTheme.success.withAlpha(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppPill(
            label: 'Session complete',
            icon: Icons.check_circle_rounded,
            color: AppTheme.success,
          ),
          const SizedBox(height: 16),
          Text(
            mission.successCue,
            style: const TextStyle(
              fontSize: 20,
              height: 1.25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Save this correction so Review can turn it into repeat practice.',
            style: TextStyle(color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 18),
          PrimaryActionButton(
            label: session.isSavedToReview
                ? 'Saved to Review'
                : 'Save to Review',
            icon: session.isSavedToReview
                ? Icons.bookmark_added_rounded
                : Icons.bookmark_add_rounded,
            onPressed: session.isSavedToReview ? null : onSave,
          ),
          const SizedBox(height: 12),
          SecondaryActionButton(
            label: 'Next mission',
            icon: Icons.arrow_forward_rounded,
            onPressed: onNextMission,
          ),
        ],
      ),
    );
  }
}

class _SavedCard extends ConsumerWidget {
  final VoidCallback onNextMission;

  const _SavedCard({required this.onNextMission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      color: AppTheme.success.withAlpha(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppPill(
            label: 'Saved',
            icon: Icons.bookmark_added_rounded,
            color: AppTheme.success,
          ),
          const SizedBox(height: 16),
          const Text(
            'Review card created. Mission completed. Progress updated.',
            style: TextStyle(
              fontSize: 20,
              height: 1.3,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          ResponsiveActionRow(
            children: [
              SecondaryActionButton(
                label: 'Go Review',
                icon: Icons.history_edu_rounded,
                onPressed: () {
                  ref.read(mainTabProvider.notifier).setIndex(2);
                },
              ),
              PrimaryActionButton(
                label: 'Next',
                icon: Icons.arrow_forward_rounded,
                onPressed: onNextMission,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
