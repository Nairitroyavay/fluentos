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
    final snapshots = ref.watch(fluencySnapshotsProvider);
    final latest = snapshots.last;
    final first = snapshots.first;
    final savedMistakes = ref.watch(reviewsProvider).length;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 118),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress',
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              user.activeLanguage?.name ?? 'No active language',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const AppPill(
                        label: 'Fluency snapshot',
                        icon: Icons.insights_rounded,
                      ),
                      const Spacer(),
                      Text(
                        '+${latest.score - first.score}',
                        style: const TextStyle(
                          color: AppTheme.success,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '${latest.score}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      height: 0.95,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Fluency score',
                    style: TextStyle(color: Colors.white60),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 172,
                    child: CustomPaint(
                      painter: _FluencyChartPainter(snapshots),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _ProgressMetric(
                    icon: Icons.timer_outlined,
                    value: '${user.totalSpeakMinutes}',
                    label: 'minutes spoken',
                    color: AppTheme.primaryCyan,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ProgressMetric(
                    icon: Icons.bookmarks_outlined,
                    value: '$savedMistakes',
                    label: 'saved mistakes',
                    color: AppTheme.primaryViolet,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weekly pattern',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 14),
                  for (final snapshot in snapshots.reversed.take(3)) ...[
                    _SnapshotRow(snapshot: snapshot),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _ProgressMetric({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
          ),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white60),
          ),
        ],
      ),
    );
  }
}

class _SnapshotRow extends StatelessWidget {
  final FluencySnapshot snapshot;

  const _SnapshotRow({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 46,
          child: Text(
            '${snapshot.date.month}/${snapshot.date.day}',
            style: const TextStyle(color: Colors.white54),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: snapshot.score / 600,
              backgroundColor: Colors.white.withAlpha(22),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.primaryCyan,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 38,
          child: Text(
            '${snapshot.score}',
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
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
        .map((snapshot) => snapshot.score)
        .reduce((a, b) => a < b ? a : b);
    final maxScore = snapshots
        .map((snapshot) => snapshot.score)
        .reduce((a, b) => a > b ? a : b);
    final range = (maxScore - minScore).clamp(1, 1000).toDouble();
    final stepX = snapshots.length == 1
        ? 0.0
        : size.width / (snapshots.length - 1);
    final path = Path();

    for (var index = 0; index < snapshots.length; index++) {
      final normalized = (snapshots[index].score - minScore) / range;
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
