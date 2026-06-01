part of '../profile_tab.dart';

class _OptivusCard extends StatelessWidget {
  const _OptivusCard();

  @override
  Widget build(BuildContext context) {
    return const GlassCard(
      color: Color(0x1821D7FF),
      child: Row(
        children: [
          Icon(Icons.hub_outlined, color: AppTheme.primaryCyan),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connect with Optivus later',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4),
                Text(
                  'Coming later. No sync is implemented in this frontend MVP.',
                  style: TextStyle(color: Colors.white60, height: 1.35),
                ),
              ],
            ),
          ),
          AppPill(
            label: 'Coming later',
            icon: Icons.lock_clock_rounded,
            color: AppTheme.warning,
            dense: true,
          ),
        ],
      ),
    );
  }
}
