part of '../profile_tab.dart';

class _SettingsCard extends StatelessWidget {
  final bool highContrast;
  final ValueChanged<bool> onHighContrastChanged;
  final VoidCallback onSignOut;
  final VoidCallback onResetDemoData;

  const _SettingsCard({
    required this.highContrast,
    required this.onHighContrastChanged,
    required this.onSignOut,
    required this.onResetDemoData,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Settings'),
          const SizedBox(height: 8),
          _SwitchRow(
            title: 'Theme mock',
            subtitle: highContrast
                ? 'High contrast preview'
                : 'Dark liquid theme',
            value: highContrast,
            onChanged: onHighContrastChanged,
          ),
          const _InfoRow(label: 'Notifications', value: 'Local mock only'),
          const _InfoRow(
            label: 'Accessibility',
            value: 'Captions, large targets, reduced motion aware',
          ),
          const SizedBox(height: 12),
          SecondaryActionButton(
            label: 'Sign out',
            icon: Icons.logout_rounded,
            onPressed: onSignOut,
          ),
          const SizedBox(height: 12),
          SecondaryActionButton(
            label: 'Reset demo data',
            icon: Icons.restart_alt_rounded,
            onPressed: onResetDemoData,
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
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
                  subtitle,
                  style: const TextStyle(color: Colors.white60, height: 1.3),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 330) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white54)),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 118,
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white54),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
