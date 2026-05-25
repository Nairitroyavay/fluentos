import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color backgroundDark = Color(0xFF05060D);
  static const Color backgroundMedium = Color(0xFF101322);
  static const Color backgroundLight = Color(0xFF191D32);
  static const Color glassSurface = Color(0x1FFFFFFF);
  static const Color borderGlow = Color(0x3DFFFFFF);
  static const Color primaryViolet = Color(0xFF8F5BFF);
  static const Color deepViolet = Color(0xFF5527D7);
  static const Color primaryBlue = Color(0xFF2E6BFF);
  static const Color primaryCyan = Color(0xFF21D7FF);
  static const Color success = Color(0xFF37E6A4);
  static const Color warning = Color(0xFFFFB84D);

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.outfitTextTheme(
      base.textTheme,
    ).apply(bodyColor: Colors.white, displayColor: Colors.white);

    return base.copyWith(
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryViolet,
        secondary: primaryCyan,
        surface: backgroundMedium,
        onPrimary: Colors.white,
        onSecondary: backgroundDark,
      ),
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withAlpha(18),
        hintStyle: const TextStyle(color: Colors.white54),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withAlpha(28)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withAlpha(28)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryCyan),
        ),
      ),
    );
  }
}

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
            AppTheme.backgroundDark,
          ],
          stops: [0, 0.48, 1],
        ),
      ),
      child: CustomPaint(
        painter: const _LiquidGradientPainter(),
        child: Padding(padding: padding, child: child),
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
      ..moveTo(-size.width * 0.2, size.height * 0.12)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.02,
        size.width * 0.42,
        size.height * 0.34,
        size.width * 0.86,
        size.height * 0.2,
      )
      ..cubicTo(
        size.width * 1.18,
        size.height * 0.1,
        size.width * 1.08,
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

    final firstPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0x6621D7FF), Color(0x598F5BFF), Color(0x1A2E6BFF)],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 32);

    final secondPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0x332E6BFF), Color(0x665527D7), Color(0x2621D7FF)],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);

    canvas.drawPath(firstPath, firstPaint);
    canvas.drawPath(secondPath, secondPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double width;
  final double? height;
  final Color color;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.borderRadius = 8,
    this.width = double.infinity,
    this.height,
    this.color = AppTheme.glassSurface,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: AppTheme.borderGlow),
          ),
          child: child,
        ),
      ),
    );
  }
}

class PrimaryActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryViolet,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.white.withAlpha(20),
          disabledForegroundColor: Colors.white38,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class SecondaryActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const SecondaryActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        icon: Icon(icon, size: 19),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white.withAlpha(48)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class AppPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const AppPill({
    super.key,
    required this.label,
    required this.icon,
    this.color = AppTheme.primaryCyan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(82)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
