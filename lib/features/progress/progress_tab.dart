import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

part 'widgets/fluency_identity_header.dart';
part 'widgets/score_grid.dart';
part 'widgets/weekly_graph.dart';
part 'widgets/skill_breakdown.dart';
part 'widgets/weekly_report.dart';

class ProgressTab extends ConsumerWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final language = ref.watch(languageProvider);
    final progress = ref.watch(progressProvider);
    final snapshots = progress.snapshots;

    if (language == null || snapshots.isEmpty) {
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 118),
          child: EmptyStateCard(
            icon: Icons.insights_rounded,
            title: 'Progress starts after speaking',
            body:
                'Speak your first mission to start building your fluency identity.',
            action: PrimaryActionButton(
              label: 'Go to Today',
              icon: Icons.wb_sunny_outlined,
              onPressed: () => ref.read(mainTabProvider.notifier).setIndex(0),
              compact: true,
            ),
          ),
        ),
      );
    }

    final first = snapshots.first;
    final latest = snapshots.last;
    final weeklyMinutes = latest.speakMinutes;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 118),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FluentHeader(
              title: 'You are becoming a ${language.name} speaker.',
              subtitle:
                  '${language.baseLanguageName} → ${language.name} - ${language.userRegion} - ${user.totalSpeakMinutes} minutes spoken',
              trailing: AppPill(
                label: '${progress.streakDays} day streak',
                icon: Icons.local_fire_department_rounded,
                color: AppTheme.warning,
              ),
            ),
            const SizedBox(height: 20),
            _JourneyContextCard(language: language, progress: progress),
            const SizedBox(height: 18),
            _MainScorePanel(
              progress: progress,
              delta: latest.fluencyScore - first.fluencyScore,
            ),
            const SizedBox(height: 18),
            _ScoreGrid(progress: progress),
            const SizedBox(height: 18),
            _WeeklyGraph(snapshots: snapshots),
            const SizedBox(height: 18),
            _MissionCompletion(progress: progress),
            const SizedBox(height: 18),
            _MistakeImprovement(progress: progress),
            const SizedBox(height: 18),
            _SkillBreakdown(scores: progress.skillScores),
            const SizedBox(height: 18),
            _ConfidenceTimeline(snapshots: snapshots),
            const SizedBox(height: 18),
            _WeeklyReport(
              weeklyMinutes: weeklyMinutes,
              repeatedCorrections: progress.repeatedCorrections,
              language: language.name,
            ),
          ],
        ),
      ),
    );
  }
}
