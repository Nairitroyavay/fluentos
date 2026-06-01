part of '../profile_tab.dart';

class _LearningPreferencesCard extends StatelessWidget {
  final bool transliteration;
  final bool strictCorrections;
  final bool notifications;
  final double speechSpeed;
  final String coachTone;
  final String scriptMode;
  final bool hasRomanization;
  final bool hasTransliteration;
  final String accentPreference;
  final ValueChanged<bool> onTransliterationChanged;
  final ValueChanged<bool> onStrictnessChanged;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<double> onSpeechSpeedChanged;
  final ValueChanged<String> onCoachToneChanged;

  const _LearningPreferencesCard({
    required this.transliteration,
    required this.strictCorrections,
    required this.notifications,
    required this.speechSpeed,
    required this.coachTone,
    required this.scriptMode,
    required this.hasRomanization,
    required this.hasTransliteration,
    required this.accentPreference,
    required this.onTransliterationChanged,
    required this.onStrictnessChanged,
    required this.onNotificationsChanged,
    required this.onSpeechSpeedChanged,
    required this.onCoachToneChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Learning preferences'),
          const SizedBox(height: 8),
          _SwitchRow(
            title: 'Transliteration support',
            subtitle: hasTransliteration
                ? 'Show pronunciation help for supported scripts.'
                : 'Unavailable for this script mode.',
            value: transliteration,
            onChanged: hasTransliteration ? onTransliterationChanged : (_) {},
          ),
          _InfoRow(label: 'Script mode', value: scriptMode),
          _InfoRow(
            label: 'Romanization',
            value: hasRomanization ? 'Available' : 'Not needed',
          ),
          _InfoRow(label: 'Accent preference', value: accentPreference),
          _SwitchRow(
            title: 'Correction strictness',
            subtitle: strictCorrections
                ? 'Detailed coach notes'
                : 'Gentle essentials only',
            value: strictCorrections,
            onChanged: onStrictnessChanged,
          ),
          _SwitchRow(
            title: 'Reminder time mock',
            subtitle: notifications
                ? 'Evening practice reminder'
                : 'No local reminder',
            value: notifications,
            onChanged: onNotificationsChanged,
          ),
          const SizedBox(height: 10),
          const Text(
            'Coach tone',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tone in const [
                'Calm coach',
                'Direct coach',
                'Exam coach',
              ])
                FluentChip(
                  label: tone,
                  selected: coachTone == tone,
                  onTap: () => onCoachToneChanged(tone),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Speech speed ${(speechSpeed * 100).round()}%',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          Slider(
            value: speechSpeed,
            min: 0.45,
            max: 1,
            divisions: 11,
            onChanged: onSpeechSpeedChanged,
          ),
        ],
      ),
    );
  }
}
