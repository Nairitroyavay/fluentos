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
                constraints: const BoxConstraints(maxWidth: 620),
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
                    const SizedBox(height: 20),
                    const _PremiumOrb(),
                    const SizedBox(height: 26),
                    const Text(
                      'FluentOS Pro Preview',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Free stays focused on one active language. Pro unlocks deeper global speaking practice when you are ready for multiple journeys.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 17,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _FocusPhilosophyCard(),
                    const SizedBox(height: 18),
                    const _PlanCard(
                      title: 'Free',
                      price: '₹0',
                      accent: AppTheme.primaryCyan,
                      features: [
                        '1 active language',
                        'Basic daily missions',
                        'Limited mock AI speaking',
                        'Review queue',
                        'Basic progress',
                      ],
                    ),
                    const SizedBox(height: 14),
                    const _PlanCard(
                      title: 'Pro',
                      price: '₹149/month or local equivalent',
                      accent: AppTheme.primaryViolet,
                      highlighted: true,
                      features: [
                        'Multiple active languages',
                        'Deeper corrections',
                        'Fear Breaker',
                        'Advanced global roleplay packs',
                        'Weekly reports',
                      ],
                    ),
                    const SizedBox(height: 14),
                    const _PlanCard(
                      title: 'Pro Plus',
                      price: '₹299/month or local equivalent',
                      accent: AppTheme.warning,
                      features: [
                        'Advanced fluency tests',
                        'Interview, work, and travel packs',
                        'Downloadable scenario packs',
                        'Early access to future safe practice features',
                      ],
                    ),
                    const SizedBox(height: 14),
                    const _PlanCard(
                      title: 'Early supporter',
                      price: '₹4,999 one-time or local equivalent',
                      accent: AppTheme.success,
                      features: [
                        'Limited-time launch preview',
                        'Founding supporter badge mock',
                        'Future Pro access placeholder',
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Pricing will be localized by region later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    PrimaryActionButton(
                      label: 'Preview Pro',
                      icon: Icons.visibility_rounded,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    SecondaryActionButton(
                      label: 'Coming soon',
                      icon: Icons.lock_clock_rounded,
                      onPressed: null,
                    ),
                    const SizedBox(height: 12),
                    SecondaryActionButton(
                      label: 'Continue free',
                      icon: Icons.arrow_back_rounded,
                      onPressed: () => _close(context),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'No payment SDK is connected in this mock frontend.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white38, fontSize: 12),
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

class _FocusPhilosophyCard extends StatelessWidget {
  const _FocusPhilosophyCard();

  @override
  Widget build(BuildContext context) {
    return const GlassCard(
      color: Color(0x228F5BFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppPill(
            label: 'Focus deeply',
            icon: Icons.center_focus_strong_rounded,
            color: AppTheme.primaryCyan,
          ),
          SizedBox(height: 14),
          Text(
            'Speak one language fluently before you split your focus.',
            style: TextStyle(
              fontSize: 20,
              height: 1.25,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'The free plan is designed around depth, not punishment. Pro is for learners who want multiple active journeys and richer coaching.',
            style: TextStyle(color: Colors.white70, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final Color accent;
  final List<String> features;
  final bool highlighted;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.accent,
    required this.features,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      color: highlighted ? accent.withAlpha(30) : Colors.white.withAlpha(14),
      borderColor: highlighted ? accent.withAlpha(120) : AppTheme.borderGlow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              AppPill(
                label: price,
                icon: Icons.currency_exchange_rounded,
                color: accent,
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final feature in features) ...[
            _FeatureRow(text: feature, accent: accent),
            const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;
  final Color accent;

  const _FeatureRow({required this.text, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_rounded, color: accent, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, height: 1.3),
          ),
        ),
      ],
    );
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
