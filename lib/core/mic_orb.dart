part of 'theme.dart';

class MicOrb extends StatefulWidget {
  final bool isListening;
  final VoidCallback? onTap;
  final double size;
  final String semanticLabel;
  final bool lowPressure;

  const MicOrb({
    super.key,
    required this.isListening,
    required this.onTap,
    this.size = 136,
    this.semanticLabel = 'Microphone',
    this.lowPressure = false,
  });

  @override
  State<MicOrb> createState() => _MicOrbState();
}

class _MicOrbState extends State<MicOrb> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disabledMotion = MediaQuery.disableAnimationsOf(context);
    return Center(
      child: Semantics(
        button: true,
        label: widget.semanticLabel,
        child: Tooltip(
          message: widget.semanticLabel,
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final pulse = widget.isListening && !disabledMotion
                    ? 1 + _controller.value * (widget.lowPressure ? 0.06 : 0.12)
                    : 1.0;

                return Transform.scale(
                  scale: pulse,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.lowPressure
                            ? const [
                                AppTheme.mint,
                                AppTheme.primaryBlue,
                                AppTheme.primaryViolet,
                              ]
                            : const [
                                AppTheme.primaryCyan,
                                AppTheme.primaryBlue,
                                AppTheme.primaryViolet,
                              ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryCyan.withAlpha(
                            widget.isListening ? 132 : 78,
                          ),
                          blurRadius: widget.isListening ? 48 : 30,
                          spreadRadius: widget.isListening ? 8 : 2,
                        ),
                        BoxShadow(
                          color: AppTheme.deepViolet.withAlpha(88),
                          blurRadius: 36,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isListening
                          ? Icons.graphic_eq_rounded
                          : Icons.mic_rounded,
                      color: Colors.white,
                      size: widget.size * 0.40,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
