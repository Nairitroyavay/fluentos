part of 'theme.dart';

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
          ResponsiveActionRow(
            children: [
              SecondaryActionButton(
                label: secondaryLabel,
                icon: Icons.replay_rounded,
                onPressed: onSecondary,
              ),
              PrimaryActionButton(
                label: saved ? 'Saved' : primaryLabel,
                icon: saved
                    ? Icons.bookmark_added_rounded
                    : Icons.bookmark_add_rounded,
                onPressed: onPrimary,
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
