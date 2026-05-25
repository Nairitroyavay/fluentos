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

class _SpeakTabState extends ConsumerState<SpeakTab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleMicPress(SpeakSession session) {
    final notifier = ref.read(speakSessionProvider.notifier);

    if (session.phase == SpeakSessionPhase.listening) {
      notifier.finishListening();
      return;
    }

    notifier.startListening();
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) {
        return;
      }

      final currentSession = ref.read(speakSessionProvider);
      if (currentSession.phase == SpeakSessionPhase.listening) {
        ref.read(speakSessionProvider.notifier).finishListening();
      }
    });
  }

  void _saveMistake(SpeakSession session) {
    final language = ref.read(userProvider).activeLanguage;
    if (language == null || session.correction == null) {
      return;
    }

    ref
        .read(reviewsProvider.notifier)
        .saveFromSession(session: session, language: language);
    ref.read(speakSessionProvider.notifier).markSavedToReview();
    ref.read(dailyMissionsProvider.notifier).markCompleted(session.missionId);
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(speakSessionProvider);
    final phase = session.phase;
    final isListening = phase == SpeakSessionPhase.listening;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 118),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Speak',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        session.title,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                AppPill(
                  label: 'Attempt ${session.attemptCount + 1}',
                  icon: Icons.replay_rounded,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _ScenarioCard(session: session),
            const SizedBox(height: 34),
            _MicOrb(
              isListening: isListening,
              animation: _pulseAnimation,
              onTap: () => _handleMicPress(session),
            ),
            const SizedBox(height: 18),
            Text(
              _statusTextForPhase(phase),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 26),
            if (session.correction != null)
              _CorrectionCard(
                session: session,
                onSayAgain: () {
                  ref.read(speakSessionProvider.notifier).sayAgain();
                },
                onSave: session.isSavedToReview
                    ? null
                    : () {
                        _saveMistake(session);
                      },
              )
            else
              _TranscriptPlaceholder(isListening: isListening),
          ],
        ),
      ),
    );
  }

  String _statusTextForPhase(SpeakSessionPhase phase) {
    switch (phase) {
      case SpeakSessionPhase.listening:
        return 'Listening...';
      case SpeakSessionPhase.corrected:
        return 'Correction ready';
      case SpeakSessionPhase.saved:
        return 'Saved to Review';
      case SpeakSessionPhase.ready:
        return 'Ready';
    }
  }
}

class _ScenarioCard extends StatelessWidget {
  final SpeakSession session;

  const _ScenarioCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppPill(label: 'Scenario', icon: Icons.theater_comedy_rounded),
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
              borderRadius: BorderRadius.circular(8),
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
                      fontWeight: FontWeight.w700,
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

class _MicOrb extends StatelessWidget {
  final bool isListening;
  final Animation<double> animation;
  final VoidCallback onTap;

  const _MicOrb({
    required this.isListening,
    required this.animation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Tooltip(
        message: 'Microphone',
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final pulse = isListening ? 1 + animation.value * 0.12 : 1.0;

              return Transform.scale(
                scale: pulse,
                child: Container(
                  width: 136,
                  height: 136,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryCyan,
                        AppTheme.primaryBlue,
                        AppTheme.primaryViolet,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryCyan.withAlpha(
                          isListening ? 132 : 78,
                        ),
                        blurRadius: isListening ? 48 : 30,
                        spreadRadius: isListening ? 8 : 2,
                      ),
                      BoxShadow(
                        color: AppTheme.deepViolet.withAlpha(88),
                        blurRadius: 36,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Icon(
                    isListening ? Icons.graphic_eq_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 54,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
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
                  ? 'Capturing speech...'
                  : 'Your transcript will appear here.',
              style: const TextStyle(
                color: Colors.white60,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CorrectionCard extends StatelessWidget {
  final SpeakSession session;
  final VoidCallback onSayAgain;
  final VoidCallback? onSave;

  const _CorrectionCard({
    required this.session,
    required this.onSayAgain,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final correction = session.correction!;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppPill(
                label: 'Correction',
                icon: Icons.auto_fix_high_rounded,
              ),
              const Spacer(),
              Icon(
                session.isSavedToReview
                    ? Icons.bookmark_added_rounded
                    : Icons.bookmark_add_outlined,
                color: session.isSavedToReview
                    ? AppTheme.success
                    : Colors.white54,
              ),
            ],
          ),
          const SizedBox(height: 18),
          _CorrectionLine(
            label: 'You said',
            text: correction.originalText,
            icon: Icons.close_rounded,
            color: Colors.white54,
            strikeThrough: true,
          ),
          const SizedBox(height: 14),
          _CorrectionLine(
            label: 'Say instead',
            text: correction.correctedText,
            icon: Icons.check_rounded,
            color: AppTheme.primaryCyan,
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.primaryViolet.withAlpha(34),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.primaryViolet.withAlpha(78)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppTheme.warning,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    correction.explanation,
                    style: const TextStyle(color: Colors.white, height: 1.35),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: SecondaryActionButton(
                  label: 'Say it again',
                  icon: Icons.replay_rounded,
                  onPressed: onSayAgain,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryActionButton(
                  label: session.isSavedToReview ? 'Saved' : 'Save mistake',
                  icon: session.isSavedToReview
                      ? Icons.bookmark_added_rounded
                      : Icons.bookmark_add_rounded,
                  onPressed: onSave,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CorrectionLine extends StatelessWidget {
  final String label;
  final String text;
  final IconData icon;
  final Color color;
  final bool strikeThrough;

  const _CorrectionLine({
    required this.label,
    required this.text,
    required this.icon,
    required this.color,
    this.strikeThrough = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: TextStyle(
                  color: strikeThrough ? Colors.white54 : Colors.white,
                  fontSize: 17,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                  decoration: strikeThrough ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
