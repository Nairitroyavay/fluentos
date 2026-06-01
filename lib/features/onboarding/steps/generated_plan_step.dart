part of '../onboarding_screen.dart';

class _PlanStep extends StatelessWidget {
  final bool isLoading;
  final List<PlanDay> plan;
  final String targetLanguage;
  final String region;
  final String baseLanguage;

  const _PlanStep({
    required this.isLoading,
    required this.plan,
    required this.targetLanguage,
    required this.region,
    required this.baseLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'Your 7-day $targetLanguage plan',
      subtitle:
          'A speaking plan built from $region, $baseLanguage, your goal, level, confidence, and daily time.',
      children: [
        if (isLoading)
          const GlassCard(
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Creating your first speaking week...',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          )
        else
          for (final day in plan) ...[
            GlassCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primaryCyan.withAlpha(44),
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day.title,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          day.scenario,
                          style: const TextStyle(color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}
