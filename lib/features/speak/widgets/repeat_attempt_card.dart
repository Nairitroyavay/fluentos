part of '../speak_tab.dart';

class _RepeatAttemptCard extends StatelessWidget {
  final Correction? correction;
  final VoidCallback onFinish;

  const _RepeatAttemptCard({required this.correction, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    final natural = correction?.naturalText ?? 'Repeat the corrected answer.';

    return GlassCard(
      color: AppTheme.primaryBlue.withAlpha(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppPill(label: 'Repeat challenge', icon: Icons.replay_rounded),
          const SizedBox(height: 16),
          Text(
            natural,
            style: const TextStyle(
              fontSize: 20,
              height: 1.3,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Say it once more. The goal is smoother, not louder.',
            style: TextStyle(color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 18),
          PrimaryActionButton(
            label: 'Finish repeat',
            icon: Icons.check_rounded,
            onPressed: onFinish,
          ),
        ],
      ),
    );
  }
}
