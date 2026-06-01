part of 'theme.dart';

class MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? footer;

  const MetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.footer,
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
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white60),
          ),
          if (footer != null) ...[
            const SizedBox(height: 8),
            Text(
              footer!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

class ResponsiveMetricGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double minTileWidth;

  const ResponsiveMetricGrid({
    super.key,
    required this.children,
    this.spacing = 12,
    this.minTileWidth = 150,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = math
            .max(1, (constraints.maxWidth / minTileWidth).floor())
            .clamp(1, children.length);
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  const EmptyStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      color: Colors.white.withAlpha(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.primaryCyan, size: 42),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}

class ProgressRing extends StatelessWidget {
  final double value;
  final String center;
  final String label;
  final Color color;
  final double size;

  const ProgressRing({
    super.key,
    required this.value,
    required this.center,
    required this.label,
    this.color = AppTheme.primaryCyan,
    this.size = 116,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: Column(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _RingPainter(value.clamp(0, 1), color),
              child: Center(
                child: Text(
                  center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double value;
  final Color color;

  const _RingPainter(this.value, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final stroke = size.width * 0.10;
    final center = rect.center;
    final radius = (size.width - stroke) / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withAlpha(28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      value * math.pi * 2,
      false,
      Paint()
        ..shader = SweepGradient(
          colors: [color, AppTheme.primaryViolet, color],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
