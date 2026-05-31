import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class SpeakTab extends ConsumerStatefulWidget {
  const SpeakTab({super.key});

  @override
  ConsumerState<SpeakTab> createState() => _SpeakTabState();
}

class _SpeakTabState extends ConsumerState<SpeakTab> {
  SpeakMode _selectedMode = SpeakMode.dailyMission;
  int _fearStep = 0;
  int _fearConfidence = 38;

  void _selectMode(SpeakMode mode, DailyMission? mission) {
    setState(() {
      _selectedMode = mode;
      if (mode != SpeakMode.fearBreaker) {
        _fearStep = 0;
      }
    });
    ref.read(speakSessionProvider.notifier).changeMode(mode, mission);
  }

  void _handleMic({
    required SpeakSession session,
    required DailyMission mission,
    required LanguageProfile language,
  }) {
    final notifier = ref.read(speakSessionProvider.notifier);

    switch (session.phase) {
      case SpeakSessionPhase.ready:
        notifier.startListening();
        return;
      case SpeakSessionPhase.listening:
        notifier.finishListening(mission: mission, language: language);
        return;
      case SpeakSessionPhase.repeatAttempt:
        notifier.finishRepeatAttempt();
        return;
      case SpeakSessionPhase.transcriptReady:
      case SpeakSessionPhase.corrected:
      case SpeakSessionPhase.completed:
      case SpeakSessionPhase.savedToReview:
        return;
    }
  }

