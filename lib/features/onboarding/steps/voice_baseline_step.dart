part of '../onboarding_screen.dart';

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
