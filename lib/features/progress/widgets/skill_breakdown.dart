part of '../progress_tab.dart';

class _MissionCompletion extends StatelessWidget {
  final ProgressState progress;

  const _MissionCompletion({required this.progress});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Mission completion'),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth < 390
                  ? (constraints.maxWidth - 12) / 2
                  : (constraints.maxWidth - 24) / 3;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: width,
                    child: _CompactStat(
                      label: 'completed today',
                      value: progress.completedMissions > 0 ? '1' : '0',
                      icon: Icons.today_rounded,
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _CompactStat(
                      label: 'weekly missions',
                      value: '${progress.completedMissions}',
                      icon: Icons.task_alt_rounded,
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _CompactStat(
                      label: 'scenarios',
                      value: '${progress.scenarioCount}',
                      icon: Icons.flag_rounded,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MistakeImprovement extends StatelessWidget {
  final ProgressState progress;

  const _MistakeImprovement({required this.progress});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Mistake improvement'),
          const SizedBox(height: 12),
          _ProgressLine(
            label: 'mistakes fixed',
            value: progress.correctionsSaved,
            max: 20,
            color: AppTheme.primaryCyan,
          ),
          _ProgressLine(
            label: 'repeated corrections',
            value: progress.repeatedCorrections,
            max: 20,
            color: AppTheme.success,
          ),
          _ProgressLine(
            label: 'mastered review items',
            value: progress.masteredReviewItems,
            max: 20,
            color: AppTheme.warning,
          ),
        ],
      ),
    );
  }
}

class _SkillBreakdown extends StatelessWidget {
  final Map<String, int> scores;

  const _SkillBreakdown({required this.scores});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Skill breakdown'),
          const SizedBox(height: 12),
          for (final entry in scores.entries) ...[
            _ProgressLine(
              label: entry.key,
              value: entry.value,
              max: 100,
              color: entry.key == 'Speaking'
                  ? AppTheme.primaryCyan
                  : AppTheme.primaryViolet,
            ),
          ],
        ],
      ),
    );
  }
}

class _ConfidenceTimeline extends StatelessWidget {
  final List<FluencySnapshot> snapshots;

  const _ConfidenceTimeline({required this.snapshots});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Confidence timeline'),
          const SizedBox(height: 12),
          for (final snapshot in snapshots.reversed.take(4)) ...[
            _ProgressLine(
              label: '${snapshot.date.month}/${snapshot.date.day}',
              value: snapshot.confidenceScore,
              max: 100,
              color: AppTheme.warning,
            ),
          ],
        ],
      ),
    );
  }
}

class _CompactStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _CompactStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryCyan),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}

class _ProgressLine extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  final Color color;

  const _ProgressLine({
    required this.label,
    required this.value,
    required this.max,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final normalized = max == 0 ? 0.0 : (value / max).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 360;
          final labelText = Text(
            label,
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70),
          );
          final progress = ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 9,
              value: normalized,
              backgroundColor: Colors.white.withAlpha(22),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          );
          final valueText = Text(
            '$value',
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w900),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: labelText),
                    const SizedBox(width: 10),
                    valueText,
                  ],
                ),
                const SizedBox(height: 8),
                progress,
              ],
            );
          }

          return Row(
            children: [
              SizedBox(width: 112, child: labelText),
              const SizedBox(width: 10),
              Expanded(child: progress),
              const SizedBox(width: 10),
              SizedBox(width: 34, child: valueText),
            ],
          );
        },
      ),
    );
  }
}
