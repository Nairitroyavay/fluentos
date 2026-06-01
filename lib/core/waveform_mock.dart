part of 'theme.dart';

class WaveformMock extends StatelessWidget {
  final bool active;
  final double height;

  const WaveformMock({super.key, required this.active, this.height = 54});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _WaveformPainter(active),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final bool active;

  const _WaveformPainter(this.active);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4
      ..color = active ? AppTheme.primaryCyan : Colors.white24;

    const bars = 28;
    final step = size.width / bars;
    for (var index = 0; index < bars; index++) {
      final wave = math.sin(index * 0.72) * 0.5 + 0.5;
      final quiet = index.isEven ? 0.32 : 0.18;
      final factor = active ? (0.28 + wave * 0.72) : quiet;
      final barHeight = size.height * factor;
      final x = step * index + step / 2;
      canvas.drawLine(
        Offset(x, (size.height - barHeight) / 2),
        Offset(x, (size.height + barHeight) / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.active != active;
  }
}