  void _saveCompleted({
    required SpeakSession session,
    required DailyMission mission,
    required LanguageProfile language,
  }) {
    if (session.isSavedToReview || session.correction == null) {
      return;
    }

    ref
        .read(reviewsProvider.notifier)
        .saveFromSession(session: session, language: language);
    ref.read(dailyMissionsProvider.notifier).markCompleted(mission.id);
    ref
        .read(progressProvider.notifier)
        .recordCompletedSession(
          session: session,
          mission: mission,
          language: language,
        );
    ref.read(speakSessionProvider.notifier).markSavedToReview();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final mission = ref.watch(dailyMissionProvider);
    final session = ref.watch(speakSessionProvider);

    if (language == null || mission == null) {
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 118),
          child: EmptyStateCard(
            icon: Icons.mic_none_rounded,
            title: 'No mission loaded',
            body:
                'Complete onboarding so FluentOS can create a speaking prompt.',
            action: PrimaryActionButton(
              label: 'Go to Today',
              icon: Icons.wb_sunny_outlined,
              onPressed: () => ref.read(mainTabProvider.notifier).setIndex(0),
              compact: true,
            ),
          ),
        ),
      );
    }

    if (session == null) {
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 118),
          child: EmptyStateCard(
            icon: Icons.mic_rounded,
            title: 'Ready to speak',
            body: 'Load today\'s mission and start the mock speaking loop.',
            action: PrimaryActionButton(
              label: 'Load mission',
              icon: Icons.flag_rounded,
              onPressed: () {
                ref
                    .read(speakSessionProvider.notifier)
                    .startMission(mission, mode: _selectedMode);
              },
              compact: true,
            ),
          ),
        ),
      );
    }

    final activeSession = session;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 118),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FluentHeader(
              title: 'Speak',
              subtitle:
                  '${language.baseLanguageName} → ${language.name} - ${language.userRegion} - ${activeSession.title}',
              trailing: AppPill(
                label: _statusTextForPhase(activeSession.phase),
                icon: Icons.graphic_eq_rounded,
              ),
            ),
            const SizedBox(height: 18),
            _ModeSelector(
              selectedMode: _selectedMode,
              onSelected: (mode) => _selectMode(mode, mission),
            ),
            const SizedBox(height: 18),
            if (_selectedMode == SpeakMode.roleplay) ...[
              const _GlobalRoleplayExamples(),
              const SizedBox(height: 18),
            ],
            if (_selectedMode == SpeakMode.fearBreaker) ...[
              _FearBreakerPanel(
                step: _fearStep,
                confidence: _fearConfidence,
                onTinyStep: () {
                  setState(() {
                    _fearStep = (_fearStep + 1).clamp(0, 6);
                    _fearConfidence = (_fearConfidence + 8).clamp(0, 100);
                  });
                },
                onNervous: () {
                  setState(() {
                    _fearConfidence = (_fearConfidence - 4).clamp(0, 100);
                  });
                },
              ),
              const SizedBox(height: 18),
            ],
            _ScenarioCard(session: activeSession, mission: mission),
            const SizedBox(height: 24),
            MicOrb(
              isListening:
                  activeSession.phase == SpeakSessionPhase.listening ||
                  activeSession.phase == SpeakSessionPhase.repeatAttempt,
              onTap: () => _handleMic(
                session: activeSession,
                mission: mission,
                language: language,
              ),
              lowPressure: _selectedMode == SpeakMode.fearBreaker,
              semanticLabel: _micLabel(activeSession.phase),
            ),
            const SizedBox(height: 16),
            WaveformMock(
              active:
                  activeSession.phase == SpeakSessionPhase.listening ||
                  activeSession.phase == SpeakSessionPhase.repeatAttempt,
            ),
            const SizedBox(height: 12),
            Text(
              _phaseInstruction(activeSession.phase),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            _SessionBody(
              session: activeSession,
              mission: mission,
              language: language,
              onShowCorrection: () {
                ref
                    .read(speakSessionProvider.notifier)
                    .showCorrection(mission: mission, language: language);
              },
              onSayAgain: () {
                ref.read(speakSessionProvider.notifier).startRepeatAttempt();
              },
              onFinishRepeat: () {
                ref.read(speakSessionProvider.notifier).finishRepeatAttempt();
              },
              onSave: () => _saveCompleted(
                session: activeSession,
                mission: mission,
                language: language,
              ),
              onNextMission: () {
                final nextMission = ref.read(dailyMissionProvider);
                if (nextMission != null) {
                  ref
                      .read(speakSessionProvider.notifier)
                      .startMission(nextMission, mode: SpeakMode.dailyMission);
                  setState(() => _selectedMode = SpeakMode.dailyMission);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _statusTextForPhase(SpeakSessionPhase phase) {
    switch (phase) {
      case SpeakSessionPhase.ready:
        return 'Ready';
      case SpeakSessionPhase.listening:
        return 'Listening';
      case SpeakSessionPhase.transcriptReady:
        return 'Transcript';
      case SpeakSessionPhase.corrected:
        return 'Corrected';
      case SpeakSessionPhase.repeatAttempt:
        return 'Repeat';
      case SpeakSessionPhase.completed:
        return 'Complete';
      case SpeakSessionPhase.savedToReview:
        return 'Saved';
    }
  }

  String _micLabel(SpeakSessionPhase phase) {
    switch (phase) {
      case SpeakSessionPhase.ready:
        return 'Start speaking';
      case SpeakSessionPhase.listening:
        return 'Finish speaking';
      case SpeakSessionPhase.repeatAttempt:
        return 'Finish repeat attempt';
      case SpeakSessionPhase.transcriptReady:
      case SpeakSessionPhase.corrected:
      case SpeakSessionPhase.completed:
      case SpeakSessionPhase.savedToReview:
        return 'Microphone inactive';
    }
  }

  String _phaseInstruction(SpeakSessionPhase phase) {
    switch (phase) {
      case SpeakSessionPhase.ready:
        return 'Tap the orb to start speaking.';
      case SpeakSessionPhase.listening:
        return 'Listening... tap the orb again when you finish.';
      case SpeakSessionPhase.transcriptReady:
        return 'Transcript ready. Check what FluentOS heard.';
      case SpeakSessionPhase.corrected:
        return 'Correction ready. Repeat the natural version.';
      case SpeakSessionPhase.repeatAttempt:
        return 'Say the corrected version again, then tap the orb.';
      case SpeakSessionPhase.completed:
        return 'Session complete. Save the mistake to Review.';
      case SpeakSessionPhase.savedToReview:
        return 'Saved to Review. Progress has been updated.';
    }
  }
}

class _ModeSelector extends StatelessWidget {
  final SpeakMode selectedMode;
  final ValueChanged<SpeakMode> onSelected;

  const _ModeSelector({required this.selectedMode, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final mode in SpeakMode.values)
            FluentChip(
              label: mode.shortLabel,
              selected: selectedMode == mode,
              icon: _iconFor(mode),
              onTap: () => onSelected(mode),
            ),
        ],
      ),
    );
  }

  IconData _iconFor(SpeakMode mode) {
    switch (mode) {
      case SpeakMode.dailyMission:
        return Icons.flag_rounded;
      case SpeakMode.roleplay:
        return Icons.theater_comedy_rounded;
      case SpeakMode.shadowing:
        return Icons.record_voice_over_rounded;
      case SpeakMode.pronunciationDrill:
        return Icons.hearing_rounded;
      case SpeakMode.fearBreaker:
        return Icons.favorite_outline_rounded;
      case SpeakMode.freeTalk:
        return Icons.forum_rounded;
    }
  }
}

