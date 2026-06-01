part of 'theme.dart';

class GradientPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool dense;

  const GradientPill({
    super.key,
    required this.label,
    required this.icon,
    this.color = AppTheme.primaryCyan,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = math.max(96.0, MediaQuery.sizeOf(context).width - 64);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? 9 : 11,
          vertical: dense ? 6 : 7,
        ),
        decoration: BoxDecoration(
          color: color.withAlpha(28),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withAlpha(86)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: dense ? 14 : 15, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: dense ? 11 : 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppPill extends GradientPill {
  const AppPill({
    super.key,
    required super.label,
    required super.icon,
    super.color,
    super.dense,
  });
}

class FluentChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool locked;
  final VoidCallback? onTap;
  final IconData? icon;

  const FluentChip({
    super.key,
    required this.label,
    this.selected = false,
    this.locked = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = locked
        ? Colors.white38
        : selected
        ? AppTheme.primaryCyan
        : Colors.white70;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: locked ? null : onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 42),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryBlue.withAlpha(46)
              : Colors.white.withAlpha(14),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppTheme.primaryCyan : Colors.white.withAlpha(28),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 7),
            ],
            Flexible(
              child: Text(
                locked ? '$label - Coming later' : label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
