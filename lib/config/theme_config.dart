import 'package:flutter/material.dart';

/// Plantyze Pastel Color Palette - Expert UI/UX Design
/// Nature-inspired pastels for a beautiful plant recognition app
class AppColors {
  // LIGHT THEME - "Morning Garden" 🌸
  static const Color lightPrimary = Color(0xFFa7c4a0);      // Soft sage green
  static const Color lightSecondary = Color(0xFFc8b6d6);    // Lavender mist
  static const Color lightAccent = Color(0xFFffc5a1);       // Peach blossom
  static const Color lightBackground = Color(0xFFfaf8f5);   // Warm cream
  static const Color lightSurface = Color(0xFFf0f4ee);      // Misty green
  static const Color lightOnPrimary = Color(0xFFffffff);    // White
  static const Color lightOnBackground = Color(0xFF2d3a2e); // Deep forest green
  static const Color lightOnSurface = Color(0xFF3d4a3e);    // Dark moss
  static const Color lightOutline = Color(0xFFd4e3d0);      // Soft green border
  static const Color lightShadow = Color(0xFFc5d6c1);       // Colored shadow
  
  // DARK THEME - "Twilight Garden" 🌙
  static const Color darkPrimary = Color(0xFF9ec49a);       // Moonlit mint
  static const Color darkSecondary = Color(0xFFd4a5b8);     // Dusty rose
  static const Color darkAccent = Color(0xFFffa58f);        // Soft coral
  static const Color darkBackground = Color(0xFF1a1f1c);    // Deep charcoal
  static const Color darkSurface = Color(0xFF242b26);       // Midnight moss
  static const Color darkOnPrimary = Color(0xFF1a1f1c);     // Dark text on buttons
  static const Color darkOnBackground = Color(0xFFe8ebe7);  // Soft white
  static const Color darkOnSurface = Color(0xFFd8dcd7);     // Muted white
  static const Color darkOutline = Color(0xFF3a4d3c);       // Forest shadow
  static const Color darkShadow = Color(0xFF141814);        // Deep shadow

  // SHARED COLORS
  static const Color error = Color(0xFFff8a80);             // Soft coral error
  static const Color success = Color(0xFF81c784);           // Gentle success green
  static const Color warning = Color(0xFFffb74d);           // Warm warning orange
}

class ThemeConfig {
  /// 🌸 LIGHT THEME - "Morning Garden"
  /// Soft pastels inspired by a peaceful morning in a botanical garden
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      primaryContainer: AppColors.lightPrimary.withValues(alpha: 0.1),
      onPrimaryContainer: AppColors.lightOnBackground,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightOnPrimary,
      secondaryContainer: AppColors.lightSecondary.withValues(alpha: 0.1),
      onSecondaryContainer: AppColors.lightOnBackground,
      tertiary: AppColors.lightAccent,
      onTertiary: AppColors.lightOnPrimary,
      tertiaryContainer: AppColors.lightAccent.withValues(alpha: 0.1),
      onTertiaryContainer: AppColors.lightOnBackground,
      error: AppColors.error,
      onError: AppColors.lightOnPrimary,
      errorContainer: AppColors.error.withValues(alpha: 0.1),
      onErrorContainer: AppColors.lightOnBackground,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightOnSurface,
      surfaceContainerHighest: AppColors.lightSurface,
      onSurfaceVariant: AppColors.lightOnSurface.withValues(alpha: 0.7),
      outline: AppColors.lightOutline,
      outlineVariant: AppColors.lightOutline.withValues(alpha: 0.5),
      shadow: AppColors.lightShadow,
      scrim: Colors.black.withValues(alpha: 0.1),
      inverseSurface: AppColors.darkSurface,
      onInverseSurface: AppColors.darkOnSurface,
      inversePrimary: AppColors.darkPrimary,
      surfaceTint: AppColors.lightPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: AppColors.lightBackground,
      