class _ScenarioCard extends StatelessWidget {
  final SpeakSession session;
  final DailyMission mission;

  const _ScenarioCard({required this.session, required this.mission});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppPill(label: session.mode.label, icon: Icons.tune_rounded),
              const Spacer(),
              AppPill(
                label: mission.focusArea,
                icon: Icons.psychology_alt_rounded,
                color: AppTheme.warning,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            session.scenarioPrompt,
            style: const TextStyle(
              fontSize: 20,
              height: 1.25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(48),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withAlpha(22)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.record_voice_over_rounded,
                  color: AppTheme.primaryCyan,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    session.coachPrompt,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.35,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlobalRoleplayExamples extends StatelessWidget {
  const _GlobalRoleplayExamples();

  static const _examples = [
    'Job interview in English',
    'Japanese travel introduction',
    'German train station help',
    'English global workplace meeting',
    'Korean culture conversation',
    'French cafe order',
    'Spanish travel help',
    'Hindi local conversation',
    'Bengali friend conversation',
  ];

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final example in _examples)
            AppPill(
              label: example,
              icon: Icons.theater_comedy_rounded,
              color: AppTheme.primaryCyan,
              dense: true,
            ),
        ],
      ),
    );
  }
}

class _SessionBody extends StatelessWidget {
  final SpeakSession session;
  final DailyMission mission;
  final LanguageProfile language;
  final VoidCallback onShowCorrection;
  final VoidCallback onSayAgain;
  final VoidCallback onFinishRepeat;
  final VoidCallback onSave;
  final VoidCallback onNextMission;

  const _SessionBody({
    required this.session,
    required this.mission,
    required this.language,
    required this.onShowCorrection,
    required this.onSayAgain,
    required this.onFinishRepeat,
    required this.onSave,
    required this.onNextMission,
  });

  @override
  Widget build(BuildContext context) {
    switch (session.phase) {
      case SpeakSessionPhase.ready:
      case SpeakSessionPhase.listening:
        return _TranscriptPlaceholder(
          isListening: session.phase == SpeakSessionPhase.listening,
        );
      case SpeakSessionPhase.transcriptReady:
        return _TranscriptReadyCard(
          session: session,
          onShowCorrection: onShowCorrection,
        );
      case SpeakSessionPhase.corrected:
        return CorrectionCard(
          correction: session.correction!,
          saved: false,
          primaryLabel: 'Say it again',
          secondaryLabel: 'Try again',
          onPrimary: onSayAgain,
          onSecondary: onSayAgain,
        );
      case SpeakSessionPhase.repeatAttempt:
        return _RepeatAttemptCard(
          correction: session.correction,
          onFinish: onFinishRepeat,
        );
      case SpeakSessionPhase.completed:
        return _CompletionCard(
          session: session,
          mission: mission,
          onSave: onSave,
          onNextMission: onNextMission,
        );
      case SpeakSessionPhase.savedToReview:
        return _SavedCard(onNextMission: onNextMission);
    }
  }
}

class _TranscriptPlaceholder extends StatelessWidget {
  final bool isListening;

