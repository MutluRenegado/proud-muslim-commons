import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'deen_theme_tokens.dart';

enum AppThemeType {
  theme1, // Light Classic (Emerald & Ivory White)
  theme2, // Soft Emerald (Botanical Mint & Pale Sage)
  theme3, // Black / Emerald / Gold (Imperial Night & Radiant Gold)
  theme4, // Full Dark Minimal (Obsidian Slate & Champagne Gold)
}

extension AppThemeTypeExtension on AppThemeType {
  String get id => name;

  String get title {
    switch (this) {
      case AppThemeType.theme1:
        return 'Light Classic';
      case AppThemeType.theme2:
        return 'Soft Emerald';
      case AppThemeType.theme3:
        return 'Imperial Gold';
      case AppThemeType.theme4:
        return 'Dark Minimal';
    }
  }

  String get subtitle {
    switch (this) {
      case AppThemeType.theme1:
        return 'Ivory canvas with luminous forest emerald & gold';
      case AppThemeType.theme2:
        return 'Frosted sea-glass with botanical teal & mint';
      case AppThemeType.theme3:
        return 'Atmospheric deep night with radiant imperial gold';
      case AppThemeType.theme4:
        return 'Smoked graphite glass with cool ice-silver accents';
    }
  }

  bool get isDark {
    switch (this) {
      case AppThemeType.theme1:
      case AppThemeType.theme2:
        return false;
      case AppThemeType.theme3:
      case AppThemeType.theme4:
        return true;
    }
  }

  Color get previewPrimary {
    switch (this) {
      case AppThemeType.theme1:
        return AppColors.theme1Primary;
      case AppThemeType.theme2:
        return AppColors.theme2Primary;
      case AppThemeType.theme3:
        return AppColors.theme3Gold;
      case AppThemeType.theme4:
        return AppColors.theme4Primary;
    }
  }

  Color get previewBackground {
    switch (this) {
      case AppThemeType.theme1:
        return AppColors.theme1Background;
      case AppThemeType.theme2:
        return AppColors.theme2Background;
      case AppThemeType.theme3:
        return AppColors.theme3Background;
      case AppThemeType.theme4:
        return AppColors.theme4Background;
    }
  }

  Color get previewSurface {
    switch (this) {
      case AppThemeType.theme1:
        return AppColors.theme1Surface;
      case AppThemeType.theme2:
        return AppColors.theme2Card;
      case AppThemeType.theme3:
        return AppColors.theme3Surface;
      case AppThemeType.theme4:
        return AppColors.theme4Surface;
    }
  }

  LinearGradient get headerGradient {
    switch (this) {
      case AppThemeType.theme1:
        return AppColors.emeraldGradient;
      case AppThemeType.theme2:
        return AppColors.softEmeraldGradient;
      case AppThemeType.theme3:
        return AppColors.imperialGradient;
      case AppThemeType.theme4:
        return AppColors.minimalDarkGradient;
    }
  }
}

class AppTheme {
  static ThemeData getTheme(AppThemeType type) {
    switch (type) {
      case AppThemeType.theme1:
        return theme1;
      case AppThemeType.theme2:
        return theme2;
      case AppThemeType.theme3:
        return theme3;
      case AppThemeType.theme4:
        return theme4;
    }
  }

