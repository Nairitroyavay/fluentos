part of 'theme.dart';

class LanguageCard extends StatelessWidget {
  final String flag;
  final String name;
  final String subtitle;
  final bool selected;
  final bool locked;
  final bool lockedTapEnabled;
  final VoidCallback? onTap;

  const LanguageCard({
    super.key,
    required this.flag,
    required this.name,
    required this.subtitle,
    required this.selected,
    this.locked = false,
    this.lockedTapEnabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: locked && !lockedTapEnabled ? null : onTap,
      child: GlassCard(
        color: selected
            ? AppTheme.primaryBlue.withAlpha(44)
            : locked
            ? Colors.white.withAlpha(10)
            : AppTheme.glassSurface,
        borderColor: selected
            ? AppTheme.primaryCyan.withAlpha(120)
            : AppTheme.borderGlow,
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
                flag,
                maxLines: 1,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    locked
                        ? lockedTapEnabled
                              ? 'Coming later'
                              : 'Already your base language'
                        : subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: locked ? Colors.white38 : Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              locked
                  ? Icons.lock_clock_rounded
                  : selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: locked
                  ? Colors.white38
                  : selected
                  ? AppTheme.primaryCyan
                  : Colors.white38,
            ),
          ],
        ),
      ),
    );
  }
}
