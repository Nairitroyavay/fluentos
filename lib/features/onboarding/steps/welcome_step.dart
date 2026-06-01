part of '../onboarding_screen.dart';

class _WelcomeStep extends StatelessWidget {
  final VoidCallback onStart;

  const _WelcomeStep({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 42, 24, 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const MicOrb(
                isListening: true,
                onTap: null,
                size: 132,
                semanticLabel: 'FluentOS microphone',
              ),
              const SizedBox(height: 30),
              const Text(
                'FluentOS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Global AI speaking coach',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Learn from the language you think in. Speak one language fluently before you split your focus.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, height: 1.35),
              ),
              const SizedBox(height: 24),
              GlassCard(
                color: AppTheme.primaryBlue.withAlpha(24),
                child: Column(
                  children: const [
                    _LoopPreviewItem(
                      icon: Icons.flag_rounded,
                      label: 'Mission',
                    ),
                    _LoopPreviewItem(icon: Icons.mic_rounded, label: 'Speak'),
                    _LoopPreviewItem(
                      icon: Icons.auto_fix_high_rounded,
                      label: 'Correct',
                    ),
                    _LoopPreviewItem(
                      icon: Icons.replay_rounded,
                      label: 'Repeat',
                    ),
                    _LoopPreviewItem(
                      icon: Icons.history_edu_rounded,
                      label: 'Review',
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoopPreviewItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLast;

  const _LoopPreviewItem({
    required this.icon,
    required this.label,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryCyan),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
