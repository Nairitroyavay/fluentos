import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
// import '../../providers/providers.dart'; // removed unused import

class SpeakTab extends ConsumerStatefulWidget {
  const SpeakTab({super.key});

  @override
  ConsumerState<SpeakTab> createState() => _SpeakTabState();
}

class _SpeakTabState extends ConsumerState<SpeakTab> with SingleTickerProviderStateMixin {
  bool _isSpeaking = false;
  bool _showCorrection = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleSpeaking() {
    setState(() {
      _isSpeaking = !_isSpeaking;
      if (!_isSpeaking) {
        _showCorrection = true; // Show correction after fake speaking ends
      } else {
        _showCorrection = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
        child: Column(
          children: [
            const Text(
              'Coffee Shop',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Scenario: Order a coffee from the barista',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const Spacer(),
            
            if (_showCorrection) ...[
              GlassCard(
                child: Column(
                  children: [
                    const Text(
                      'Fake Transcript',
                      style: TextStyle(color: Colors.white54),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '"Yo quiero un cafe"',
                      style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryViolet.withAlpha(51),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'Better: "Quisiera un café, por favor."',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.primaryCyan),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '"Quisiera" is more polite when ordering.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryViolet,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        setState(() => _showCorrection = false);
                      },
                      child: const Text('Say it again', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],

            GestureDetector(
              onTap: _toggleSpeaking,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isSpeaking ? _pulseAnimation.value : 1.0,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppTheme.primaryCyan, AppTheme.primaryViolet],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryCyan.withAlpha(_isSpeaking ? 153 : 76),
                            blurRadius: _isSpeaking ? 40 : 20,
                            spreadRadius: _isSpeaking ? 10 : 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isSpeaking ? Icons.mic : Icons.mic_none,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _isSpeaking ? 'Listening...' : 'Tap to speak',
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
