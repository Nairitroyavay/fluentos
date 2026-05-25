import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _step = 0;
  LanguageProfile? _selectedLanguage;
  String _selectedGoal = 'Everyday conversation';

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 2) {
      final nextStep = _step + 1;
      setState(() => _step = nextStep);
      _pageController.animateToPage(
        nextStep,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    final language = _selectedLanguage;
    if (language == null) {
      return;
    }

    ref.read(userProvider.notifier).updateSpeakingGoal(_selectedGoal);
    final didSelect = ref
        .read(userProvider.notifier)
        .selectActiveLanguage(language);

    if (didSelect) {
      context.go('/home');
    } else {
      context.push('/premium');
    }
  }

  @override
  Widget build(BuildContext context) {
    final languages = ref.watch(availableLanguagesProvider);
    _selectedLanguage ??= languages.first;

    return Scaffold(
      body: LiquidBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 8),
                child: _StepProgress(currentStep: _step),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _LanguageStep(
                      languages: languages,
                      selectedLanguage: _selectedLanguage,
                      onSelected: (language) {
                        setState(() => _selectedLanguage = language);
                      },
                    ),
                    _GoalStep(
                      selectedGoal: _selectedGoal,
                      onSelected: (goal) {
                        setState(() => _selectedGoal = goal);
                      },
                    ),
                    _ReadyStep(
                      language: _selectedLanguage!,
                      goal: _selectedGoal,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: PrimaryActionButton(
                    label: _step == 2 ? 'Enter FluentOS' : 'Continue',
                    icon: _step == 2
                        ? Icons.keyboard_voice_rounded
                        : Icons.arrow_forward_rounded,
                    onPressed: _next,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  final int currentStep;

  const _StepProgress({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < 3; index++) ...[
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 5,
              decoration: BoxDecoration(
                color: index <= currentStep
                    ? AppTheme.primaryCyan
                    : Colors.white.withAlpha(34),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          if (index != 2) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _LanguageStep extends StatelessWidget {
  final List<LanguageProfile> languages;
  final LanguageProfile? selectedLanguage;
  final ValueChanged<LanguageProfile> onSelected;

  const _LanguageStep({
    required this.languages,
    required this.selectedLanguage,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose your active language.',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.08,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Free accounts focus on one target language at a time.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              for (final language in languages) ...[
                _LanguageCard(
                  language: language,
                  isSelected: selectedLanguage?.id == language.id,
                  onTap: () => onSelected(language),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final LanguageProfile language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: GlassCard(
        color: isSelected
            ? AppTheme.primaryBlue.withAlpha(42)
            : AppTheme.glassSurface,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                language.flag,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${language.nativeName} · ${language.focus}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white60),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected ? AppTheme.primaryCyan : Colors.white38,
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalStep extends StatelessWidget {
  final String selectedGoal;
  final ValueChanged<String> onSelected;

  const _GoalStep({required this.selectedGoal, required this.onSelected});

  static const List<String> _goals = [
    'Everyday conversation',
    'Travel confidence',
    'Work meetings',
    'Family calls',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pick the speaking target.',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.08,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Missions will stay practical and short.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              for (final goal in _goals) ...[
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => onSelected(goal),
                  child: GlassCard(
                    color: selectedGoal == goal
                        ? AppTheme.primaryViolet.withAlpha(44)
                        : AppTheme.glassSurface,
                    child: Row(
                      children: [
                        Icon(
                          _iconForGoal(goal),
                          color: selectedGoal == goal
                              ? AppTheme.primaryCyan
                              : Colors.white54,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            goal,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Icon(
                          selectedGoal == goal
                              ? Icons.check_circle_rounded
                              : Icons.chevron_right_rounded,
                          color: selectedGoal == goal
                              ? AppTheme.primaryCyan
                              : Colors.white38,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForGoal(String goal) {
    switch (goal) {
      case 'Travel confidence':
        return Icons.flight_takeoff_rounded;
      case 'Work meetings':
        return Icons.work_outline_rounded;
      case 'Family calls':
        return Icons.call_rounded;
      case 'Everyday conversation':
      default:
        return Icons.forum_rounded;
    }
  }
}

class _ReadyStep extends StatelessWidget {
  final LanguageProfile language;
  final String goal;

  const _ReadyStep({required this.language, required this.goal});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your speaking OS is set.',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.08,
                ),
              ),
              const SizedBox(height: 22),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppPill(
                      label: '${language.name} · ${language.level}',
                      icon: Icons.language_rounded,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      goal,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _LoopRow(
                      icon: Icons.flag_rounded,
                      title: 'Mission',
                      copy: 'One concrete speaking task each day.',
                    ),
                    const SizedBox(height: 12),
                    const _LoopRow(
                      icon: Icons.mic_rounded,
                      title: 'Speak',
                      copy: 'Answer the scene out loud.',
                    ),
                    const SizedBox(height: 12),
                    const _LoopRow(
                      icon: Icons.rate_review_rounded,
                      title: 'Correct',
                      copy: 'Turn mistakes into review cards.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoopRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String copy;

  const _LoopRow({required this.icon, required this.title, required this.copy});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.primaryCyan, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(
                context,
              ).style.copyWith(color: Colors.white70, height: 1.35),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(text: copy),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
