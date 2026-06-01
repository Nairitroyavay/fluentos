part of '../progress_tab.dart';

class _MainScorePanel extends StatelessWidget {
  final ProgressState progress;
  final int delta;

  const _MainScorePanel({required this.progress, required this.delta});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      color: AppTheme.primaryBlue.withAlpha(22),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final ring = ProgressRing(
            value: progress.fluencyScore / 700,
            center: '${progress.fluencyScore}',
            label: 'Fluency Score',
            size: 116,
          );
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppPill(
                label: delta >= 0 ? '+$delta this week' : '$delta this week',
                icon: Icons.trending_up_rounded,
                color: delta >= 0 ? AppTheme.success : AppTheme.warning,
              ),
              const SizedBox(height: 14),
              const Text(
                'Fluency is measured through spoken minutes, corrected sentences, repeat attempts, and completed scenarios.',
                style: TextStyle(color: Colors.white70, height: 1.35),
              ),
            ],
          );

          if (constraints.maxWidth < 380) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.centerLeft, child: ring),
                const SizedBox(height: 16),
                copy,
              ],
            );
          }

          return Row(
            children: [
              ring,
              const SizedBox(width: 18),
              Expanded(child: copy),
            ],
          );
        },
      ),
    );
  }
}

class _JourneyContextCard extends StatelessWidget {
  final LanguageProfile language;
  final ProgressState progress;

  const _JourneyContextCard({required this.language, required this.progress});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Fluency identity'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppPill(
                label: '${language.baseLanguageName} → ${language.name}',
                icon: Icons.compare_arrows_rounded,
              ),
              AppPill(
                label: language.userRegion,
                icon: Icons.public_rounded,
                color: AppTheme.mint,
              ),
              AppPill(
                label: language.goal,
                icon: Icons.track_changes_rounded,
                color: AppTheme.warning,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ResponsiveMetricGrid(
            children: [
              MetricCard(
                icon: Icons.timer_outlined,
                label: 'speaking minutes',
                value: '${progress.speakingMinutes}',
                color: AppTheme.primaryCyan,
              ),
              MetricCard(
                icon: Icons.forum_rounded,
                label: 'conversation readiness',
                value: '${progress.conversationReadiness}%',
                color: AppTheme.primaryViolet,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ResponsiveMetricGrid(
            children: [
              MetricCard(
                icon: Icons.task_alt_rounded,
                label: 'missions completed',
                value: '${progress.completedMissions}',
                color: AppTheme.success,
              ),
              MetricCard(
                icon: Icons.auto_fix_high_rounded,
                label: 'mistakes fixed',
                value: '${progress.correctionsSaved}',
                color: AppTheme.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
