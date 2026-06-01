part of '../speak_tab.dart';

class _ScenarioCard extends StatelessWidget {
  final SpeakSession session;
  final DailyMission mission;

  const _ScenarioCard({required this.session, required this.mission});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppPill(label: session.mode.label, icon: Icons.tune_rounded),
              AppPill(
                label: mission.focusArea,
                icon: Icons.psychology_alt_rounded,
                color: AppTheme.warning,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            session.scenarioPrompt,
            style: const TextStyle(
              fontSize: 20,
              height: 1.25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(48),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withAlpha(22)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.record_voice_over_rounded,
                  color: AppTheme.primaryCyan,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    session.coachPrompt,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.35,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlobalRoleplayExamples extends StatelessWidget {
  const _GlobalRoleplayExamples();

  static const _examples = [
    'Job interview in English',
    'Japanese travel introduction',
    'German train station help',
    'English global workplace meeting',
    'Korean culture conversation',
    'French cafe order',
    'Spanish travel help',
    'Hindi local conversation',
    'Bengali friend conversation',
  ];

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final example in _examples)
            AppPill(
              label: example,
              icon: Icons.theater_comedy_rounded,
              color: AppTheme.primaryCyan,
              dense: true,
            ),
        ],
      ),
    );
  }
}
