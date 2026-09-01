import 'package:flutter/material.dart';

class AppColors {
  // =========================================================================
  // THEME 1 — Light Classic (Ivory canvas, luminous forest emerald, gold accents)
  // =========================================================================
  static const Color theme1Primary = Color(0xFF0D6A42);
  static const Color theme1Secondary = Color(0xFF168354);
  static const Color theme1Surface = Color(0xFFFFFFFF);
  static const Color theme1Background = Color(0xFFF9FAF8);
  static const Color theme1Card = Color(0xFFFFFFFF);
  static const Color theme1CardElevated = Color(0xFFF2F7F4);
  static const Color theme1Border = Color(0xFFE2ECE6);
  static const Color theme1TextPrimary = Color(0xFF101928);
  static const Color theme1TextSecondary = Color(0xFF4B5768);

  // =========================================================================
  // THEME 2 — Soft Emerald (Pale sage canvas, serene botanical teal, mint accents)
  // =========================================================================
  static const Color theme2Primary = Color(0xFF006B5B);
  static const Color theme2Secondary = Color(0xFF45A989);
  static const Color theme2Surface = Color(0xE8F7FFFB);
  static const Color theme2Background = Color(0xFFE1F3EA);
  static const Color theme2Card = Color(0xCFF8FFFB);
  static const Color theme2CardElevated = Color(0xD9D2EBDD);
  static const Color theme2Border = Color(0xFFA9D6C1);
  static const Color theme2TextPrimary = Color(0xFF073B32);
  static const Color theme2TextSecondary = Color(0xFF3B665A);

  // =========================================================================
  // THEME 3 — Black / Emerald / Gold (Atmospheric deep night, layered tonal surfaces, radiant imperial gold)
  // =========================================================================
  static const Color theme3Gold = Color(0xFFE5C158);
  static const Color theme3GoldBright = Color(0xFFFFD866);
  static const Color theme3Emerald = Color(0xFF1E6758);
  static const Color theme3EmeraldDark = Color(0xFF123E35);
  static const Color theme3Background = Color(0xFF0A1211);
  static const Color theme3Surface = Color(0xFF12201D);
  static const Color theme3Card = Color(0xFF12201D);
  static const Color theme3CardElevated = Color(0xFF1A2D2A);
  static const Color theme3Border = Color(0xFF28413B);
  static const Color theme3TextPrimary = Color(0xFFF9FBFA);
  static const Color theme3TextSecondary = Color(0xFFB4C4BF);

  // =========================================================================
  // THEME 4 — Full Dark Minimal (graphite canvas, gunmetal cards, ice-silver accents)
  // =========================================================================
  static const Color theme4Primary = Color(0xFFD9E2F0);
  static const Color theme4Secondary = Color(0xFF7891B2);
  static const Color theme4Surface = Color(0xE6181B21);
  static const Color theme4Background = Color(0xFF090B0F);
  static const Color theme4Card = Color(0xD1171A20);
  static const Color theme4CardElevated = Color(0xDC232833);
  static const Color theme4Border = Color(0xFF353C49);
  static const Color theme4TextPrimary = Color(0xFFF1F4F8);
  static const Color theme4TextSecondary = Color(0xFF9EA9B8);

  // =========================================================================
  // Shared Universal Gold & Accents
  // =========================================================================
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF3E5AB);
  static const Color goldDark = Color(0xFFAA820A);
  static const Color amberAccent = Color(0xFFFFBF00);

  // Backward-compatible palette aliases
  static const Color primaryEmerald = Color(0xFF0D6A42);
  static const Color primaryEmeraldLight = Color(0xFF168354);
  static const Color primaryEmeraldDark = Color(0xFF0A4E31);
  static const Color primaryEmeraldAccent = Color(0xFF20C997);

  static const Color darkBackground = Color(0xFF0A1211);
  static const Color darkSurface = Color(0xFF12201D);
  static const Color darkCard = Color(0xFF12201D);
  static const Color darkCardElevated = Color(0xFF1A2D2A);

  static const Color lightBackground = Color(0xFFF9FAF8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2ECE6);

  static const Color textPrimaryLight = Color(0xFF101928);
  static const Color textSecondaryLight = Color(0xFF4B5768);
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFFA0AEC0);

  // Functional / Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Dynamic Gradients
  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [Color(0xFF0C5C39), Color(0xFF177F52)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient softEmeraldGradient = LinearGradient(
    colors: [Color(0xFF004E46), Color(0xFF35A77F), Color(0xFF82D2AD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient imperialGradient = LinearGradient(
    colors: [Color(0xFF142B25), Color(0xFF081210)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient minimalDarkGradient = LinearGradient(
    colors: [Color(0xFF303746), Color(0xFF171B23), Color(0xFF080A0E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFECC440), Color(0xFFBA9225)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient midnightGradient = LinearGradient(
    colors: [Color(0xFF0A1412), Color(0xFF162E28)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGlowGradient = LinearGradient(
    colors: [Color(0xFF1C3A33), Color(0xFF122420)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
