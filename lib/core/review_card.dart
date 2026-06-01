part of 'theme.dart';

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
