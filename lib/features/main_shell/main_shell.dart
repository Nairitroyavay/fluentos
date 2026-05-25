import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../providers/providers.dart';
import '../profile/profile_tab.dart';
import '../progress/progress_tab.dart';
import '../review/review_tab.dart';
import '../speak/speak_tab.dart';
import '../today/today_tab.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const List<Widget> _tabs = [
    TodayTab(),
    SpeakTab(),
    ReviewTab(),
    ProgressTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainTabProvider);

    return Scaffold(
      extendBody: true,
      body: LiquidBackground(
        child: Stack(
          children: [
            IndexedStack(index: currentIndex, children: _tabs),
            Positioned(
              left: 18,
              right: 18,
              bottom: 16 + MediaQuery.paddingOf(context).bottom,
              child: _FloatingTabBar(currentIndex: currentIndex),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingTabBar extends ConsumerWidget {
  final int currentIndex;

  const _FloatingTabBar({required this.currentIndex});

  static const List<_TabDestination> _destinations = [
    _TabDestination(Icons.wb_sunny_outlined, 'Today'),
    _TabDestination(Icons.mic_none_rounded, 'Speak'),
    _TabDestination(Icons.history_edu_rounded, 'Review'),
    _TabDestination(Icons.insights_rounded, 'Progress'),
    _TabDestination(Icons.person_outline_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      top: false,
      minimum: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(24),
              borderRadius: BorderRadius.circular(34),
              border: Border.all(color: Colors.white.withAlpha(44)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withAlpha(40),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              children: [
                for (var index = 0; index < _destinations.length; index++)
                  Expanded(
                    child: _TabButton(
                      destination: _destinations[index],
                      isSelected: currentIndex == index,
                      onTap: () {
                        ref.read(mainTabProvider.notifier).setIndex(index);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final _TabDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: destination.label,
      child: InkResponse(
        radius: 30,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryViolet.withAlpha(56)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                destination.icon,
                color: isSelected ? AppTheme.primaryCyan : Colors.white60,
                size: 24,
              ),
              const SizedBox(height: 3),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  destination.label,
                  maxLines: 1,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white54,
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabDestination {
  final IconData icon;
  final String label;

  const _TabDestination(this.icon, this.label);
}
