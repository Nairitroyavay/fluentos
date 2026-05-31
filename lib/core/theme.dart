import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/models.dart';

class AppTheme {
  static const Color backgroundDark = Color(0xFF05060D);
  static const Color backgroundMedium = Color(0xFF101322);
  static const Color backgroundLight = Color(0xFF191D32);
  static const Color glassSurface = Color(0x24FFFFFF);
  static const Color borderGlow = Color(0x3DFFFFFF);
  static const Color primaryViolet = Color(0xFF8F5BFF);
  static const Color deepViolet = Color(0xFF5527D7);
  static const Color primaryBlue = Color(0xFF2E6BFF);
  static const Color primaryCyan = Color(0xFF21D7FF);
  static const Color success = Color(0xFF37E6A4);
  static const Color warning = Color(0xFFFFB84D);
  static const Color coral = Color(0xFFFF6B8A);
  static const Color mint = Color(0xFF7AF7C4);

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
      splashFactory: InkSparkle.splashFactory,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withAlpha(18),
        hintStyle: const TextStyle(color: Colors.white54),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withAlpha(28)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withAlpha(28)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryCyan),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryViolet.withAlpha(58);
            }
            return Colors.white.withAlpha(10);
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return Colors.white70;
          }),
          side: WidgetStatePropertyAll(
            BorderSide(color: Colors.white.withAlpha(34)),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
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

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double width;
  final double? height;
  final Color color;
  final Color borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.borderRadius = 12,
    this.width = double.infinity,
    this.height,
    this.color = AppTheme.glassSurface,
    this.borderColor = AppTheme.borderGlow,
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
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(34),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
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
  final bool compact;

  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: compact ? 46 : 54,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: compact ? 18 : 20),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryViolet,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.white.withAlpha(20),
          disabledForegroundColor: Colors.white38,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: compact ? 14 : 16,
            fontWeight: FontWeight.w800,
          ),
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
  final bool compact;

  const SecondaryActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: compact ? 44 : 50,
      child: OutlinedButton.icon(
        icon: Icon(icon, size: compact ? 18 : 19),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white.withAlpha(48)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: compact ? 14 : 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class GradientPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool dense;

  const GradientPill({
    super.key,
    required this.label,
    required this.icon,
    this.color = AppTheme.primaryCyan,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 9 : 11,
        vertical: dense ? 6 : 7,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(28),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withAlpha(86)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: dense ? 14 : 15, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: dense ? 11 : 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppPill extends GradientPill {
  const AppPill({
    super.key,
    required super.label,
    required super.icon,
    super.color,
    super.dense,
  });
}

class FluentHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;

  const FluentHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}

class PremiumBadge extends StatelessWidget {
  final SubscriptionState subscription;

  const PremiumBadge({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    final isFree = subscription == SubscriptionState.free;
    return AppPill(
      label: subscription.label,
      icon: isFree ? Icons.lock_open_rounded : Icons.diamond_rounded,
      color: isFree ? AppTheme.warning : AppTheme.primaryCyan,
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              actionLabel!,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
      ],
    );
  }
}

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

class FluentChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool locked;
  final VoidCallback? onTap;
  final IconData? icon;

  const FluentChip({
    super.key,
    required this.label,
    this.selected = false,
    this.locked = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = locked
        ? Colors.white38
        : selected
        ? AppTheme.primaryCyan
        : Colors.white70;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: locked ? null : onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 42),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryBlue.withAlpha(46)
              : Colors.white.withAlpha(14),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppTheme.primaryCyan : Colors.white.withAlpha(28),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 7),
            ],
            Flexible(
              child: Text(
                locked ? '$label - Coming later' : label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageCard extends StatelessWidget {
  final String flag;
  final String name;
  final String subtitle;
  final bool selected;
  final bool locked;
  final bool lockedTapEnabled;
  final VoidCallback? onTap;

  const LanguageCard({
    super.key,
    required this.flag,
    required this.name,
    required this.subtitle,
    required this.selected,
    this.locked = false,
    this.lockedTapEnabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: locked && !lockedTapEnabled ? null : onTap,
      child: GlassCard(
        color: selected
            ? AppTheme.primaryBlue.withAlpha(44)
            : locked
            ? Colors.white.withAlpha(10)
            : AppTheme.glassSurface,
        borderColor: selected
            ? AppTheme.primaryCyan.withAlpha(120)
            : AppTheme.borderGlow,
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                flag,
                maxLines: 1,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    locked
                        ? lockedTapEnabled
                              ? 'Coming later'
                              : 'Already your base language'
                        : subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: locked ? Colors.white38 : Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              locked
                  ? Icons.lock_clock_rounded
                  : selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: locked
                  ? Colors.white38
                  : selected
                  ? AppTheme.primaryCyan
                  : Colors.white38,
            ),
          ],
        ),
      ),
    );
  }
}

