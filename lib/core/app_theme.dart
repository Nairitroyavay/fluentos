part of 'theme.dart';

class AppTheme {
  static const Color backgroundDark = Color(0xFF05060D);
  static const Color backgroundMedium = Color(0xFF101322);
  static const Color backgroundLight = Color(0xFF191D32);
  static const Color glassSurface = Color(0x24FFFFFF);
  static const Color borderGlow = Color(0x3DFFFFFF);
  static const Color primaryViolet = Color(0xFF8F5BFF);
  static const Color deepViolet = Color(0xFF5527D7);
  static const Color primaryBlue = Color(0xFF2E6BFF);
  static const Color primaryCyan = Color(0xFF21D7FF);
  static const Color success = Color(0xFF37E6A4);
  static const Color warning = Color(0xFFFFB84D);
  static const Color coral = Color(0xFFFF6B8A);
  static const Color mint = Color(0xFF7AF7C4);

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.outfitTextTheme(
      base.textTheme,
    ).apply(bodyColor: Colors.white, displayColor: Colors.white);

    return base.copyWith(
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryViolet,
        secondary: primaryCyan,
        surface: backgroundMedium,
        onPrimary: Colors.white,
        onSecondary: backgroundDark,
      ),
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withAlpha(18),
        hintStyle: const TextStyle(color: Colors.white54),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withAlpha(28)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withAlpha(28)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryCyan),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryViolet.withAlpha(58);
            }
            return Colors.white.withAlpha(10);
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return Colors.white70;
          }),
          side: WidgetStatePropertyAll(
            BorderSide(color: Colors.white.withAlpha(34)),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
