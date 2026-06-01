import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

part 'widgets/mode_selector.dart';
part 'widgets/scenario_card.dart';
part 'widgets/transcript_card.dart';
part 'widgets/repeat_attempt_card.dart';
part 'widgets/completion_card.dart';
part 'widgets/fear_breaker_panel.dart';

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
