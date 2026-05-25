import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';

class PremiumPreviewScreen extends StatelessWidget {
  const PremiumPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton.filledTonal(
                        tooltip: 'Back',
                        onPressed: () => _close(context),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                    ),
                    const SizedBox(height: 26),
                    const _PremiumOrb(),
                    const SizedBox(height: 28),
                    const Text(
                      'FluentOS Premium',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Multiple active languages are reserved for Premium.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 17,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 26),
                    GlassCard(
                      color: AppTheme.primaryViolet.withAlpha(28),
                      child: const Column(
                        children: [
                          _PremiumFeature(
                            icon: Icons.language_rounded,
                            title: 'Multiple target languages',
                            copy: 'Switch without losing your active tracks.',
                          ),
                          SizedBox(height: 16),
                          _PremiumFeature(
                            icon: Icons.all_inclusive_rounded,
                            title: 'Unlimited speaking missions',
                            copy: 'More scenarios for repeat practice.',
                          ),
                          SizedBox(height: 16),
                          _PremiumFeature(
                            icon: Icons.auto_fix_high_rounded,
                            title: 'Deeper corrections',
                            copy: 'Expanded notes for grammar and tone.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryActionButton(
                      label: 'Preview only',
                      icon: Icons.visibility_rounded,
                      onPressed: () => _close(context),
                    ),
                    const SizedBox(height: 12),
                    SecondaryActionButton(
                      label: 'Maybe later',
                      icon: Icons.close_rounded,
                      onPressed: () => _close(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _close(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go('/home');
  }
}

class _PremiumOrb extends StatelessWidget {
  const _PremiumOrb();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 124,
        height: 124,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryCyan,
              AppTheme.primaryBlue,
              AppTheme.primaryViolet,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryCyan.withAlpha(84),
              blurRadius: 44,
              spreadRadius: 4,
            ),
            BoxShadow(
              color: AppTheme.primaryViolet.withAlpha(92),
              blurRadius: 60,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: const Icon(Icons.diamond_rounded, color: Colors.white, size: 52),
      ),
    );
  }
}

class _PremiumFeature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String copy;

  const _PremiumFeature({
    required this.icon,
    required this.title,
    required this.copy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.primaryCyan),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                copy,
                style: const TextStyle(color: Colors.white60, height: 1.35),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