  const _TranscriptPlaceholder({required this.isListening});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      color: Colors.white.withAlpha(12),
      child: Row(
        children: [
          Icon(
            isListening ? Icons.graphic_eq_rounded : Icons.pending_outlined,
            color: isListening ? AppTheme.primaryCyan : Colors.white38,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isListening
                  ? 'Capturing speech in mock mode...'
                  : 'Your transcript and correction will appear here.',
              style: const TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TranscriptReadyCard extends StatelessWidget {
  final SpeakSession session;
  final VoidCallback onShowCorrection;

  const _TranscriptReadyCard({
    required this.session,
    required this.onShowCorrection,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppPill(label: 'Transcript', icon: Icons.subject_rounded),
          const SizedBox(height: 16),
          Text(
            session.transcriptText ?? '',
            style: const TextStyle(
              fontSize: 18,
              height: 1.35,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (session.transcriptConfidenceLow) ...[
            const SizedBox(height: 14),
            GlassCard(
              padding: const EdgeInsets.all(12),
              color: AppTheme.warning.withAlpha(20),
              child: const Text(
                'I may have misheard you. Try again or continue.',
                style: TextStyle(
                  color: Colors.white,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),
          PrimaryActionButton(
            label: 'Show correction',
            icon: Icons.auto_fix_high_rounded,
            onPressed: onShowCorrection,
          ),
        ],
      ),
    );
  }
}

class _RepeatAttemptCard extends StatelessWidget {
  final Correction? correction;
  final VoidCallback onFinish;

  const _RepeatAttemptCard({required this.correction, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    final natural = correction?.naturalText ?? 'Repeat the corrected answer.';

    return GlassCard(
      color: AppTheme.primaryBlue.withAlpha(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppPill(label: 'Repeat challenge', icon: Icons.replay_rounded),
          const SizedBox(height: 16),
          Text(
            natural,
            style: const TextStyle(
              fontSize: 20,
              height: 1.3,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Say it once more. The goal is smoother, not louder.',
            style: TextStyle(color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 18),
          PrimaryActionButton(
            label: 'Finish repeat',
            icon: Icons.check_rounded,
            onPressed: onFinish,
          ),
        ],
      ),
    );
  }
}

class _CompletionCard extends StatelessWidget {
  final SpeakSession session;
  final DailyMission mission;
  final VoidCallback onSave;
  final VoidCallback onNextMission;

  const _CompletionCard({
    required this.session,
    required this.mission,
    required this.onSave,
    required this.onNextMission,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      color: AppTheme.success.withAlpha(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppPill(
            label: 'Session complete',
            icon: Icons.check_circle_rounded,
            color: AppTheme.success,
          ),
          const SizedBox(height: 16),
          Text(
            mission.successCue,
            style: const TextStyle(
              fontSize: 20,
              height: 1.25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Save this correction so Review can turn it into repeat practice.',
            style: TextStyle(color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 18),
          PrimaryActionButton(
            label: session.isSavedToReview
                ? 'Saved to Review'
                : 'Save to Review',
            icon: session.isSavedToReview
                ? Icons.bookmark_added_rounded
                : Icons.bookmark_add_rounded,
            onPressed: session.isSavedToReview ? null : onSave,
          ),
          const SizedBox(height: 12),
          SecondaryActionButton(
            label: 'Next mission',
            icon: Icons.arrow_forward_rounded,
            onPressed: onNextMission,
          ),
        ],
      ),
    );
  }
}

class _SavedCard extends ConsumerWidget {
  final VoidCallback onNextMission;

  const _SavedCard({required this.onNextMission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      color: AppTheme.success.withAlpha(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppPill(
            label: 'Saved',
            icon: Icons.bookmark_added_rounded,
            color: AppTheme.success,
          ),
          const SizedBox(height: 16),
          const Text(
            'Review card created. Mission completed. Progress updated.',
            style: TextStyle(
              fontSize: 20,
              height: 1.3,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SecondaryActionButton(
                  label: 'Go Review',
                  icon: Icons.history_edu_rounded,
                  onPressed: () {
                    ref.read(mainTabProvider.notifier).setIndex(2);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryActionButton(
                  label: 'Next',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: onNextMission,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FearBreakerPanel extends StatelessWidget {
  final int step;
  final int confidence;
  final VoidCallback onTinyStep;
  final VoidCallback onNervous;

  const _FearBreakerPanel({
    required this.step,
    required this.confidence,
    required this.onTinyStep,
    required this.onNervous,
  });

  static const _steps = [
    'Speak one word',
    'Speak one sentence',
    'Speak for 20 seconds',
    'Speak with guided support',
    'Speak without script',
    'Speak faster',
    'Speak confidently',
  ];

  @override
  Widget build(BuildContext context) {
    final complete = step == _steps.length - 1;

    return GlassCard(
      color: AppTheme.mint.withAlpha(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppPill(
            label: 'Fear Breaker',
            icon: Icons.favorite_outline_rounded,
            color: AppTheme.mint,
          ),
          const SizedBox(height: 16),
          Text(
            _steps[step],
            style: const TextStyle(
              fontSize: 22,
              height: 1.2,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            complete
                ? 'You reached the confident step. Keep the pressure low and repeat once.'
                : 'Tiny steps count. You do not need a perfect sentence to start.',
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: confidence / 100,
                    backgroundColor: Colors.white.withAlpha(24),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.mint,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$confidence%',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SecondaryActionButton(
                  label: 'I feel nervous',
                  icon: Icons.favorite_border_rounded,
                  onPressed: onNervous,
                  compact: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryActionButton(
                  label: complete ? 'Tiny win' : 'Tiny step',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: onTinyStep,
                  compact: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
