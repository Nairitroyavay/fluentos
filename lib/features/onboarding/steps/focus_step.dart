part of '../onboarding_screen.dart';

class _FocusStep extends StatelessWidget {
  final String targetLanguage;

  const _FocusStep({required this.targetLanguage});

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'Focus deeply. Speak better. Switch less.',
      subtitle: 'Speak one language fluently before you split your focus.',
      children: [
        GlassCard(
          color: AppTheme.primaryViolet.withAlpha(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppPill(
                label: '$targetLanguage is your active focus',
                icon: Icons.track_changes_rounded,
              ),
              const SizedBox(height: 18),
              const _FocusRow(
                icon: Icons.center_focus_strong_rounded,
                title: 'One active language free',
                copy:
                    'Your region, base language, daily mission, corrections, and review queue stay aligned.',
              ),
              const SizedBox(height: 14),
              const _FocusRow(
                icon: Icons.diamond_rounded,
                title: 'Pro preview later',
                copy:
                    'Multiple journeys, deeper coaching, and advanced reports are preview-only for now.',
              ),
              const SizedBox(height: 14),
              const _FocusRow(
                icon: Icons.shield_outlined,
                title: 'Private speaking engine first',
                copy:
                    'Global-first. Native-language-aware. Speaking-first. Mock only for now.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FocusRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String copy;

  const _FocusRow({
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
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
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
