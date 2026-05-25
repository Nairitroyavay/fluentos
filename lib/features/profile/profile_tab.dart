import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final language = user.activeLanguage;
    final subscription = ref.watch(subscriptionProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 118),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 20),
            GlassCard(
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
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            GlassCard(
              child: Row(
                children: [
                  Icon(
                    subscription == SubscriptionState.premium
                        ? Icons.diamond_rounded
                        : Icons.lock_open_rounded,
                    color: AppTheme.primaryCyan,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${subscription.label} plan',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'One active language is included.',
                          style: TextStyle(color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                  if (subscription == SubscriptionState.free)
                    IconButton(
                      tooltip: 'Premium preview',
                      onPressed: () => context.push('/premium'),
                      icon: const Icon(Icons.auto_awesome_rounded),
                      color: AppTheme.primaryViolet,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Active language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            if (language == null)
              _NoLanguageCard(onTap: () => context.go('/onboarding'))
            else
              _ActiveLanguageCard(language: language),
            const SizedBox(height: 12),
            _AddLanguageCard(
              subscription: subscription,
              hasActiveLanguage: language != null,
              onTap: () {
                if (subscription == SubscriptionState.free &&
                    language != null) {
                  context.push('/premium');
                  return;
                }

                context.go('/onboarding');
              },
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Speaking target',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 10),
                  AppPill(
                    label: user.speakingGoal,
                    icon: Icons.track_changes_rounded,
                    color: AppTheme.success,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveLanguageCard extends StatelessWidget {
  final LanguageProfile language;

  const _ActiveLanguageCard({required this.language});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withAlpha(46),
              borderRadius: BorderRadius.circular(8),
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
                  language.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${language.nativeName} · ${language.level}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white60),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.check_circle_rounded, color: AppTheme.success),
        ],
      ),
    );
  }
}

class _NoLanguageCard extends StatelessWidget {
  final VoidCallback onTap;

  const _NoLanguageCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: const GlassCard(
        child: Row(
          children: [
            Icon(Icons.language_rounded, color: AppTheme.primaryCyan),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Choose a target language',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}

class _AddLanguageCard extends StatelessWidget {
  final SubscriptionState subscription;
  final bool hasActiveLanguage;
  final VoidCallback onTap;

  const _AddLanguageCard({
    required this.subscription,
    required this.hasActiveLanguage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked =
        subscription == SubscriptionState.free && hasActiveLanguage;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: GlassCard(
        color: isLocked
            ? AppTheme.primaryViolet.withAlpha(28)
            : AppTheme.glassSurface,
        child: Row(
          children: [
            Icon(
              isLocked ? Icons.lock_rounded : Icons.add_circle_outline_rounded,
              color: isLocked ? AppTheme.primaryViolet : AppTheme.primaryCyan,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLocked ? 'Add another language' : 'Add language',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    isLocked
                        ? 'Premium preview'
                        : 'Set your first active language',
                    style: const TextStyle(color: Colors.white60),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