      // AppBar with botanical elegance
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightOnPrimary,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        shadowColor: AppColors.lightShadow,
        surfaceTintColor: AppColors.lightPrimary,
        titleTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 22,
          letterSpacing: 0.5,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 24,
        ),
      ),

      // Enhanced typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: AppColors.lightOnBackground),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, color: AppColors.lightOnBackground),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.lightOnBackground),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.lightOnBackground),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.lightOnBackground),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.lightOnBackground),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.lightOnBackground),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.lightOnBackground),
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.lightOnBackground),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.lightOnBackground),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.lightOnBackground),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.lightOnBackground),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.lightOnBackground),
      ).copyWith(
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.lightOnSurface.withValues(alpha: 0.7)),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.lightOnSurface.withValues(alpha: 0.7)),
      ),

      // Beautiful elevated buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightOnPrimary,
          shadowColor: AppColors.lightShadow,
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined buttons with botanical touch
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          side: const BorderSide(color: AppColors.lightPrimary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Elegant cards
      cardTheme: CardTheme(
        color: AppColors.lightSurface,
        shadowColor: AppColors.lightShadow,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(8),
      ),

      // Refined input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.lightOutline, width: 1),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: AppColors.lightOutline, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: AppColors.lightPrimary, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        hintStyle: TextStyle(color: AppColors.lightOnSurface.withValues(alpha: 0.6)),
      ),

      // Subtle dividers
      dividerTheme: DividerThemeData(
        color: AppColors.lightOutline.withValues(alpha: 0.6),
        thickness: 0.5,
        space: 1,
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: AppColors.lightPrimary,
        size: 24,
      ),

      // List tile theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.transparent,
        selectedTileColor: AppColors.lightPrimary.withValues(alpha: 0.1),
      ),

      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.lightSurface,
        shadowColor: AppColors.lightShadow,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.lightOnBackground,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: AppColors.lightOnSurface,
        ),
      ),

      // Bottom sheet theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        elevation: 8,
        shadowColor: AppColors.lightShadow,
      ),
    );
  }

  /// 🌙 DARK THEME - "Twilight Garden"
  /// Deep, soothing pastels perfect for evening plant identification
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      primaryContainer: AppColors.darkPrimary.withValues(alpha: 0.2),
      onPrimaryContainer: AppColors.darkOnBackground,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnPrimary,
      secondaryContainer: AppColors.darkSecondary.withValues(alpha: 0.2),
      onSecondaryContainer: AppColors.darkOnBackground,
      tertiary: AppColors.darkAccent,
      onTertiary: AppColors.darkOnPrimary,
      tertiaryContainer: AppColors.darkAccent.withValues(alpha: 0.2),
      onTertiaryContainer: AppColors.darkOnBackground,
      error: AppColors.error,
      onError: AppColors.darkOnPrimary,
      errorContainer: AppColors.error.withValues(alpha: 0.2),
      onErrorContainer: AppColors.darkOnBackground,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkOnSurface,
      surfaceContainerHighest: AppColors.darkSurface,
      onSurfaceVariant: AppColors.darkOnSurface.withValues(alpha: 0.7),
      outline: AppColors.darkOutline,
      outlineVariant: AppColors.darkOutline.withValues(alpha: 0.5),
      shadow: AppColors.darkShadow,
      scrim: Colors.black.withValues(alpha: 0.3),
      inverseSurface: AppColors.lightSurface,
      onInverseSurface: AppColors.lightOnSurface,
      inversePrimary: AppColors.lightPrimary,
      surfaceTint: AppColors.darkPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: AppColors.darkBackground,
      
      // AppBar with moonlit elegance
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkOnBackground,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        shadowColor: AppColors.darkShadow,
        surfaceTintColor: AppColors.darkPrimary,
        titleTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 22,
          letterSpacing: 0.5,
          color: AppColors.darkOnBackground,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.darkPrimary,
          size: 24,
        ),
      ),

      // Enhanced typography for dark mode
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: AppColors.darkOnBackground),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, color: AppColors.darkOnBackground),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.darkOnBackground),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.darkOnBackground),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.darkOnBackground),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.darkOnBackground),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkOnBackground),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.darkOnBackground),
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.darkOnBackground),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.darkOnBackground),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.darkOnBackground),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.darkOnBackground),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.darkOnBackground),
      ).copyWith(
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.darkOnSurface.withValues(alpha: 0.7)),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.darkOnSurface.withValues(alpha: 0.7)),
      ),

      // Glowing elevated buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkOnPrimary,
          shadowColor: AppColors.darkPrimary.withValues(alpha: 0.3),
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined buttons with soft glow
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          side: const BorderSide(color: AppColors.darkPrimary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Midnight elegant cards
      cardTheme: CardTheme(
        color: AppColors.darkSurface,
        shadowColor: AppColors.darkShadow,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(8),
      ),

      // Dark mode input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkOutline, width: 1),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: AppColors.darkOutline, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: AppColors.darkPrimary, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        hintStyle: TextStyle(color: AppColors.darkOnSurface.withValues(alpha: 0.6)),
      ),

      // Subtle dark dividers
      dividerTheme: DividerThemeData(
        color: AppColors.darkOutline.withValues(alpha: 0.6),
        thickness: 0.5,
        space: 1,
      ),

      // Glowing icon theme
      iconTheme: const IconThemeData(
        color: AppColors.darkPrimary,
        size: 24,
      ),

      // List tile theme for dark
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.transparent,
        selectedTileColor: AppColors.darkPrimary.withValues(alpha: 0.2),
      ),

      // Dark dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.darkSurface,
        shadowColor: AppColors.darkShadow,
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkOnBackground,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: AppColors.darkOnSurface,
        ),
      ),

      // Dark bottom sheet theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        elevation: 12,
        shadowColor: AppColors.darkShadow,
      ),
    );
  }
}

