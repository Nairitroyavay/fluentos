part of 'theme.dart';

class PrimaryActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool compact;

  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: compact ? 46 : 54,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: compact ? 18 : 20),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryViolet,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.white.withAlpha(20),
          disabledForegroundColor: Colors.white38,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: compact ? 14 : 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class SecondaryActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool compact;

  const SecondaryActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: compact ? 44 : 50,
      child: OutlinedButton.icon(
        icon: Icon(icon, size: compact ? 18 : 19),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white.withAlpha(48)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: compact ? 14 : 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class ResponsiveActionRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double breakpoint;

  const ResponsiveActionRow({
    super.key,
    required this.children,
    this.spacing = 12,
    this.breakpoint = 390,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        final shouldStack =
            constraints.maxWidth < breakpoint || textScale > 1.2;

        if (shouldStack) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index != children.length - 1) SizedBox(height: spacing),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (var index = 0; index < children.length; index++) ...[
              Expanded(child: children[index]),
              if (index != children.length - 1) SizedBox(width: spacing),
            ],
          ],
        );
      },
    );
  }
}
