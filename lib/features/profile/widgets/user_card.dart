part of '../profile_tab.dart';

class _UserCard extends StatelessWidget {
  final UserProfile user;
  final LanguageProfile? language;

  const _UserCard({required this.user, required this.language});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppTheme.primaryBlue, AppTheme.primaryViolet],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryCyan.withAlpha(52),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Text(
              user.name.isEmpty ? '?' : user.name[0].toUpperCase(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white60),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    PremiumBadge(subscription: user.subscription),
                    AppPill(
                      label: language?.name ?? 'No active language',
                      icon: Icons.language_rounded,
                      color: AppTheme.primaryCyan,
                      dense: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
