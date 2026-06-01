part of 'theme.dart';

class LiquidBackground extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const LiquidBackground({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.backgroundDark,
            Color(0xFF101035),
            Color(0xFF07172C),
            AppTheme.backgroundDark,
          ],
          stops: [0, 0.42, 0.74, 1],
        ),
      ),
      child: CustomPaint(
        painter: const _LiquidGradientPainter(),
        child: SizedBox.expand(
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class _LiquidGradientPainter extends CustomPainter {
  const _LiquidGradientPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final firstPath = Path()
      ..moveTo(-size.width * 0.2, size.height * 0.10)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.02,
        size.width * 0.45,
        size.height * 0.33,
        size.width * 0.92,
        size.height * 0.18,
      )
      ..cubicTo(
        size.width * 1.18,
        size.height * 0.10,
        size.width * 1.10,
        size.height * 0.34,
        size.width * 0.72,
        size.height * 0.42,
      )
      ..cubicTo(
        size.width * 0.32,
        size.height * 0.52,
        size.width * 0.08,
        size.height * 0.28,
        -size.width * 0.2,
        size.height * 0.38,
      )
      ..close();

    final secondPath = Path()
      ..moveTo(-size.width * 0.15, size.height * 0.72)
      ..cubicTo(
        size.width * 0.2,
        size.height * 0.58,
        size.width * 0.5,
        size.height * 0.84,
        size.width * 0.82,
        size.height * 0.66,
      )
      ..cubicTo(
        size.width * 1.08,
        size.height * 0.52,
        size.width * 1.18,
        size.height * 0.82,
        size.width * 0.86,
        size.height * 0.96,
      )
      ..cubicTo(
        size.width * 0.48,
        size.height * 1.12,
        size.width * 0.1,
        size.height * 0.9,
        -size.width * 0.15,
        size.height,
      )
      ..close();

    final thirdPath = Path()
      ..moveTo(size.width * 0.65, -size.height * 0.05)
      ..cubicTo(
        size.width * 0.90,
        size.height * 0.10,
        size.width * 1.06,
        size.height * 0.18,
        size.width * 1.16,
        size.height * 0.38,
      )
      ..cubicTo(
        size.width * 0.96,
        size.height * 0.28,
        size.width * 0.80,
        size.height * 0.24,
        size.width * 0.62,
        size.height * 0.16,
      )
      ..close();

    final firstPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0x6621D7FF), Color(0x598F5BFF), Color(0x1A2E6BFF)],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 34);

    final secondPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0x332E6BFF), Color(0x665527D7), Color(0x2621D7FF)],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 44);

    final thirdPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0x557AF7C4), Color(0x0021D7FF)],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);

    canvas.drawPath(firstPath, firstPaint);
    canvas.drawPath(secondPath, secondPaint);
    canvas.drawPath(thirdPath, thirdPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
