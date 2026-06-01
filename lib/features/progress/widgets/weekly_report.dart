part of '../progress_tab.dart';

class _WeeklyReport extends StatelessWidget {
  final int weeklyMinutes;
  final int repeatedCorrections;
  final String language;

  const _WeeklyReport({
    required this.weeklyMinutes,
    required this.repeatedCorrections,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      color: AppTheme.success.withAlpha(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppPill(
            label: 'Weekly report mock',
            icon: Icons.summarize_rounded,
            color: AppTheme.success,
          ),
          const SizedBox(height: 14),
          Text(
            weeklyMinutes == 0
                ? 'This week you set up your $language speaking identity. Complete your first mission to generate a real report.'
                : 'This week you spoke $weeklyMinutes minutes and repeated $repeatedCorrections corrected sentences.',
            style: const TextStyle(
              fontSize: 18,
              height: 1.35,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
