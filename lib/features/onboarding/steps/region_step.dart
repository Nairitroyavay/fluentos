part of '../onboarding_screen.dart';

class _RegionStep extends StatelessWidget {
  final List<String> regions;
  final String? selected;
  final ValueChanged<String> onSelected;

  const _RegionStep({
    required this.regions,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'Where are you learning from?',
      subtitle:
          'We use this to personalize examples, culture, and speaking situations.',
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final region in regions)
              FluentChip(
                label: region,
                selected: selected == region,
                icon: Icons.public_rounded,
                onTap: () => onSelected(region),
              ),
          ],
        ),
      ],
    );
  }
}
