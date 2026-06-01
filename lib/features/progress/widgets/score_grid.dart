part of '../progress_tab.dart';

class _ScoreGrid extends StatelessWidget {
  final ProgressState progress;

  const _ScoreGrid({required this.progress});

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _MetricSpec(
        Icons.psychology_alt_rounded,
        'Speaking Confidence',
        '${progress.confidenceScore}%',
        AppTheme.warning,
      ),
      _MetricSpec(
        Icons.hearing_rounded,
        'Pronunciation',
        '${progress.pronunciationScore}%',
        AppTheme.primaryCyan,
      ),
      _MetricSpec(
        Icons.rule_rounded,
        'Grammar',
        '${progress.grammarScore}%',
        AppTheme.mint,
      ),
      _MetricSpec(
        Icons.forum_rounded,
        'Conversation Readiness',
        '${progress.conversationReadiness}%',
        AppTheme.primaryViolet,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final metric in metrics)
              SizedBox(
                width: itemWidth,
                child: MetricCard(
                  icon: metric.icon,
                  label: metric.label,
                  value: metric.value,
                  color: metric.color,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _MetricSpec {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetricSpec(this.icon, this.label, this.value, this.color);
}
