
import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs principales - Palette moderne et professionnelle
  static const Color primaryBlue = Color(0xFF2563EB); // Bleu moderne
  static const Color secondaryBlue = Color(0xFF3B82F6); // Bleu secondaire
  static const Color accentBlue = Color(0xFF60A5FA); // Bleu accent
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF8FAFC); // Gris très clair - Fond initial
  static const Color mediumGrey = Color(0xFF64748B); // Gris moyen
  static const Color darkGrey = Color(0xFF1E293B); // Gris foncé
  static const Color errorRed = Color(0xFFEF4444); // Rouge d'erreur
  static const Color warningOrange = Color(0xFFF59E0B); // Orange d'avertissement
  static const Color successGreen = Color(0xFF10B981); // Vert de succès
  static const Color infoBlue = Color(0xFF06B6D4); // Bleu d'information
  
  // Couleurs de surface
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color outline = Color(0xFFE2E8F0);
  
  // Gradients modernes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, secondaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [white, surfaceVariant],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Ombres modernes
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
  
  // Styles de boutons modernes
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryBlue,
    foregroundColor: white,
    elevation: 0,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );
  
  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: primaryBlue,
    elevation: 0,
    shadowColor: Colors.transparent,
    side: BorderSide(color: primaryBlue, width: 1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );
  
  static ButtonStyle get textButtonStyle => TextButton.styleFrom(
    foregroundColor: primaryBlue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );

  // Styles de décoration modernes
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: cardShadow,
    border: Border.all(color: outline, width: 1),
  );
  
  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: elevatedShadow,
  );

  static InputDecoration get textFieldDecoration => InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: primaryBlue, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: errorRed, width: 2),
    ),
    filled: true,
    fillColor: surfaceVariant,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: TextStyle(
      color: mediumGrey,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
  );

  // Typographie moderne
  static TextTheme get textTheme => TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: darkGrey,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: darkGrey,
      letterSpacing: -0.25,
    ),
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: darkGrey,
      letterSpacing: 0,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: darkGrey,
      letterSpacing: 0,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: darkGrey,
      letterSpacing: 0,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: darkGrey,
      letterSpacing: 0.15,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: darkGrey,
      letterSpacing: 0.15,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: mediumGrey,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: mediumGrey,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: darkGrey,
      letterSpacing: 0.1,
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
      primary: primaryBlue,
      secondary: secondaryBlue,
      surface: surface,
      background: lightGrey,
      error: errorRed,
    ),
    scaffoldBackgroundColor: lightGrey,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: white,
      foregroundColor: darkGrey,
      centerTitle: true,
      titleTextStyle: textTheme.titleLarge,
      iconTheme: IconThemeData(color: darkGrey),
      surfaceTintColor: Colors.transparent,
    ),
    textTheme: textTheme,
    inputDecorationTheme: textFieldDecoration,
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: white,
      shadowColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: primaryButtonStyle,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: secondaryButtonStyle,
    ),
    textButtonTheme: TextButtonThemeData(
      style: textButtonStyle,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: white,
      selectedItemColor: primaryBlue,
      unselectedItemColor: mediumGrey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: textTheme.labelLarge,
      unselectedLabelStyle: textTheme.bodySmall,
    ),
  );
}
