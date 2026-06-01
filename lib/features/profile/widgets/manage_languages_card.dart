part of '../profile_tab.dart';

class _ManageLanguagesCard extends StatelessWidget {
  final SubscriptionState subscription;
  final LanguageProfile? language;
  final VoidCallback onAdd;

  const _ManageLanguagesCard({
    required this.subscription,
    required this.language,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final locked = subscription == SubscriptionState.free && language != null;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Manage languages'),
          const SizedBox(height: 12),
          if (language == null)
            const Text(
              'No active language yet.',
              style: TextStyle(color: Colors.white60),
            )
          else
            _LanguageJourneyRow(language: language!),
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onAdd,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: locked
                    ? AppTheme.primaryViolet.withAlpha(26)
                    : Colors.white.withAlpha(12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withAlpha(24)),
              ),
              child: Row(
                children: [
                  Icon(
                    locked
                        ? Icons.lock_rounded
                        : Icons.add_circle_outline_rounded,
                    color: locked ? AppTheme.warning : AppTheme.primaryCyan,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locked ? 'Add second language' : 'Add language',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          locked
                              ? 'Free learners focus on one active language. Pro unlocks multiple active language journeys.'
                              : 'Create another focused speaking journey.',
                          style: const TextStyle(
                            color: Colors.white60,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white54,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageJourneyRow extends StatelessWidget {
  final LanguageProfile language;

  const _LanguageJourneyRow({required this.language});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryCyan.withAlpha(72)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              language.flag,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${language.baseLanguageName} → ${language.name}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Learning from ${language.userRegion} - ${language.goal}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white60, height: 1.3),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: AppTheme.success),
        ],
      ),
    );
  }
}