  // =========================================================================
  // THEME 1 — Light Classic (Ivory & Luminous Emerald)
  // =========================================================================
  static ThemeData get theme1 {
    final base = ThemeData.light(useMaterial3: true);
    const tokens = DeenThemeTokens(
      isDark: false,
      bgPrimary: AppColors.theme1Background,
      bgSecondary: Color(0xFFEFF4F0),
      bgHeaderGradient: AppColors.emeraldGradient,
      cardGlowGradient: LinearGradient(
        colors: [Color(0xFFEAF5EF), Color(0xFFFFFFFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      surfacePrimary: AppColors.theme1Surface,
      surfaceSecondary: Color(0xFFF7FAF8),
      surfaceElevated: Color(0xFFFFFFFF),
      cardBackground: AppColors.theme1Card,
      cardBorder: AppColors.theme1Border,
      cardShadow: Color(0x0A0D6A42),
      cardElevation: 1.5,
      textPrimary: AppColors.theme1TextPrimary,
      textSecondary: AppColors.theme1TextSecondary,
      textMuted: Color(0xFF94A3B8),
      arabicPrimary: Color(0xFF0A5736),
      accentPrimary: AppColors.theme1Primary,
      accentSecondary: AppColors.theme1Secondary,
      accentGold: AppColors.gold,
      accentGoldBright: Color(0xFFECC440),
      accentSageMint: Color(0xFFE2F2E9),
      badgeBackground: Color(0xFFEAF5EE),
      badgeBorder: Color(0xFFC7E4D3),
      navBackground: Color(0xFFFFFFFF),
      navActive: AppColors.theme1Primary,
      navInactive: Color(0xFF8B9E96),
      navPill: Color(0xFFE5F4EC),
      navBorder: Color(0xFFE2ECE6),
      success: AppColors.success,
      warning: AppColors.warning,
      error: AppColors.error,
      info: AppColors.info,
      illustrationTint: AppColors.theme1Primary,
      illustrationGlow: Color(0x180D6A42),
      imageOverlay: LinearGradient(
        colors: [Colors.transparent, Color(0x55000000)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );

    return base.copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: tokens.bgPrimary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.theme1Primary,
        secondary: AppColors.theme1Secondary,
        surface: AppColors.theme1Surface,
        surfaceContainerHighest: AppColors.theme1CardElevated,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.theme1TextPrimary,
        outline: AppColors.theme1Border,
      ),
      extensions: [tokens],
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: AppColors.theme1TextPrimary,
        ),
        displayMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: AppColors.theme1TextPrimary,
        ),
        titleLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.w700,
          color: AppColors.theme1TextPrimary,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          color: AppColors.theme1TextPrimary,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          color: AppColors.theme1TextPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          color: AppColors.theme1TextSecondary,
          height: 1.4,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.surfacePrimary,
        foregroundColor: tokens.textPrimary,
        elevation: 4,
        scrolledUnderElevation: 8,
        shadowColor: Colors.black26,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: tokens.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: tokens.cardBackground,
        elevation: 8,
        shadowColor: Colors.black26,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.theme1Border, width: 1),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.theme1Surface,
        selectedItemColor: AppColors.theme1Primary,
        unselectedItemColor: Color(0xFF8B9E96),
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
    );
  }

