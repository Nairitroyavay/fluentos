part of '../onboarding_screen.dart';

class _ConfidenceStep extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;
  const _ConfidenceStep({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _ChoiceStep(
      title: 'How comfortable are you speaking out loud?',
      subtitle:
          'Many learners know words but freeze. FluentOS trains that moment.',
      options: options,
      selected: selected,
      onSelected: onSelected,
    );
  }
}
