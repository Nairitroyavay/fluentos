import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

part 'steps/welcome_step.dart';
part 'steps/region_step.dart';
part 'steps/base_language_step.dart';
part 'steps/target_language_step.dart';
part 'steps/goal_step.dart';
part 'steps/level_step.dart';
part 'steps/confidence_step.dart';
part 'steps/daily_time_step.dart';
part 'steps/voice_baseline_step.dart';
part 'steps/generated_plan_step.dart';
part 'steps/focus_step.dart';

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

    final plan = ref.read(missionEngineProvider).generateSevenDayPlan(profile);
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
    final repository = ref.read(languageRepositoryProvider);
    final language = repository.createLanguageProfile(
      ref.read(userProvider).id,
      profile,
    );

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
    final repository = ref.read(languageRepositoryProvider);
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
                    _GoalStep(
                      options: _goals,
                      selected: _goal,
                      onSelected: (value) {
                        setState(() {
                          _goal = value;
                          _showWarning = false;
                        });
                      },
                    ),
                    _LevelStep(
                      options: _levels,
                      selected: _level,
                      onSelected: (value) {
                        setState(() {
                          _level = value;
                          _showWarning = false;
                        });
                      },
                    ),
                    _ConfidenceStep(
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