class MissionCard extends StatelessWidget {
  final DailyMission mission;
  final VoidCallback? onStart;
  final String buttonLabel;

  const MissionCard({
    super.key,
    required this.mission,
    required this.onStart,
    this.buttonLabel = 'Start Speaking',
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      color: mission.isCompleted
          ? AppTheme.success.withAlpha(22)
          : AppTheme.glassSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppPill(label: mission.category, icon: Icons.flag_rounded),
              const Spacer(),
              AppPill(
                label: '${mission.estimatedMinutes} min',
                icon: Icons.timer_outlined,
                color: AppTheme.warning,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            mission.title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            mission.scenario,
            style: const TextStyle(color: Colors.white70, height: 1.38),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final phrase in mission.targetPhrases.take(4))
                AppPill(
                  label: phrase,
                  icon: Icons.graphic_eq_rounded,
                  color: AppTheme.success,
                  dense: true,
                ),
            ],
          ),
          const SizedBox(height: 18),
          PrimaryActionButton(
            label: mission.isCompleted ? 'Repeat Mission' : buttonLabel,
            icon: mission.isCompleted
                ? Icons.replay_rounded
                : Icons.mic_rounded,
            onPressed: onStart,
          ),
        ],
      ),
    );
  }
}

class CorrectionCard extends StatelessWidget {
  final Correction correction;
  final bool saved;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;
  final String primaryLabel;
  final String secondaryLabel;

