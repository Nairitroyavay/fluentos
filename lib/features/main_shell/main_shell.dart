import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../today/today_tab.dart';
import '../speak/speak_tab.dart';
import '../review/review_tab.dart';
import '../progress/progress_tab.dart';
import '../profile/profile_tab.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const TodayTab(),
    const SpeakTab(),
    const ReviewTab(),
    const ProgressTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const LiquidBackground(child: SizedBox.expand()),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _tabs[_currentIndex],
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: GlassCard(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              borderRadius: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(Icons.wb_sunny_outlined, 0),
                  _buildNavItem(Icons.mic_none, 1),
                  _buildNavItem(Icons.history_edu, 2),
                  _buildNavItem(Icons.bar_chart, 3),
                  _buildNavItem(Icons.person_outline, 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryViolet.withAlpha(76) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? AppTheme.primaryCyan : Colors.white54,
          size: 28,
        ),
      ),
    );
  }
}
