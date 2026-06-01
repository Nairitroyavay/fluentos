part of '../onboarding_screen.dart';

class _TargetLanguageStep extends StatelessWidget {
  final List<LanguageOption> options;
  final String? baseCode;
  final String? selectedCode;
  final ValueChanged<String> onSelected;

  const _TargetLanguageStep({
    required this.options,
    required this.baseCode,
    required this.selectedCode,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final ordered = [
      'en',
      'ja',
      'de',
      'hi',
      'bn',
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
      'other',
    ];
    final targets = [
      for (final code in ordered)
        if (options.any((item) => item.code == code))
          options.firstWhere((item) => item.code == code),
    ];

    return _StepScaffold(
      title: 'Which language do you want to speak?',
      subtitle:
          'Supported languages get full mock missions. Preview languages get simpler global practice.',
      children: [
        for (final option in targets) ...[
          Builder(
            builder: (context) {
              final isBase = option.code == baseCode;
              final isComingSoon =
                  option.supportStatus == LanguageSupportStatus.comingSoon;

              return LanguageCard(
                flag: option.flag,
                name: option.name,
                subtitle:
                    '${option.nativeName} - ${option.supportStatus.label} speaking track',
                selected: selectedCode == option.code,
                locked: isBase || isComingSoon,
                lockedTapEnabled: isComingSoon,
                onTap: () {
                  if (isComingSoon) {
                    _showComingSoonMessage(context);
                    return;
                  }
                  if (!isBase) {
                    onSelected(option.code);
                  }
                },
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  void _showComingSoonMessage(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: const Text(
            'This language is coming later. Choose a supported language for this mock demo.',
          ),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        ),
      );
  }
}
