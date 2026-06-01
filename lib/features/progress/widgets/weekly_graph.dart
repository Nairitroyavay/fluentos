part of '../progress_tab.dart';

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
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final snapshot in snapshots)
                SizedBox(
                  width: 34,
                  child: Text(
                    '${snapshot.date.month}/${snapshot.date.day}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ),
            ],
          ),
        ],
      ),
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
