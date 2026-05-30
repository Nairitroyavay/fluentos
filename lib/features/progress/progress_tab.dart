import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class ProgressTab extends ConsumerWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final language = ref.watch(languageProvider);
    final progress = ref.watch(progressProvider);
    final snapshots = progress.snapshots;

    if (language == null || snapshots.isEmpty) {
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 118),
          child: EmptyStateCard(
            icon: Icons.insights_rounded,
            title: 'Progress starts after onboarding',
            body:
                'Create your first language plan, complete a speaking mission, and FluentOS will show proof of practice here.',
            action: PrimaryActionButton(
              label: 'Go to Today',
              icon: Icons.wb_sunny_outlined,
              onPressed: () => ref.read(mainTabProvider.notifier).setIndex(0),
              compact: true,
            ),
          ),
        ),
      );
    }

    final first = snapshots.first;
    final latest = snapshots.last;
    final weeklyMinutes = latest.speakMinutes;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 118),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FluentHeader(
              title: 'You are becoming a ${language.name} speaker.',
              subtitle:
                  '${user.totalSpeakMinutes} minutes spoken - ${progress.completedMissions} missions completed',
              trailing: AppPill(
                label: '${progress.streakDays} day streak',
                icon: Icons.local_fire_department_rounded,
                color: AppTheme.warning,
              ),
            ),
            const SizedBox(height: 20),
            _MainScorePanel(
              progress: progress,
              delta: latest.fluencyScore - first.fluencyScore,
            ),
            const SizedBox(height: 18),
            _ScoreGrid(progress: progress),
            const SizedBox(height: 18),
            _WeeklyGraph(snapshots: snapshots),
            const SizedBox(height: 18),
            _MissionCompletion(progress: progress),
            const SizedBox(height: 18),
            _MistakeImprovement(progress: progress),
            const SizedBox(height: 18),
            _SkillBreakdown(scores: progress.skillScores),
            const SizedBox(height: 18),
            _ConfidenceTimeline(snapshots: snapshots),
            const SizedBox(height: 18),
            _WeeklyReport(
              weeklyMinutes: weeklyMinutes,
              repeatedCorrections: progress.repeatedCorrections,
              language: language.name,
            ),
          ],
        ),
      ),
    );
  }
}

class _MainScorePanel extends StatelessWidget {
  final ProgressState progress;
  final int delta;

  const _MainScorePanel({required this.progress, required this.delta});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      color: AppTheme.primaryBlue.withAlpha(22),
      child: Row(
        children: [
          ProgressRing(
            value: progress.fluencyScore / 700,
            center: '${progress.fluencyScore}',
            label: 'Fluency Score',
            size: 116,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
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
            ),
          ),
        ],
      ),
    );
  }
}

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

class _WeeklyGraph extends StatelessWidget {
  final List<FluencySnapshot> snapshots;

  const _WeeklyGraph({required this.snapshots});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Weekly speaking graph'),
          const SizedBox(height: 18),
          SizedBox(
            height: 168,
            child: CustomPaint(
              painter: _FluencyChartPainter(snapshots),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final snapshot in snapshots)
                Text(
                  '${snapshot.date.month}/${snapshot.date.day}',
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

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
          Row(
            children: [
              Expanded(
                child: _CompactStat(
                  label: 'completed today',
                  value: progress.completedMissions > 0 ? '1' : '0',
                  icon: Icons.today_rounded,
                ),
              ),
              Expanded(
                child: _CompactStat(
                  label: 'weekly missions',
                  value: '${progress.completedMissions}',
                  icon: Icons.task_alt_rounded,
                ),
              ),
              Expanded(
                child: _CompactStat(
                  label: 'scenarios',
                  value: '${progress.scenarioCount}',
                  icon: Icons.flag_rounded,
                ),
              ),
            ],
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
      child: Row(
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 9,
                value: normalized,
                backgroundColor: Colors.white.withAlpha(22),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 34,
            child: Text(
              '$value',
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
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

class _FluencyChartPainter extends CustomPainter {
  final List<FluencySnapshot> snapshots;

  const _FluencyChartPainter(this.snapshots);

  @override
  void paint(Canvas canvas, Size size) {
    if (snapshots.isEmpty) {
      return;
    }

    final gridPaint = Paint()
      ..color = Colors.white.withAlpha(22)
      ..strokeWidth = 1;

    for (var index = 0; index < 4; index++) {
      final y = size.height * index / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final minScore = snapshots
        .map((snapshot) => snapshot.fluencyScore)
        .reduce((a, b) => a < b ? a : b);
    final maxScore = snapshots
        .map((snapshot) => snapshot.fluencyScore)
        .reduce((a, b) => a > b ? a : b);
    final range = (maxScore - minScore).clamp(1, 1000).toDouble();
    final stepX = snapshots.length == 1
        ? 0.0
        : size.width / (snapshots.length - 1);
    final path = Path();

    for (var index = 0; index < snapshots.length; index++) {
      final normalized = (snapshots[index].fluencyScore - minScore) / range;
      final point = Offset(
        stepX * index,
        size.height - normalized * (size.height - 18) - 9,
      );

      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }

      canvas.drawCircle(point, 4, Paint()..color = AppTheme.primaryCyan);
    }

    final linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppTheme.primaryCyan, AppTheme.primaryViolet],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _FluencyChartPainter oldDelegate) {
    return oldDelegate.snapshots != snapshots;
  }
}