  // =========================================================================
  // THEME 2 — Soft Emerald (Botanical Mint & Pale Sage)
  // =========================================================================
  static ThemeData get theme2 {
    final base = ThemeData.light(useMaterial3: true);
    const tokens = DeenThemeTokens(
      isDark: false,
      bgPrimary: AppColors.theme2Background,
      bgSecondary: Color(0xFFCFE9DC),
      bgHeaderGradient: AppColors.softEmeraldGradient,
      cardGlowGradient: LinearGradient(
        colors: [Color(0xFFCDEBDB), Color(0xFFF9FFFC)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      surfacePrimary: AppColors.theme2Surface,
      surfaceSecondary: Color(0xFFECF9F2),
      surfaceElevated: Color(0xDDF9FFFC),
      cardBackground: AppColors.theme2Card,
      cardBorder: AppColors.theme2Border,
      cardShadow: Color(0x33004E46),
      cardElevation: 3.0,
      textPrimary: AppColors.theme2TextPrimary,
      textSecondary: AppColors.theme2TextSecondary,
      textMuted: Color(0xFF6E9185),
      arabicPrimary: Color(0xFF004E46),
      accentPrimary: AppColors.theme2Primary,
      accentSecondary: AppColors.theme2Secondary,
      accentGold: Color(0xFFE2A93B),
      accentGoldBright: Color(0xFFF4C866),
      accentSageMint: Color(0xFFBFE5D2),
      badgeBackground: Color(0xFFD7F1E4),
      badgeBorder: Color(0xFF95CCB2),
      navBackground: Color(0xFFF5FFF9),
      navActive: AppColors.theme2Primary,
      navInactive: Color(0xFF66897E),
      navPill: Color(0xFFC9EDDA),
      navBorder: Color(0xFFAED8C5),
      success: AppColors.success,
      warning: AppColors.warning,
      error: AppColors.error,
      info: AppColors.info,
      illustrationTint: AppColors.theme2Primary,
      illustrationGlow: Color(0x30006B5B),
      imageOverlay: LinearGradient(
        colors: [Colors.transparent, Color(0x6600332C)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );

    return base.copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: tokens.bgPrimary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.theme2Primary,
        secondary: AppColors.theme2Secondary,
        surface: AppColors.theme2Surface,
        surfaceContainerHighest: AppColors.theme2CardElevated,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.theme2TextPrimary,
        outline: AppColors.theme2Border,
      ),
      extensions: [tokens],
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: AppColors.theme2TextPrimary,
        ),
        displayMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: AppColors.theme2TextPrimary,
        ),
        titleLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.w700,
          color: AppColors.theme2TextPrimary,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          color: AppColors.theme2TextPrimary,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          color: AppColors.theme2TextPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          color: AppColors.theme2TextSecondary,
          height: 1.4,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.surfacePrimary,
        foregroundColor: tokens.textPrimary,
        elevation: 4,
        scrolledUnderElevation: 8,
        shadowColor: Colors.black26,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: tokens.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: tokens.cardBackground,
        elevation: 8,
        shadowColor: Colors.black26,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.theme2Border, width: 1),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.theme2Surface,
        selectedItemColor: AppColors.theme2Primary,
        unselectedItemColor: Color(0xFF66897E),
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
    );
  }

  // =========================================================================
  // THEME 3 — Black / Emerald / Gold (Imperial Atmosphere & Radiant Gold)
  // =========================================================================
  static ThemeData get theme3 {
    final base = ThemeData.dark(useMaterial3: true);
    const tokens = DeenThemeTokens(
      isDark: true,
      bgPrimary: AppColors.theme3Background,
      bgSecondary: Color(0xFF0E1817),
      bgHeaderGradient: AppColors.imperialGradient,
      cardGlowGradient: LinearGradient(
        colors: [Color(0xFF19322D), Color(0xFF101F1C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      surfacePrimary: AppColors.theme3Surface,
      surfaceSecondary: Color(0xFF172925),
      surfaceElevated: AppColors.theme3CardElevated,
      cardBackground: AppColors.theme3Card,
      cardBorder: AppColors.theme3Border,
      cardShadow: Color(0x33000000),
      cardElevation: 2.0,
      textPrimary: AppColors.theme3TextPrimary,
      textSecondary: AppColors.theme3TextSecondary,
      textMuted: Color(0xFF758A84),
      arabicPrimary: AppColors.theme3Gold,
      accentPrimary: AppColors.theme3Gold,
      accentSecondary: AppColors.theme3Emerald,
      accentGold: AppColors.theme3Gold,
      accentGoldBright: AppColors.theme3GoldBright,
      accentSageMint: Color(0xFF22473F),
      badgeBackground: Color(0xFF1E3832),
      badgeBorder: Color(0xFF335C52),
      navBackground: Color(0xFF0D1816),
      navActive: AppColors.theme3Gold,
      navInactive: Color(0xFF7C948D),
      navPill: Color(0xFF213630),
      navBorder: Color(0xFF253B36),
      success: AppColors.success,
      warning: AppColors.warning,
      error: AppColors.error,
      info: AppColors.info,
      illustrationTint: AppColors.theme3Gold,
      illustrationGlow: Color(0x33E5C158),
      imageOverlay: LinearGradient(
        colors: [Colors.transparent, Color(0x880A1211)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );

    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: tokens.bgPrimary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.theme3Gold,
        secondary: AppColors.theme3Emerald,
        surface: AppColors.theme3Surface,
        surfaceContainerHighest: AppColors.theme3CardElevated,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: AppColors.theme3TextPrimary,
        outline: AppColors.theme3Border,
      ),
      extensions: [tokens],
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: AppColors.theme3TextPrimary,
        ),
        displayMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: AppColors.theme3TextPrimary,
        ),
        titleLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.w700,
          color: AppColors.theme3Gold,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          color: AppColors.theme3TextPrimary,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          color: AppColors.theme3TextPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          color: AppColors.theme3TextSecondary,
          height: 1.4,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.bgPrimary,
        foregroundColor: tokens.accentGold,
        elevation: 4,
        scrolledUnderElevation: 8,
        shadowColor: Colors.black54,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: tokens.accentGold,
        ),
      ),
      cardTheme: CardThemeData(
        color: tokens.cardBackground,
        elevation: 8,
        shadowColor: Colors.black54,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.theme3Border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.theme3Gold,
          foregroundColor: Colors.black,
          elevation: 8,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0D1816),
        selectedItemColor: AppColors.theme3Gold,
        unselectedItemColor: Color(0xFF7C948D),
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
    );
  }

  // =========================================================================
  // THEME 4 — Full Dark Minimal (Graphite, Gunmetal & Ice Silver)
  // =========================================================================
  static ThemeData get theme4 {
    final base = ThemeData.dark(useMaterial3: true);
    const tokens = DeenThemeTokens(
      isDark: true,
      bgPrimary: AppColors.theme4Background,
      bgSecondary: Color(0xFF11141A),
      bgHeaderGradient: AppColors.minimalDarkGradient,
      cardGlowGradient: LinearGradient(
        colors: [Color(0xFF2A303C), Color(0xFF15181E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      surfacePrimary: AppColors.theme4Surface,
      surfaceSecondary: Color(0xE01D212A),
      surfaceElevated: AppColors.theme4CardElevated,
      cardBackground: AppColors.theme4Card,
      cardBorder: AppColors.theme4Border,
      cardShadow: Color(0x40000000),
      cardElevation: 2.0,
      textPrimary: AppColors.theme4TextPrimary,
      textSecondary: AppColors.theme4TextSecondary,
      textMuted: Color(0xFF687385),
      arabicPrimary: AppColors.theme4Primary,
      accentPrimary: AppColors.theme4Primary,
      accentSecondary: AppColors.theme4Secondary,
      accentGold: AppColors.theme4Primary,
      accentGoldBright: Color(0xFFF4F7FB),
      accentSageMint: Color(0xFF29313E),
      badgeBackground: Color(0xFF242A35),
      badgeBorder: Color(0xFF414B5C),
      navBackground: Color(0xFF101218),
      navActive: AppColors.theme4Primary,
      navInactive: Color(0xFF748095),
      navPill: Color(0xFF29303C),
      navBorder: Color(0xFF303744),
      success: AppColors.success,
      warning: AppColors.warning,
      error: AppColors.error,
      info: AppColors.info,
      illustrationTint: AppColors.theme4Primary,
      illustrationGlow: Color(0x337891B2),
      imageOverlay: LinearGradient(
        colors: [Colors.transparent, Color(0xAA090B0F)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );

    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: tokens.bgPrimary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.theme4Primary,
        secondary: AppColors.theme4Secondary,
        surface: AppColors.theme4Surface,
        surfaceContainerHighest: AppColors.theme4CardElevated,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: AppColors.theme4TextPrimary,
        outline: AppColors.theme4Border,
      ),
      extensions: [tokens],
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: AppColors.theme4TextPrimary,
        ),
        displayMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: AppColors.theme4TextPrimary,
        ),
        titleLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.w700,
          color: AppColors.theme4TextPrimary,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          color: AppColors.theme4TextPrimary,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          color: AppColors.theme4TextPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          color: AppColors.theme4TextSecondary,
          height: 1.4,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.surfacePrimary,
        foregroundColor: tokens.accentGold,
        elevation: 4,
        scrolledUnderElevation: 8,
        shadowColor: Colors.black54,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: tokens.accentGold,
        ),
      ),
      cardTheme: CardThemeData(
        color: tokens.cardBackground,
        elevation: 8,
        shadowColor: Colors.black54,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.theme4Border, width: 1),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF101218),
        selectedItemColor: AppColors.theme4Primary,
        unselectedItemColor: Color(0xFF748095),
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
    );
  }

  // Backward compatibility getters
  static ThemeData get lightTheme => theme1;
  static ThemeData get darkTheme => theme3;
}
