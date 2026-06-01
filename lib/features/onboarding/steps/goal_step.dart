part of '../onboarding_screen.dart';

class _GoalStep extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;

  const _GoalStep({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _ChoiceStep(
      title: 'Why are you learning this language?',
      subtitle: 'Your missions will match the situations you need most.',
      options: options,
      selected: selected,
      onSelected: onSelected,
    );
  }
}

class _ChoiceStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;

  const _ChoiceStep({
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: title,
      subtitle: subtitle,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final option in options)
              FluentChip(
                label: option,
                selected: selected == option,
                onTap: () => onSelected(option),
              ),
          ],
        ),
      ],
    );
  }
}
