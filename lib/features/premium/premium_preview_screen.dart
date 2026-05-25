import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';

class PremiumPreviewScreen extends StatelessWidget {
  const PremiumPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Icon(Icons.diamond, size: 80, color: AppTheme.primaryCyan),
                const SizedBox(height: 24),
                const Text(
                  'Unlock FluentOS Premium',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Learn multiple languages, get unlimited speaking scenarios, and advanced AI corrections.',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                GlassCard(
                  child: Column(
                    children: [
                      _buildFeature('Unlimited Languages'),
                      const SizedBox(height: 12),
                      _buildFeature('Custom Scenarios'),
                      const SizedBox(height: 12),
                      _buildFeature('Deep Dive Corrections'),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryViolet,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('Upgrade Now', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Maybe later', style: TextStyle(color: Colors.white54)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(String text) {
    return Row(
      children: [
        const Icon(Icons.check, color: AppTheme.primaryCyan),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