  const CorrectionCard({
    super.key,
    required this.correction,
    this.saved = false,
    this.onPrimary,
    this.onSecondary,
    this.primaryLabel = 'Save to Review',
    this.secondaryLabel = 'Say it again',
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppPill(
                label: 'Correction',
                icon: Icons.auto_fix_high_rounded,
              ),
              const Spacer(),
              Icon(
                saved
                    ? Icons.bookmark_added_rounded
                    : Icons.bookmark_add_outlined,
                color: saved ? AppTheme.success : Colors.white54,
              ),
            ],
          ),
          const SizedBox(height: 18),
          _TextCompareLine(
            label: 'You said',
            text: correction.originalText,
            icon: Icons.close_rounded,
            color: Colors.white54,
            strikeThrough: true,
          ),
          const SizedBox(height: 14),
          _TextCompareLine(
            label: 'Corrected',
            text: correction.correctedText,
            icon: Icons.check_rounded,
            color: AppTheme.primaryCyan,
          ),
          const SizedBox(height: 14),
          _TextCompareLine(
            label: 'Natural version',
            text: correction.naturalText,
            icon: Icons.record_voice_over_rounded,
            color: AppTheme.success,
          ),
          const SizedBox(height: 14),
          _CoachNote(correction: correction),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppPill(
                label: 'Confidence ${correction.confidenceScore}%',
                icon: Icons.psychology_alt_rounded,
                color: AppTheme.warning,
                dense: true,
              ),
              AppPill(
                label: 'Pronunciation ${correction.pronunciationScore}%',
                icon: Icons.hearing_rounded,
                color: AppTheme.primaryCyan,
                dense: true,
              ),
              AppPill(
                label: 'Grammar ${correction.grammarScore}%',
                icon: Icons.rule_rounded,
                color: AppTheme.mint,
                dense: true,
              ),
              AppPill(
                label: 'Fluency ${correction.fluencyScore}%',
                icon: Icons.forum_rounded,
                color: AppTheme.primaryViolet,
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: SecondaryActionButton(
                  label: secondaryLabel,
                  icon: Icons.replay_rounded,
                  onPressed: onSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryActionButton(
                  label: saved ? 'Saved' : primaryLabel,
                  icon: saved
                      ? Icons.bookmark_added_rounded
                      : Icons.bookmark_add_rounded,
                  onPressed: onPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TextCompareLine extends StatelessWidget {
  final String label;
  final String text;
  final IconData icon;
  final Color color;
  final bool strikeThrough;

  const _TextCompareLine({
    required this.label,
    required this.text,
    required this.icon,
    required this.color,
    this.strikeThrough = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: TextStyle(
                  color: strikeThrough ? Colors.white54 : Colors.white,
                  fontSize: 16,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                  decoration: strikeThrough ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CoachNote extends StatelessWidget {
  final Correction correction;

  const _CoachNote({required this.correction});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryViolet.withAlpha(34),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryViolet.withAlpha(78)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                color: AppTheme.warning,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                correction.focusArea,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            correction.explanation,
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 8),
          Text(
            correction.coachNote,
            style: const TextStyle(
              color: Colors.white,
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final ReviewItem item;
  final VoidCallback onRepeat;
  final VoidCallback onToggleMastered;
  final VoidCallback onTogglePhrase;

  const ReviewCard({
    super.key,
    required this.item,
    required this.onRepeat,
    required this.onToggleMastered,
    required this.onTogglePhrase,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      color: item.isMastered
          ? AppTheme.success.withAlpha(18)
          : AppTheme.glassSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppPill(
                  label:
                      '${item.baseLanguageName} → ${item.targetLanguageName}',
                  icon: Icons.flag_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _shortDate(item.dateAdded),
                style: const TextStyle(color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.missionTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          AppPill(
            label: 'Learning from: ${item.region}',
            icon: Icons.public_rounded,
            color: AppTheme.mint,
            dense: true,
          ),
          const SizedBox(height: 16),
          _TextCompareLine(
            label: 'You said',
            text: item.correction.originalText,
            icon: Icons.close_rounded,
            color: Colors.white54,
            strikeThrough: true,
          ),
          const SizedBox(height: 12),
          _TextCompareLine(
            label: 'Corrected version',
            text: item.correction.correctedText,
            icon: Icons.check_rounded,
            color: AppTheme.primaryCyan,
          ),
          const SizedBox(height: 12),
          _TextCompareLine(
            label: 'Natural version',
            text: item.correction.naturalText,
            icon: Icons.record_voice_over_rounded,
            color: AppTheme.success,
          ),
          const SizedBox(height: 12),
          Text(
            item.correction.explanation,
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppPill(
                label: item.correction.focusArea,
                icon: Icons.psychology_alt_rounded,
                color: AppTheme.primaryViolet,
                dense: true,
              ),
              AppPill(
                label: 'P ${item.correction.pronunciationScore}',
                icon: Icons.hearing_rounded,
                dense: true,
              ),
              AppPill(
                label: 'G ${item.correction.grammarScore}',
                icon: Icons.rule_rounded,
                color: AppTheme.mint,
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SecondaryActionButton(
                  label: 'Repeat',
                  icon: Icons.mic_rounded,
                  onPressed: onRepeat,
                  compact: true,
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                tooltip: item.isSavedPhrase ? 'Phrase saved' : 'Save phrase',
                onPressed: onTogglePhrase,
                icon: Icon(
                  item.isSavedPhrase
                      ? Icons.bookmark_added_rounded
                      : Icons.bookmark_add_outlined,
                ),
              ),
              const SizedBox(width: 6),
              IconButton.filledTonal(
                tooltip: item.isMastered ? 'Mastered' : 'Mark mastered',
                onPressed: onToggleMastered,
                icon: Icon(
                  item.isMastered
                      ? Icons.check_circle_rounded
                      : Icons.check_circle_outline_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _shortDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$month/$day';
  }
}

class MicOrb extends StatefulWidget {
  final bool isListening;
  final VoidCallback? onTap;
  final double size;
  final String semanticLabel;
  final bool lowPressure;

  const MicOrb({
    super.key,
    required this.isListening,
    required this.onTap,
    this.size = 136,
    this.semanticLabel = 'Microphone',
    this.lowPressure = false,
  });

  @override
  State<MicOrb> createState() => _MicOrbState();
}

class _MicOrbState extends State<MicOrb> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disabledMotion = MediaQuery.disableAnimationsOf(context);
    return Center(
      child: Semantics(
        button: true,
        label: widget.semanticLabel,
        child: Tooltip(
          message: widget.semanticLabel,
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final pulse = widget.isListening && !disabledMotion
                    ? 1 + _controller.value * (widget.lowPressure ? 0.06 : 0.12)
                    : 1.0;

                return Transform.scale(
                  scale: pulse,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.lowPressure
                            ? const [
                                AppTheme.mint,
                                AppTheme.primaryBlue,
                                AppTheme.primaryViolet,
                              ]
                            : const [
                                AppTheme.primaryCyan,
                                AppTheme.primaryBlue,
                                AppTheme.primaryViolet,
                              ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryCyan.withAlpha(
                            widget.isListening ? 132 : 78,
                          ),
                          blurRadius: widget.isListening ? 48 : 30,
                          spreadRadius: widget.isListening ? 8 : 2,
                        ),
                        BoxShadow(
                          color: AppTheme.deepViolet.withAlpha(88),
                          blurRadius: 36,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isListening
                          ? Icons.graphic_eq_rounded
                          : Icons.mic_rounded,
                      color: Colors.white,
                      size: widget.size * 0.40,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

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

class MockPermissionCard extends StatelessWidget {
  final String title;
  final String body;

  const MockPermissionCard({
    super.key,
    this.title = 'Mock voice mode',
    this.body = 'No microphone permission is requested in this frontend demo.',
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      color: AppTheme.primaryBlue.withAlpha(22),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const Icon(Icons.privacy_tip_outlined, color: AppTheme.primaryCyan),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: const TextStyle(color: Colors.white60, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
