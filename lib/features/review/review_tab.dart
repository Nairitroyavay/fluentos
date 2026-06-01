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
    final language = ref.watch(languageProvider);
    final due = reviews.where((item) => !item.isMastered).toList();
    final saved = reviews.where((item) => item.isSavedPhrase).toList();
    final mastered = reviews.where((item) => item.isMastered).toList();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 14),
            sliver: SliverToBoxAdapter(
              child: FluentHeader(
                title: 'Review',
                subtitle: reviews.isEmpty
                    ? 'Your personal correction memory starts after speaking.'
                    : '${due.length} due today - ${mastered.length} mastered',
                trailing: AppPill(
                  label: language?.name ?? 'No language',
                  icon: Icons.history_edu_rounded,
                ),
              ),
            ),
          ),
          if (reviews.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 118),
                child: Center(
                  child: EmptyStateCard(
                    icon: Icons.history_edu_rounded,
                    title: 'Your review queue is empty',
                    body:
                        'Complete your first speaking session to create your personal correction memory.',
                  ),
                ),
              ),
            )
          else ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
              sliver: SliverToBoxAdapter(
                child: _ReviewStats(
                  dueCount: due.length,
                  savedCount: saved.length,
                  masteredCount: mastered.length,
                ),
              ),
            ),
            _ReviewSection(title: 'Due today', items: due),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
              sliver: SliverToBoxAdapter(
                child: _SavedPhrasesCard(items: saved),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
              sliver: SliverToBoxAdapter(
                child: _WeakSoundsCard(language: language, reviews: reviews),
              ),
            ),
            _ReviewSection(title: 'Mastered', items: mastered),
            const SliverPadding(padding: EdgeInsets.only(bottom: 118)),
          ],
        ],
      ),
    );
  }
}

class _ReviewSection extends ConsumerWidget {
  final String title;
  final List<ReviewItem> items;

  const _ReviewSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          SectionTitle(title: title),
          const SizedBox(height: 10),
          if (items.isEmpty)
            EmptyStateCard(
              icon: title == 'Mastered'
                  ? Icons.check_circle_outline_rounded
                  : Icons.mic_none_rounded,
              title: title == 'Mastered'
                  ? 'Nothing mastered yet'
                  : 'Nothing due',
              body: title == 'Mastered'
                  ? 'Repeat a correction and mark it mastered when it feels natural.'
                  : 'Review sentences you actually spoke. Fix mistakes from your own speaking sessions.',
            )
          else
            for (final item in items) ...[
              ReviewCard(
                item: item,
                onRepeat: () {
                  ref.read(reviewsProvider.notifier).markReviewed(item.id);
                  ref.read(mainTabProvider.notifier).setIndex(1);
                },
                onToggleMastered: () {
                  ref.read(reviewsProvider.notifier).toggleMastered(item.id);
                },
                onTogglePhrase: () {
                  ref.read(reviewsProvider.notifier).toggleSavedPhrase(item.id);
                },
              ),
              const SizedBox(height: 12),
            ],
        ]),
      ),
    );
  }
}

class _ReviewStats extends StatelessWidget {
  final int dueCount;
  final int savedCount;
  final int masteredCount;

  const _ReviewStats({
    required this.dueCount,
    required this.savedCount,
    required this.masteredCount,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveMetricGrid(
      minTileWidth: 128,
      children: [
        MetricCard(
          icon: Icons.pending_actions_rounded,
          label: 'due today',
          value: '$dueCount',
          color: AppTheme.warning,
        ),
        MetricCard(
          icon: Icons.bookmark_added_rounded,
          label: 'saved phrases',
          value: '$savedCount',
          color: AppTheme.primaryCyan,
        ),
        MetricCard(
          icon: Icons.check_circle_rounded,
          label: 'mastered',
          value: '$masteredCount',
          color: AppTheme.success,
        ),
      ],
    );
  }
}

class _SavedPhrasesCard extends StatelessWidget {
  final List<ReviewItem> items;

  const _SavedPhrasesCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Saved phrases'),
          const SizedBox(height: 10),
          if (items.isEmpty)
            const Text(
              'Save useful natural versions from review cards. This stays local in the mock app.',
              style: TextStyle(color: Colors.white60, height: 1.35),
            )
          else
            for (final item in items.take(4)) ...[
              _PhraseRow(text: item.correction.naturalText),
              const SizedBox(height: 8),
            ],
        ],
      ),
    );
  }
}

class _WeakSoundsCard extends StatelessWidget {
  final LanguageProfile? language;
  final List<ReviewItem> reviews;

  const _WeakSoundsCard({required this.language, required this.reviews});

  @override
  Widget build(BuildContext context) {
    final weakSounds = language?.weakSounds ?? const <String>[];
    final focusAreas = reviews
        .map((item) => item.correction.focusArea)
        .toSet()
        .take(3)
        .toList();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Weak sounds'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final sound in weakSounds.take(3))
                AppPill(
                  label: sound,
                  icon: Icons.hearing_rounded,
                  color: AppTheme.primaryCyan,
                  dense: true,
                ),
              for (final focus in focusAreas)
                AppPill(
                  label: focus,
                  icon: Icons.psychology_alt_rounded,
                  color: AppTheme.primaryViolet,
                  dense: true,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhraseRow extends StatelessWidget {
  final String text;

  const _PhraseRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(34),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(22)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w800, height: 1.3),
      ),
    );
  }
}
