import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class ReviewTab extends ConsumerWidget {
  const ReviewTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(reviewsProvider);
    final pendingCount = reviews.where((item) => !item.isMastered).length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 118),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review',
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              '$pendingCount active mistakes',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: reviews.isEmpty
                  ? const _EmptyReviewState()
                  : ListView.separated(
                      itemCount: reviews.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _ReviewCard(item: reviews[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends ConsumerWidget {
  final ReviewItem item;

  const _ReviewCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppPill(
                  label: item.missionTitle,
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
          const SizedBox(height: 16),
          _ReviewLine(
            icon: Icons.close_rounded,
            color: Colors.white54,
            text: item.correction.originalText,
            strikeThrough: true,
          ),
          const SizedBox(height: 10),
          _ReviewLine(
            icon: Icons.check_rounded,
            color: AppTheme.primaryCyan,
            text: item.correction.correctedText,
          ),
          const SizedBox(height: 12),
          Text(
            item.correction.explanation,
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: item.isMastered,
                activeColor: AppTheme.success,
                checkColor: AppTheme.backgroundDark,
                onChanged: (_) {
                  ref.read(reviewsProvider.notifier).toggleMastered(item.id);
                },
              ),
              const Expanded(
                child: Text(
                  'Reviewed',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              AppPill(
                label: item.correction.focusArea,
                icon: Icons.psychology_alt_rounded,
                color: AppTheme.primaryViolet,
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

class _ReviewLine extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final bool strikeThrough;

  const _ReviewLine({
    required this.icon,
    required this.color,
    required this.text,
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
          child: Text(
            text,
            style: TextStyle(
              fontSize: 17,
              height: 1.3,
              fontWeight: FontWeight.w800,
              color: strikeThrough ? Colors.white54 : Colors.white,
              decoration: strikeThrough ? TextDecoration.lineThrough : null,
              decorationColor: Colors.white54,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyReviewState extends StatelessWidget {
  const _EmptyReviewState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: GlassCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_edu_rounded,
              color: AppTheme.primaryCyan,
              size: 42,
            ),
            SizedBox(height: 12),
            Text(
              'No saved mistakes yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}
