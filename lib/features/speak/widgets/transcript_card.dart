part of '../speak_tab.dart';

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
