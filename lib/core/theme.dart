import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color backgroundDark = Color(0xFF09090E);
  static const Color backgroundMedium = Color(0xFF13111C);
  static const Color backgroundLight = Color(0xFF1E1A2E);
  static const Color primaryViolet = Color(0xFF8A2BE2);
  static const Color primaryBlue = Color(0xFF4169E1);
  static const Color primaryCyan = Color(0xFF00E5FF);

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryViolet,
        secondary: primaryCyan,
        surface: backgroundMedium,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double width;
  final double? height;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 24.0,
    this.width = double.infinity,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(15),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withAlpha(38),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class LiquidBackground extends StatelessWidget {
  final Widget child;
  const LiquidBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F0C29),
            Color(0xFF302B63),
            Color(0xFF0F0C29),
          ],
        ),
      ),
      child: child,
    );
  }
}
