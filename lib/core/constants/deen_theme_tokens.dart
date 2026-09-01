import 'package:flutter/material.dart';

/// Centralized semantic design tokens for DEEN Islamic App.
/// Attached to ThemeData as a ThemeExtension to ensure zero hardcoded color leakage.
class DeenThemeTokens extends ThemeExtension<DeenThemeTokens> {
  final bool isDark;

  // Backgrounds & Canvas
  final Color bgPrimary;
  final Color bgSecondary;
  final LinearGradient bgHeaderGradient;
  final LinearGradient cardGlowGradient;

  // Surfaces & Cards
  final Color surfacePrimary;
  final Color surfaceSecondary;
  final Color surfaceElevated;
  final Color cardBackground;
  final Color cardBorder;
  final Color cardShadow;
  final double cardElevation;

  // Text & Typography Colors
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color arabicPrimary;

  // Accents & Spiritual Highlights
  final Color accentPrimary;
  final Color accentSecondary;
  final Color accentGold;
  final Color accentGoldBright;
  final Color accentSageMint;
  final Color badgeBackground;
  final Color badgeBorder;

  // Navigation Bar Tokens
  final Color navBackground;
  final Color navActive;
  final Color navInactive;
  final Color navPill;
  final Color navBorder;

  // Functional / Status
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  // Illustration & Overlay treatments
  final Color illustrationTint;
  final Color illustrationGlow;
  final LinearGradient imageOverlay;

  const DeenThemeTokens({
    required this.isDark,
    required this.bgPrimary,
    required this.bgSecondary,
    required this.bgHeaderGradient,
    required this.cardGlowGradient,
    required this.surfacePrimary,
    required this.surfaceSecondary,
    required this.surfaceElevated,
    required this.cardBackground,
    required this.cardBorder,
    required this.cardShadow,
    required this.cardElevation,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.arabicPrimary,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.accentGold,
    required this.accentGoldBright,
    required this.accentSageMint,
    required this.badgeBackground,
    required this.badgeBorder,
    required this.navBackground,
    required this.navActive,
    required this.navInactive,
    required this.navPill,
    required this.navBorder,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.illustrationTint,
    required this.illustrationGlow,
    required this.imageOverlay,
  });

  @override
  DeenThemeTokens copyWith({
    bool? isDark,
    Color? bgPrimary,
    Color? bgSecondary,
    LinearGradient? bgHeaderGradient,
    LinearGradient? cardGlowGradient,
    Color? surfacePrimary,
    Color? surfaceSecondary,
    Color? surfaceElevated,
    Color? cardBackground,
    Color? cardBorder,
    Color? cardShadow,
    double? cardElevation,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? arabicPrimary,
    Color? accentPrimary,
    Color? accentSecondary,
    Color? accentGold,
    Color? accentGoldBright,
    Color? accentSageMint,
    Color? badgeBackground,
    Color? badgeBorder,
    Color? navBackground,
    Color? navActive,
    Color? navInactive,
    Color? navPill,
    Color? navBorder,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? illustrationTint,
    Color? illustrationGlow,
    LinearGradient? imageOverlay,
  }) {
    return DeenThemeTokens(
      isDark: isDark ?? this.isDark,
      bgPrimary: bgPrimary ?? this.bgPrimary,
      bgSecondary: bgSecondary ?? this.bgSecondary,
      bgHeaderGradient: bgHeaderGradient ?? this.bgHeaderGradient,
      cardGlowGradient: cardGlowGradient ?? this.cardGlowGradient,
      surfacePrimary: surfacePrimary ?? this.surfacePrimary,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      cardShadow: cardShadow ?? this.cardShadow,
      cardElevation: cardElevation ?? this.cardElevation,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      arabicPrimary: arabicPrimary ?? this.arabicPrimary,
      accentPrimary: accentPrimary ?? this.accentPrimary,
      accentSecondary: accentSecondary ?? this.accentSecondary,
      accentGold: accentGold ?? this.accentGold,
      accentGoldBright: accentGoldBright ?? this.accentGoldBright,
      accentSageMint: accentSageMint ?? this.accentSageMint,
      badgeBackground: badgeBackground ?? this.badgeBackground,
      badgeBorder: badgeBorder ?? this.badgeBorder,
      navBackground: navBackground ?? this.navBackground,
      navActive: navActive ?? this.navActive,
      navInactive: navInactive ?? this.navInactive,
      navPill: navPill ?? this.navPill,
      navBorder: navBorder ?? this.navBorder,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      illustrationTint: illustrationTint ?? this.illustrationTint,
      illustrationGlow: illustrationGlow ?? this.illustrationGlow,
      imageOverlay: imageOverlay ?? this.imageOverlay,
    );
  }

