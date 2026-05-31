import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

enum _VoiceStepState { idle, listening, analyzing, done }

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _step = 0;
  String? _userRegion;
  String? _baseLanguageCode;
  String? _targetLanguageCode;
  String? _goal;
  String? _level;
  String? _confidence;
  int? _dailyMinutes;
  bool _customTime = false;
  bool _showWarning = false;
  bool _isGeneratingPlan = false;
  _VoiceStepState _voiceState = _VoiceStepState.idle;
  VoiceBaseline? _voiceBaseline;
  List<PlanDay> _generatedPlan = const [];

  static const _regions = [
    'United States',
    'India',
    'Japan',
    'Germany',
    'United Kingdom',
    'Canada',
    'Australia',
    'Brazil',
    'Korea',
    'France',
    'Spain',
    'Mexico',
    'UAE',
    'Saudi Arabia',
    'Singapore',
    'Other',
  ];

  static const _goals = [
    'College',
    'Job',
    'Travel',
    'Exam',
    'Friends / family',
    'Moving abroad',
    'Anime / movies / culture',
    'Business',
    'Self-improvement',
  ];

  static const _levels = [
    'I know nothing',
    'I know some words',
    'I understand but cannot speak',
    'I can speak broken sentences',
    'Intermediate',
    'Advanced',
  ];

  static const _confidenceLevels = [
    'Very shy',
    'A little nervous',
    'Okay',
    'Confident',
    'Very confident',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (!_canContinue()) {
      setState(() => _showWarning = true);
      return;
    }

    if (_step == 10) {
      _finishOnboarding();
      return;
    }

    final next = _step + 1;
    setState(() {
      _step = next;
      _showWarning = false;
    });
    await _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );

    if (next == 9 && _generatedPlan.isEmpty) {
      await _generatePlan();
    }
  }

  void _back() {
    if (_step == 0) {
      return;
    }

    final previous = _step - 1;
    setState(() {
      _step = previous;
      _showWarning = false;
    });
    _pageController.animateToPage(
      previous,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  bool _canContinue() {
    switch (_step) {
      case 0:
        return true;
      case 1:
        return _userRegion != null;
      case 2:
        return _baseLanguageCode != null;
      case 3:
        return _targetLanguageCode != null &&
            _targetLanguageCode != _baseLanguageCode;
      case 4:
        return _goal != null;
      case 5:
        return _level != null;
      case 6:
        return _confidence != null;
      case 7:
        return _dailyMinutes != null;
      case 8:
        return _voiceBaseline != null;
      case 9:
        return _generatedPlan.isNotEmpty && !_isGeneratingPlan;
      case 10:
        return true;
      default:
        return false;
    }
  }

  String _warningText() {
    switch (_step) {
      case 3:
        if (_targetLanguageCode == _baseLanguageCode) {
          return 'Base language and target language should be different.';
        }
        return 'Choose a supported or preview target language.';
      case 8:
        return 'Run the mock voice baseline before continuing.';
      default:
        return 'Choose an option to continue.';
    }
  }

  Future<void> _startVoiceTest() async {
    if (_voiceState == _VoiceStepState.analyzing) {
      return;
    }

    setState(() => _voiceState = _VoiceStepState.listening);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) {
      return;
    }
    setState(() => _voiceState = _VoiceStepState.analyzing);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) {
      return;
    }

    final confidence = _confidence ?? 'A little nervous';
    final isNervous =
        confidence == 'Very shy' || confidence == 'A little nervous';
    setState(() {
      _voiceBaseline = VoiceBaseline(
        pronunciationScore: isNervous ? 54 : 68,
        confidenceScore: isNervous ? 42 : 64,
        speed: isNervous ? 'Careful and slow' : 'Natural pace',
        firstWeakArea: isNervous ? 'sentence endings' : 'word stress',
      );
      _voiceState = _VoiceStepState.done;
      _showWarning = false;
    });
  }

  Future<void> _generatePlan() async {
    final profile = _buildOnboardingProfile(
      voiceBaseline: _voiceBaseline ?? _fallbackBaseline(),
      plan: const [],
    );
    setState(() => _isGeneratingPlan = true);
    await Future<void>.delayed(const Duration(milliseconds: 850));
    if (!mounted) {
      return;
    }

    final plan = ref
        .read(fakeMissionEngineProvider)
        .generateSevenDayPlan(profile);
    setState(() {
      _generatedPlan = plan;
      _isGeneratingPlan = false;
    });
  }

  void _finishOnboarding() {
    final baseline = _voiceBaseline ?? _fallbackBaseline();
    final profile = _buildOnboardingProfile(
      voiceBaseline: baseline,
      plan: _generatedPlan,
    );
    final repository = ref.read(fakeRepositoryProvider);
    final language = repository.createLanguageProfile(profile);

    ref.read(onboardingProvider.notifier).save(profile);
    ref
        .read(userProvider.notifier)
        .completeOnboarding(profile: profile, language: language);
    ref
        .read(dailyMissionsProvider.notifier)
        .createFor(profile: profile, language: language);
    ref
        .read(progressProvider.notifier)
        .initialize(profile: profile, language: language);
    ref.read(reviewsProvider.notifier).clear();

    final mission = ref.read(dailyMissionProvider);
    if (mission != null) {
      ref.read(speakSessionProvider.notifier).startMission(mission);
    }

    context.go('/home');
  }

  OnboardingProfile _buildOnboardingProfile({
    required VoiceBaseline voiceBaseline,
    required List<PlanDay> plan,
  }) {
    final options = ref.read(languageOptionsProvider);
    final repository = ref.read(fakeRepositoryProvider);
    final base = options.firstWhere((item) => item.code == _baseLanguageCode);
    final target = options.firstWhere(
      (item) => item.code == _targetLanguageCode,
    );
    final region = _userRegion ?? 'United States';

    return OnboardingProfile(
      userRegion: region,
      baseLanguageCode: base.code,
      baseLanguageName: base.name,
      targetLanguageCode: target.code,
      targetLanguageName: target.name,
      targetCulture: repository.targetCultureFor(target, region),
      learningGoal: _goal ?? 'Self-improvement',
      currentLevel: _level ?? 'I know some words',
      speakingConfidence: _confidence ?? 'A little nervous',
      dailyMinutes: _dailyMinutes ?? 10,
      accentPreference: repository.accentPreferenceFor(target, region),
      onboardingCompleted: true,
      voiceBaseline: voiceBaseline,
      sevenDayPlan: plan,
    );
  }

  VoiceBaseline _fallbackBaseline() {
    return const VoiceBaseline(
      pronunciationScore: 58,
      confidenceScore: 46,
      speed: 'Careful and slow',
      firstWeakArea: 'sentence endings',
    );
  }

  @override
  Widget build(BuildContext context) {
    final baseOptions = ref.watch(baseLanguageOptionsProvider);
    final targetOptions = ref.watch(targetLanguageOptionsProvider);

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
                    _WelcomeStep(onStart: _next),
                    _RegionStep(
                      regions: _regions,
                      selected: _userRegion,
                      onSelected: (region) {
                        setState(() {
                          _userRegion = region;
                          _showWarning = false;
                        });
                      },
                    ),
                    _BaseLanguageStep(
                      options: baseOptions,
                      selectedCode: _baseLanguageCode,
                      onSelected: (code) {
                        setState(() {
                          _baseLanguageCode = code;
                          if (_targetLanguageCode == code) {
                            _targetLanguageCode = null;
                          }
                          _showWarning = false;
                        });
                      },
                    ),
                    _TargetLanguageStep(
                      options: targetOptions,
                      baseCode: _baseLanguageCode,
                      selectedCode: _targetLanguageCode,
                      onSelected: (code) {
                        setState(() {
                          _targetLanguageCode = code;
                          _showWarning = false;
                        });
                      },
                    ),
                    _ChoiceStep(
                      title: 'Why are you learning this language?',
                      subtitle:
                          'Your missions will match the situations you need most.',
                      options: _goals,
                      selected: _goal,
                      onSelected: (value) {
                        setState(() {
                          _goal = value;
                          _showWarning = false;
                        });
                      },
                    ),
                    _ChoiceStep(
                      title: 'What is your current level?',
                      subtitle:
                          'This sets the starting pressure. You can change it later.',
                      options: _levels,
                      selected: _level,
                      onSelected: (value) {
                        setState(() {
                          _level = value;
                          _showWarning = false;
                        });
                      },
                    ),
                    _ChoiceStep(
                      title: 'How comfortable are you speaking out loud?',
                      subtitle:
                          'Many learners know words but freeze. FluentOS trains that moment.',
                      options: _confidenceLevels,
                      selected: _confidence,
                      onSelected: (value) {
                        setState(() {
                          _confidence = value;
                          _showWarning = false;
                        });
                      },
                    ),
                    _DailyTimeStep(
                      selectedMinutes: _dailyMinutes,
                      customTime: _customTime,
                      onSelected: (minutes, isCustom) {
                        setState(() {
                          _dailyMinutes = minutes;
                          _customTime = isCustom;
                          _showWarning = false;
                        });
                      },
                    ),
                    _VoiceBaselineStep(
                      voiceState: _voiceState,
                      baseline: _voiceBaseline,
                      onStart: _startVoiceTest,
                    ),
                    _PlanStep(
                      isLoading: _isGeneratingPlan,
                      plan: _generatedPlan,
                      targetLanguage: _targetLanguageName(targetOptions),
                      region: _userRegion ?? 'your region',
                      baseLanguage: _baseLanguageName(baseOptions),
                    ),
                    _FocusStep(
                      targetLanguage: _targetLanguageName(targetOptions),
                    ),
                  ],
                ),
              ),
              if (_showWarning)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Text(
                    _warningText(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.warning,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Row(
                    children: [
                      if (_step > 0) ...[
                        SizedBox(
                          width: 54,
                          height: 54,
                          child: IconButton.filledTonal(
                            tooltip: 'Back',
                            onPressed: _back,
                            icon: const Icon(Icons.arrow_back_rounded),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: PrimaryActionButton(
                          label: _buttonLabel(),
                          icon: _buttonIcon(),
                          onPressed: _isGeneratingPlan ? null : _next,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _targetLanguageName(List<LanguageOption> options) {
    final selected = _targetLanguageCode;
    if (selected == null) {
      return 'your target language';
    }
    return options.firstWhere((item) => item.code == selected).name;
  }

  String _baseLanguageName(List<LanguageOption> options) {
    final selected = _baseLanguageCode;
    if (selected == null) {
      return 'your base language';
    }
    return options.firstWhere((item) => item.code == selected).name;
  }

  String _buttonLabel() {
    switch (_step) {
      case 0:
        return 'Start my fluency journey';
      case 8:
        return _voiceBaseline == null
            ? 'Continue after voice test'
            : 'Continue';
      case 10:
        return 'Enter FluentOS';
      default:
        return 'Continue';
    }
  }

  IconData _buttonIcon() {
    switch (_step) {
      case 0:
        return Icons.keyboard_voice_rounded;
      case 8:
        return Icons.graphic_eq_rounded;
      case 10:
        return Icons.arrow_forward_rounded;
      default:
        return Icons.arrow_forward_rounded;
    }
  }
}

class _StepProgress extends StatelessWidget {
  final int currentStep;

  const _StepProgress({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < 11; index++) ...[
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 5,
              decoration: BoxDecoration(
                color: index <= currentStep
                    ? AppTheme.primaryCyan
                    : Colors.white.withAlpha(34),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          if (index != 10) const SizedBox(width: 5),
        ],
      ],
    );
  }
}

class _StepScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const _StepScaffold({
    required this.title,
    required this.subtitle,
    required this.children,
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1.08,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  final VoidCallback onStart;

  const _WelcomeStep({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 42, 24, 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const MicOrb(
                isListening: true,
                onTap: null,
                size: 132,
                semanticLabel: 'FluentOS microphone',
              ),
              const SizedBox(height: 30),
              const Text(
                'FluentOS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Global AI speaking coach',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Learn from the language you think in. Speak one language fluently before you split your focus.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, height: 1.35),
              ),
              const SizedBox(height: 24),
              GlassCard(
                color: AppTheme.primaryBlue.withAlpha(24),
                child: Column(
                  children: const [
                    _LoopPreviewItem(
                      icon: Icons.flag_rounded,
                      label: 'Mission',
                    ),
                    _LoopPreviewItem(icon: Icons.mic_rounded, label: 'Speak'),
                    _LoopPreviewItem(
                      icon: Icons.auto_fix_high_rounded,
                      label: 'Correct',
                    ),
                    _LoopPreviewItem(
                      icon: Icons.replay_rounded,
                      label: 'Repeat',
                    ),
                    _LoopPreviewItem(
                      icon: Icons.history_edu_rounded,
                      label: 'Review',
                      isLast: true,
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

class _LoopPreviewItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLast;

  const _LoopPreviewItem({
    required this.icon,
    required this.label,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryCyan),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

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

class _DailyTimeStep extends StatelessWidget {
  final int? selectedMinutes;
  final bool customTime;
  final void Function(int minutes, bool isCustom) onSelected;

  const _DailyTimeStep({
    required this.selectedMinutes,
    required this.customTime,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'How much time can you practice daily?',
      subtitle: 'Short daily speaking beats long occasional lessons.',
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final minutes in [5, 10, 15, 30])
              FluentChip(
                label: '$minutes min',
                selected: selectedMinutes == minutes && !customTime,
                icon: Icons.timer_outlined,
                onTap: () => onSelected(minutes, false),
              ),
            FluentChip(
              label: 'Custom',
              selected: customTime,
              icon: Icons.tune_rounded,
              onTap: () => onSelected(20, true),
            ),
          ],
        ),
        if (customTime) ...[
          const SizedBox(height: 22),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Custom daily time',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                Slider(
                  value: (selectedMinutes ?? 20).toDouble(),
                  min: 5,
                  max: 45,
                  divisions: 8,
                  label: '${selectedMinutes ?? 20} min',
                  onChanged: (value) => onSelected(value.round(), true),
                ),
                Text(
                  '${selectedMinutes ?? 20} minutes per day',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _VoiceBaselineStep extends StatelessWidget {
  final _VoiceStepState voiceState;
  final VoiceBaseline? baseline;
  final VoidCallback onStart;

  const _VoiceBaselineStep({
    required this.voiceState,
    required this.baseline,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final isActive =
        voiceState == _VoiceStepState.listening ||
        voiceState == _VoiceStepState.analyzing;

    return _StepScaffold(
      title: 'Read this sentence out loud.',
      subtitle: '"Hello, my name is Roy. I want to speak confidently."',
      children: [
        const MockPermissionCard(),
        const SizedBox(height: 22),
        MicOrb(
          isListening: isActive,
          onTap: onStart,
          semanticLabel: 'Start mock voice baseline',
        ),
        const SizedBox(height: 18),
        WaveformMock(active: isActive),
        const SizedBox(height: 16),
        Center(
          child: Text(
            _voiceStatus,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 22),
        if (baseline == null)
          SecondaryActionButton(
            label: 'Tap to record mock baseline',
            icon: Icons.mic_rounded,
            onPressed: onStart,
          )
        else
          GlassCard(
            color: AppTheme.success.withAlpha(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(title: 'Baseline results'),
                const SizedBox(height: 12),
                _BaselineRow(
                  label: 'Pronunciation',
                  value: '${baseline!.pronunciationScore}%',
                ),
                _BaselineRow(
                  label: 'Confidence',
                  value: '${baseline!.confidenceScore}%',
                ),
                _BaselineRow(label: 'Speed', value: baseline!.speed),
                _BaselineRow(
                  label: 'First weak area',
                  value: baseline!.firstWeakArea,
                ),
              ],
            ),
          ),
      ],
    );
  }

  String get _voiceStatus {
    switch (voiceState) {
      case _VoiceStepState.idle:
        return 'Tap the orb. This is visual only.';
      case _VoiceStepState.listening:
        return 'Listening...';
      case _VoiceStepState.analyzing:
        return 'Analyzing your mock baseline...';
      case _VoiceStepState.done:
        return 'Baseline ready.';
    }
  }
}

class _BaselineRow extends StatelessWidget {
  final String label;
  final String value;

  const _BaselineRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white60)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _PlanStep extends StatelessWidget {
  final bool isLoading;
  final List<PlanDay> plan;
  final String targetLanguage;
  final String region;
  final String baseLanguage;

  const _PlanStep({
    required this.isLoading,
    required this.plan,
    required this.targetLanguage,
    required this.region,
    required this.baseLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'Your 7-day $targetLanguage plan',
      subtitle:
          'A speaking plan built from $region, $baseLanguage, your goal, level, confidence, and daily time.',
      children: [
        if (isLoading)
          const GlassCard(
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Creating your first speaking week...',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          )
        else
          for (final day in plan) ...[
            GlassCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primaryCyan.withAlpha(44),
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day.title,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          day.scenario,
                          style: const TextStyle(color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}

class _FocusStep extends StatelessWidget {
  final String targetLanguage;

  const _FocusStep({required this.targetLanguage});

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'Focus deeply. Speak better. Switch less.',
      subtitle: 'Speak one language fluently before you split your focus.',
      children: [
        GlassCard(
          color: AppTheme.primaryViolet.withAlpha(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppPill(
                label: '$targetLanguage is your active focus',
                icon: Icons.track_changes_rounded,
              ),
              const SizedBox(height: 18),
              const _FocusRow(
                icon: Icons.center_focus_strong_rounded,
                title: 'One active language free',
                copy:
                    'Your region, base language, daily mission, corrections, and review queue stay aligned.',
              ),
              const SizedBox(height: 14),
              const _FocusRow(
                icon: Icons.diamond_rounded,
                title: 'Pro preview later',
                copy:
                    'Multiple journeys, deeper coaching, and advanced reports are preview-only for now.',
              ),
              const SizedBox(height: 14),
              const _FocusRow(
                icon: Icons.shield_outlined,
                title: 'Private speaking engine first',
                copy:
                    'Global-first. Native-language-aware. Speaking-first. Mock only for now.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FocusRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String copy;

  const _FocusRow({
    required this.icon,
    required this.title,
    required this.copy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.primaryCyan),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(
                copy,
                style: const TextStyle(color: Colors.white60, height: 1.35),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
