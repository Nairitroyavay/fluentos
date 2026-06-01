part of 'theme.dart';

class MockPermissionCard extends StatelessWidget {
  final String title;
  final String body;

  const MockPermissionCard({
    super.key,
    this.title = 'Mock voice mode',
    this.body = 'No microphone permission is requested in this frontend demo.',
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      color: AppTheme.primaryBlue.withAlpha(22),
      padding: const EdgeInsets.all(14),
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
