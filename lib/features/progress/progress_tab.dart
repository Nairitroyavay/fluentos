import 'package:flutter/material.dart';
import '../../core/theme.dart';

class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your fluency journey',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fluency Score', style: TextStyle(fontSize: 16)),
                      Text('450', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryCyan)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('Fake Graph Placeholder', style: TextStyle(color: Colors.white38)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const GlassCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Streak', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, color: Colors.orange),
                      SizedBox(width: 4),
                      Text('12 Days', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
