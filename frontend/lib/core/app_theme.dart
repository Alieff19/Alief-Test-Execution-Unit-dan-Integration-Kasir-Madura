import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


/// A class that contains all theme configurations for the retail management application.
class AppTheme {
  AppTheme._();


  // Brand Colors
  static const Color primaryRed = Color(0xFFE53E3E);
  static const Color error          = Color(0xFFE53E3E);
  static const Color primaryOrange = Color(0xFFF56545);
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color primaryCream = Color(0xFFFBF4EA);
  static const Color textPrimary    = Color(0xFF2D3748);
  static const Color textSubtle     = Color(0xFF718096);
  static const Color border         = Color(0xFFE2E8F0);
  static const Color accentOrange = Color(0xFFF6AD55);
  static const Color balckicon = Color(0xFF2E2A2A);



  // Surface and background colors
  static const Color surface = Color(0xFFF7FAFC);


  // Status colors
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFD69E2E);

  // Shadow colors
  static const Color shadowLight = Color(0x33000000); // 20% opacity black
  static const Color shadowDark = Color(0x1AFFFFFF);

  //warna gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment(1, 0.50),
    end: Alignment(-1, 0.50),
    colors: [primaryRed, primaryOrange],
  );


  /// theme - Professional Warmth
  static ThemeData theme = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,
    textTheme: GoogleFonts.poppinsTextTheme(),
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryRed,
      onPrimary: primaryWhite,
      primaryContainer: primaryRed.withAlpha(26),
      onPrimaryContainer: primaryRed,
      secondary: accentOrange,
      onSecondary: primaryWhite,
      secondaryContainer: accentOrange.withAlpha(26),
      onSecondaryContainer: accentOrange,
      tertiary: success,
      onTertiary: primaryWhite,
      tertiaryContainer: success.withAlpha(26),
      onTertiaryContainer: success,
      error: error,
      onError: primaryWhite,
      surface: primaryWhite,
      onSurface: textPrimary,
      onSurfaceVariant: textSubtle,
      outline: border,
      outlineVariant: border.withAlpha(128),
      shadow: shadowLight,
      scrim: shadowLight,
      inverseSurface: textPrimary,
      onInverseSurface: primaryWhite,
      inversePrimary: primaryRed.withAlpha(204),
    ),
    scaffoldBackgroundColor: primaryWhite,
    cardColor: primaryWhite,
    dividerColor: border,

    // AppBar theme for professional confidence
    appBarTheme: AppBarTheme(
      backgroundColor: primaryWhite,
      foregroundColor: textPrimary,
      elevation: 0,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
    ),

    // Card theme with subtle elevation
    cardTheme: const CardThemeData(
      color: primaryWhite,
      elevation: 2.0,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom navigation for quick context switching
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primaryWhite,
      selectedItemColor: primaryRed,
      unselectedItemColor: textSubtle,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // FAB theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryRed,
      foregroundColor: primaryWhite,
      elevation: 4.0,
      shape: CircleBorder(),
    ),

    // Button themes for clear affordance
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: primaryWhite,
        backgroundColor: primaryRed,
        disabledForegroundColor: textSubtle,
        disabledBackgroundColor: border,
        elevation: 2.0,
        shadowColor: shadowLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryRed,
        disabledForegroundColor: textSubtle,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: primaryRed, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: textSubtle,
        disabledForegroundColor: textSubtle,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Typography for Indonesian character rendering



    // Input decoration for business-critical forms
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surface,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: border, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: border, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryRed, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: error, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: error, width: 2.0),
      ),
      labelStyle: GoogleFonts.poppins(
        color: textSubtle,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.poppins(
        color: textSubtle,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.poppins(
        color: error,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryRed;
        }
        return border;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryRed.withAlpha(77);
        }
        return textSubtle.withAlpha(77);
      }),
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryRed;
        }
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(primaryWhite),
      side: const BorderSide(color: border, width: 2.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryRed;
        }
        return textSubtle;
      }),
    ),

    // Progress indicator theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryRed,
      linearTrackColor: border,
      circularTrackColor: border,
    ),

    // Slider theme
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryRed,
      thumbColor: primaryRed,
      overlayColor: primaryRed.withAlpha(51),
      inactiveTrackColor: border,
      valueIndicatorColor: primaryRed,
      valueIndicatorTextStyle: GoogleFonts.poppins(
        color: primaryWhite,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Tab bar theme
    tabBarTheme: TabBarThemeData(
      labelColor: primaryRed,
      unselectedLabelColor: textSubtle,
      indicatorColor: primaryRed,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Tooltip theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimary.withAlpha(230),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.poppins(
        color: primaryWhite,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // SnackBar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimary,
      contentTextStyle: GoogleFonts.poppins(
        color: primaryWhite,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentOrange,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
    ), dialogTheme: DialogThemeData(backgroundColor: primaryWhite),
  );

  /// Dark theme - Professional confidence in low light

  /// Helper method to build text theme with Inter font family
  static TextTheme _buildTextTheme() {
    // Pakai warna tetap dari palette kamu
    const high = textPrimary;   // teks utama
    const mid  = textSubtle;    // teks sekunder
    final disabled = textSubtle.withAlpha(153);

    return TextTheme(
      // Display (judul sangat besar)
      displayLarge: GoogleFonts.poppins(fontSize: 57, fontWeight: FontWeight.w700, color: high, letterSpacing: -0.25),
      displayMedium: GoogleFonts.poppins(fontSize: 45, fontWeight: FontWeight.w700, color: high),
      displaySmall:  GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w600, color: high),

      // Headline (section header)
      headlineLarge:  GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w600, color: high),
      headlineMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w600, color: high),
      headlineSmall:  GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: high),

      // Title (judul komponen/kartu)
      titleLarge:  GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: high, letterSpacing: 0),
      titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: high, letterSpacing: 0.15),
      titleSmall:  GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: high, letterSpacing: 0.1),

      // Body (isi konten)
      bodyLarge:  GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: high, letterSpacing: 0.5),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: high, letterSpacing: 0.25),
      bodySmall:  GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: mid,  letterSpacing: 0.4),

      // Label (tombol/teks kecil)
      labelLarge:  GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: high,     letterSpacing: 0.1),
      labelMedium: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: mid,      letterSpacing: 0.5),
      labelSmall:  GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: disabled, letterSpacing: 0.5),
    );
  }
}

