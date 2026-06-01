part of 'theme.dart';

class MissionCard extends StatelessWidget {
  final DailyMission mission;
  final VoidCallback? onStart;
  final String buttonLabel;

  const MissionCard({
    super.key,
    required this.mission,
    required this.onStart,
    this.buttonLabel = 'Start Speaking',
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      color: mission.isCompleted
          ? AppTheme.success.withAlpha(22)
          : AppTheme.glassSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppPill(label: mission.category, icon: Icons.flag_rounded),
              const Spacer(),
              AppPill(
                label: '${mission.estimatedMinutes} min',
                icon: Icons.timer_outlined,
                color: AppTheme.warning,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            mission.title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            mission.scenario,
            style: const TextStyle(color: Colors.white70, height: 1.38),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final phrase in mission.targetPhrases.take(4))
                AppPill(
                  label: phrase,
                  icon: Icons.graphic_eq_rounded,
                  color: AppTheme.success,
                  dense: true,
                ),
            ],
          ),
          const SizedBox(height: 18),
          PrimaryActionButton(
            label: mission.isCompleted ? 'Repeat Mission' : buttonLabel,
            icon: mission.isCompleted
                ? Icons.replay_rounded
                : Icons.mic_rounded,
            onPressed: onStart,
          ),
        ],
      ),
    );
  }
}
