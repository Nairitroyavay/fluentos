part of '../speak_tab.dart';

class _FearBreakerPanel extends StatelessWidget {
  final int step;
  final int confidence;
  final VoidCallback onTinyStep;
  final VoidCallback onNervous;

  const _FearBreakerPanel({
    required this.step,
    required this.confidence,
    required this.onTinyStep,
    required this.onNervous,
  });

  static const _steps = [
    'Speak one word',
    'Speak one sentence',
    'Speak for 20 seconds',
    'Speak with guided support',
    'Speak without script',
    'Speak faster',
    'Speak confidently',
  ];

  @override
  Widget build(BuildContext context) {
    final complete = step == _steps.length - 1;

    return GlassCard(
      color: AppTheme.mint.withAlpha(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppPill(
            label: 'Fear Breaker',
            icon: Icons.favorite_outline_rounded,
            color: AppTheme.mint,
          ),
          const SizedBox(height: 16),
          Text(
            _steps[step],
            style: const TextStyle(
              fontSize: 22,
              height: 1.2,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            complete
                ? 'You reached the confident step. Keep the pressure low and repeat once.'
                : 'Tiny steps count. You do not need a perfect sentence to start.',
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: confidence / 100,
                    backgroundColor: Colors.white.withAlpha(24),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.mint,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$confidence%',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ResponsiveActionRow(
            children: [
              SecondaryActionButton(
                label: 'I feel nervous',
                icon: Icons.favorite_border_rounded,
                onPressed: onNervous,
                compact: true,
              ),
              PrimaryActionButton(
                label: complete ? 'Tiny win' : 'Tiny step',
                icon: Icons.arrow_forward_rounded,
                onPressed: onTinyStep,
                compact: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
