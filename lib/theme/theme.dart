import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Jetstream Brand Colors
class JetstreamColors {
  // Primary Colors
  static const Color midnightBlue = Color(0xFF0A1628);
  static const Color deepNavy = Color(0xFF1A2332);
  static const Color electricTeal = Color(0xFF00D9FF);
  static const Color brightCyan = Color(0xFF00F0FF);
  static const Color starlightWhite = Color(0xFFF8FAFC);

  // Accent Colors
  static const Color sunsetOrange = Color(0xFFFF6B35);
  static const Color goldenYellow = Color(0xFFFFC857);
  static const Color purpleAccent = Color(0xFF8B5CF6);

  // Neutral Colors
  static const Color darkGray = Color(0xFF1E293B);
  static const Color mediumGray = Color(0xFF475569);
  static const Color lightGray = Color(0xFF94A3B8);
  static const Color paleGray = Color(0xFFE2E8F0);
}

// Light Theme
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: JetstreamColors.electricTeal,
    onPrimary: Colors.white,
    secondary: JetstreamColors.sunsetOrange,
    onSecondary: Colors.white,
    surface: JetstreamColors.starlightWhite,
    onSurface: JetstreamColors.darkGray,
    surfaceVariant: JetstreamColors.paleGray,
    error: Color(0xFFEF4444),
  ),
  scaffoldBackgroundColor: JetstreamColors.starlightWhite,
  textTheme: TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 57,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.5,
      color: JetstreamColors.midnightBlue,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: JetstreamColors.midnightBlue,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      color: JetstreamColors.midnightBlue,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: JetstreamColors.midnightBlue,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: JetstreamColors.midnightBlue,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: JetstreamColors.midnightBlue,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: JetstreamColors.darkGray,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: JetstreamColors.darkGray,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: JetstreamColors.darkGray,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: JetstreamColors.mediumGray,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: JetstreamColors.mediumGray,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: JetstreamColors.lightGray,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: JetstreamColors.darkGray,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: JetstreamColors.mediumGray,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: JetstreamColors.lightGray,
    ),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    foregroundColor: JetstreamColors.midnightBlue,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.15,
      color: JetstreamColors.midnightBlue,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    color: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: JetstreamColors.electricTeal,
      disabledForegroundColor: JetstreamColors.lightGray,
      disabledBackgroundColor: JetstreamColors.paleGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: JetstreamColors.electricTeal,
      side: const BorderSide(color: JetstreamColors.electricTeal, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: JetstreamColors.electricTeal,
      textStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: JetstreamColors.paleGray, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: JetstreamColors.paleGray, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide:
          const BorderSide(color: JetstreamColors.electricTeal, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    hintStyle: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: JetstreamColors.lightGray,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    elevation: 4,
    backgroundColor: JetstreamColors.electricTeal,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: JetstreamColors.electricTeal,
    onPrimary: JetstreamColors.midnightBlue,
    secondary: JetstreamColors.sunsetOrange,
    onSecondary: Colors.white,
    surface: JetstreamColors.deepNavy,
    onSurface: JetstreamColors.starlightWhite,
    surfaceVariant: JetstreamColors.darkGray,
    error: Color(0xFFEF4444),
  ),
  scaffoldBackgroundColor: JetstreamColors.midnightBlue,
  textTheme: TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: 57,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.5,
      color: JetstreamColors.starlightWhite,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: JetstreamColors.starlightWhite,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      color: JetstreamColors.starlightWhite,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: JetstreamColors.starlightWhite,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: JetstreamColors.starlightWhite,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: JetstreamColors.starlightWhite,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: JetstreamColors.starlightWhite,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: JetstreamColors.starlightWhite,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: JetstreamColors.starlightWhite,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: JetstreamColors.lightGray,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: JetstreamColors.lightGray,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: JetstreamColors.mediumGray,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: JetstreamColors.starlightWhite,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: JetstreamColors.lightGray,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: JetstreamColors.mediumGray,
    ),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.transparent,
    foregroundColor: JetstreamColors.starlightWhite,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.15,
      color: JetstreamColors.starlightWhite,
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    color: JetstreamColors.deepNavy,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: JetstreamColors.midnightBlue,
      backgroundColor: JetstreamColors.electricTeal,
      disabledForegroundColor: JetstreamColors.mediumGray,
      disabledBackgroundColor: JetstreamColors.darkGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: JetstreamColors.electricTeal,
      side: const BorderSide(color: JetstreamColors.electricTeal, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: JetstreamColors.electricTeal,
      textStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: JetstreamColors.deepNavy,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: JetstreamColors.darkGray, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: JetstreamColors.darkGray, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide:
          const BorderSide(color: JetstreamColors.electricTeal, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    hintStyle: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: JetstreamColors.mediumGray,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    elevation: 4,
    backgroundColor: JetstreamColors.electricTeal,
    foregroundColor: JetstreamColors.midnightBlue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
);

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Default to dark for premium feel

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
