part of '../profile_tab.dart';

class _PrivacyCard extends StatelessWidget {
  final bool voiceConsent;
  final ValueChanged<bool> onVoiceConsentChanged;

  const _PrivacyCard({
    required this.voiceConsent,
    required this.onVoiceConsentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Privacy and voice consent'),
          const SizedBox(height: 10),
          const _InlineNotice(
            title: 'Voice is not stored in this demo.',
            body:
                'No real microphone, speech-to-text, cloud storage, or model training is used in this frontend MVP.',
          ),
          const SizedBox(height: 12),
          _SwitchRow(
            title: 'Model improvement opt-in mock',
            subtitle: voiceConsent ? 'Opt-in shown locally' : 'Off by default',
            value: voiceConsent,
            onChanged: onVoiceConsentChanged,
          ),
          const SizedBox(height: 12),
          ResponsiveActionRow(
            children: [
              SecondaryActionButton(
                label: 'Export placeholder',
                icon: Icons.file_download_outlined,
                onPressed: () {},
                compact: true,
              ),
              SecondaryActionButton(
                label: 'Delete placeholder',
                icon: Icons.delete_outline_rounded,
                onPressed: () {},
                compact: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InlineNotice extends StatelessWidget {
  final String title;
  final String body;

  const _InlineNotice({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withAlpha(22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(24)),
      ),
      child: Row(
        children: [
          const Icon(Icons.privacy_tip_outlined, color: AppTheme.primaryCyan),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: const TextStyle(color: Colors.white60, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
