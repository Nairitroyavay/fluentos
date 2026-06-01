part of '../speak_tab.dart';

class _ModeSelector extends StatelessWidget {
  final SpeakMode selectedMode;
  final ValueChanged<SpeakMode> onSelected;

  const _ModeSelector({required this.selectedMode, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final mode in SpeakMode.values)
            FluentChip(
              label: mode.shortLabel,
              selected: selectedMode == mode,
              icon: _iconFor(mode),
              onTap: () => onSelected(mode),
            ),
        ],
      ),
    );
  }

  IconData _iconFor(SpeakMode mode) {
    switch (mode) {
      case SpeakMode.dailyMission:
        return Icons.flag_rounded;
      case SpeakMode.roleplay:
        return Icons.theater_comedy_rounded;
      case SpeakMode.shadowing:
        return Icons.record_voice_over_rounded;
      case SpeakMode.pronunciationDrill:
        return Icons.hearing_rounded;
      case SpeakMode.fearBreaker:
        return Icons.favorite_outline_rounded;
      case SpeakMode.freeTalk:
        return Icons.forum_rounded;
    }
  }
}