  @override
  DeenThemeTokens lerp(ThemeExtension<DeenThemeTokens>? other, double t) {
    if (other is! DeenThemeTokens) return this;
    return DeenThemeTokens(
      isDark: t < 0.5 ? isDark : other.isDark,
      bgPrimary: Color.lerp(bgPrimary, other.bgPrimary, t)!,
      bgSecondary: Color.lerp(bgSecondary, other.bgSecondary, t)!,
      bgHeaderGradient: LinearGradient.lerp(
        bgHeaderGradient,
        other.bgHeaderGradient,
        t,
      )!,
      cardGlowGradient: LinearGradient.lerp(
        cardGlowGradient,
        other.cardGlowGradient,
        t,
      )!,
      surfacePrimary: Color.lerp(surfacePrimary, other.surfacePrimary, t)!,
      surfaceSecondary: Color.lerp(
        surfaceSecondary,
        other.surfaceSecondary,
        t,
      )!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      cardElevation:
          (cardElevation + (other.cardElevation - cardElevation) * t),
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      arabicPrimary: Color.lerp(arabicPrimary, other.arabicPrimary, t)!,
      accentPrimary: Color.lerp(accentPrimary, other.accentPrimary, t)!,
      accentSecondary: Color.lerp(accentSecondary, other.accentSecondary, t)!,
      accentGold: Color.lerp(accentGold, other.accentGold, t)!,
      accentGoldBright: Color.lerp(
        accentGoldBright,
        other.accentGoldBright,
        t,
      )!,
      accentSageMint: Color.lerp(accentSageMint, other.accentSageMint, t)!,
      badgeBackground: Color.lerp(badgeBackground, other.badgeBackground, t)!,
      badgeBorder: Color.lerp(badgeBorder, other.badgeBorder, t)!,
      navBackground: Color.lerp(navBackground, other.navBackground, t)!,
      navActive: Color.lerp(navActive, other.navActive, t)!,
      navInactive: Color.lerp(navInactive, other.navInactive, t)!,
      navPill: Color.lerp(navPill, other.navPill, t)!,
      navBorder: Color.lerp(navBorder, other.navBorder, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      illustrationTint: Color.lerp(
        illustrationTint,
        other.illustrationTint,
        t,
      )!,
      illustrationGlow: Color.lerp(
        illustrationGlow,
        other.illustrationGlow,
        t,
      )!,
      imageOverlay: LinearGradient.lerp(imageOverlay, other.imageOverlay, t)!,
    );
  }
}

/// Extension for convenient access on BuildContext: context.deen
extension DeenThemeContextExtension on BuildContext {
  DeenThemeTokens get deen =>
      Theme.of(this).extension<DeenThemeTokens>() ??
      DeenThemeTokensFallback.tokens;
}

/// Safe fallback tokens in case extension is missing
class DeenThemeTokensFallback {
  static const tokens = DeenThemeTokens(
    isDark: false,
    bgPrimary: Color(0xFFF9FAF8),
    bgSecondary: Color(0xFFEFF4F0),
    bgHeaderGradient: LinearGradient(
      colors: [Color(0xFF0F5A38), Color(0xFF1B7A4E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    cardGlowGradient: LinearGradient(
      colors: [Color(0xFFE8F5EE), Color(0xFFFFFFFF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    surfacePrimary: Color(0xFFFFFFFF),
    surfaceSecondary: Color(0xFFF7FAF8),
    surfaceElevated: Color(0xFFFFFFFF),
    cardBackground: Color(0xFFFFFFFF),
    cardBorder: Color(0xFFE2ECE6),
    cardShadow: Color(0x0C122B1E),
    cardElevation: 2.0,
    textPrimary: Color(0xFF111927),
    textSecondary: Color(0xFF4B5563),
    textMuted: Color(0xFF9CA3AF),
    arabicPrimary: Color(0xFF0D5333),
    accentPrimary: Color(0xFF0F5A38),
    accentSecondary: Color(0xFF1B7A4E),
    accentGold: Color(0xFFD4AF37),
    accentGoldBright: Color(0xFFECC440),
    accentSageMint: Color(0xFFE1F1E8),
    badgeBackground: Color(0xFFEDF7F2),
    badgeBorder: Color(0xFFC8E3D4),
    navBackground: Color(0xFFFFFFFF),
    navActive: Color(0xFF0F5A38),
    navInactive: Color(0xFF889690),
    navPill: Color(0xFFE4F3EB),
    navBorder: Color(0xFFE4EDE7),
    success: Color(0xFF10B981),
    warning: Color(0xFFF59E0B),
    error: Color(0xFFEF4444),
    info: Color(0xFF3B82F6),
    illustrationTint: Color(0xFF0F5A38),
    illustrationGlow: Color(0x1A0F5A38),
    imageOverlay: LinearGradient(
      colors: [Colors.transparent, Color(0x66000000)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
}
