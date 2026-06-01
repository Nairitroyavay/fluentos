part of 'theme.dart';

class FluentHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;

  const FluentHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        final shouldStack =
            trailing != null &&
            (constraints.maxWidth < 390 || textScale > 1.18);

        final copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );

        if (shouldStack) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              copy,
              const SizedBox(height: 10),
              Align(alignment: Alignment.centerLeft, child: trailing!),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: copy),
            if (trailing != null) ...[const SizedBox(width: 12), trailing!],
          ],
        );
      },
    );
  }
}

class PremiumBadge extends StatelessWidget {
  final SubscriptionState subscription;

  const PremiumBadge({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    final isFree = subscription == SubscriptionState.free;
    return AppPill(
      label: subscription.label,
      icon: isFree ? Icons.lock_open_rounded : Icons.diamond_rounded,
      color: isFree ? AppTheme.warning : AppTheme.primaryCyan,
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              actionLabel!,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
      ],
    );
  }
}
