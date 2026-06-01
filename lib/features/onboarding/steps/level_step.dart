part of '../onboarding_screen.dart';

class _LevelStep extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;
  const _LevelStep({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _ChoiceStep(
      title: 'What is your current level?',
      subtitle: 'This sets the starting pressure. You can change it later.',
      options: options,
      selected: selected,
      onSelected: onSelected,
    );
  }
}
