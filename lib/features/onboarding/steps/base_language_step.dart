part of '../onboarding_screen.dart';

class _BaseLanguageStep extends StatelessWidget {
  final List<LanguageOption> options;
  final String? selectedCode;
  final ValueChanged<String> onSelected;

  const _BaseLanguageStep({
    required this.options,
    required this.selectedCode,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final ordered = [
      'en',
      'hi',
      'bn',
      'ja',
      'de',
      'es',
      'fr',
      'ko',
      'zh',
      'ar',
      'pt',
      'ta',
      'te',
      'mr',
      'kn',
      'ml',
      'it',
      'ru',
      'th',
      'vi',
      'ur',
      'gu',
      'pa',
      'or',
      'as',
      'other',
    ];
    final baseOptions = [
      for (final code in ordered)
        if (options.any((item) => item.code == code))
          options.firstWhere((item) => item.code == code),
    ];

    return _StepScaffold(
      title: 'What language do you think in?',
      subtitle: 'Learn from the language you think in.',
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final option in baseOptions)
              FluentChip(
                label: option.name,
                selected: selectedCode == option.code,
                icon: Icons.language_rounded,
                onTap: () => onSelected(option.code),
              ),
          ],
        ),
      ],
    );
  }
}
