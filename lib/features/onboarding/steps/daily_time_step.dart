part of '../onboarding_screen.dart';

class _DailyTimeStep extends StatelessWidget {
  final int? selectedMinutes;
  final bool customTime;
  final void Function(int minutes, bool isCustom) onSelected;

  const _DailyTimeStep({
    required this.selectedMinutes,
    required this.customTime,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: 'How much time can you practice daily?',
      subtitle: 'Short daily speaking beats long occasional lessons.',
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final minutes in [5, 10, 15, 30])
              FluentChip(
                label: '$minutes min',
                selected: selectedMinutes == minutes && !customTime,
                icon: Icons.timer_outlined,
                onTap: () => onSelected(minutes, false),
              ),
            FluentChip(
              label: 'Custom',
              selected: customTime,
              icon: Icons.tune_rounded,
              onTap: () => onSelected(20, true),
            ),
          ],
        ),
        if (customTime) ...[
          const SizedBox(height: 22),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Custom daily time',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                Slider(
                  value: (selectedMinutes ?? 20).toDouble(),
                  min: 5,
                  max: 45,
                  divisions: 8,
                  label: '${selectedMinutes ?? 20} min',
                  onChanged: (value) => onSelected(value.round(), true),
                ),
                Text(
                  '${selectedMinutes ?? 20} minutes per day',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
