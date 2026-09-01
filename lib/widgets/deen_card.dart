import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/constants/deen_theme_tokens.dart';
import '../core/constants/app_design_tokens.dart';

/// Universal theme-aware responsive Card container for DEEN.
class DeenCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool isHero;
  final bool isSelected;
  final Color? customBackground;
  final Color? customBorderColor;
  final LinearGradient? gradient;
  final double? borderRadius;

  const DeenCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.isHero = false,
    this.isSelected = false,
    this.customBackground,
    this.customBorderColor,
    this.gradient,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    final radiusVal = borderRadius ?? (isHero ? AppRadius.xl : AppRadius.l);
    final borderRad = BorderRadius.circular(radiusVal);

    Color bg;
    if (customBackground != null) {
      bg = customBackground!;
    } else if (isSelected) {
      bg = deen.isDark ? deen.surfaceElevated : deen.badgeBackground;
    } else if (isHero) {
      bg = deen.surfaceElevated;
    } else {
      bg = deen.cardBackground;
    }

    Color borderColor;
    if (customBorderColor != null) {
      borderColor = customBorderColor!;
    } else if (isSelected) {
      borderColor = deen.accentGold;
    } else if (isHero) {
      borderColor =
          deen.isDark ? deen.accentGold.withOpacity(0.35) : deen.cardBorder;
    } else {
      borderColor = deen.cardBorder;
    }

    List<BoxShadow> shadows = [];
    if (isSelected) {
      shadows = AppShadows.glow(deen.accentGold, radius: 14);
    } else if (isHero) {
      shadows = [
        BoxShadow(
          color: deen.cardShadow,
          blurRadius: 22,
          spreadRadius: -3,
          offset: const Offset(0, 11),
        ),
        BoxShadow(
          color: Colors.white.withOpacity(deen.isDark ? 0.06 : 0.65),
          blurRadius: 4,
          offset: const Offset(-2, -2),
        ),
      ];
    } else {
      shadows = [
        BoxShadow(
          color: deen.cardShadow,
          blurRadius: 15,
          spreadRadius: -3,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.white.withOpacity(deen.isDark ? 0.05 : 0.55),
          blurRadius: 3,
          offset: const Offset(-2, -2),
        ),
      ];
    }

    final effectiveGradient = gradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(
              Colors.white.withOpacity(deen.isDark ? 0.035 : 0.20),
              bg,
            ),
            bg,
            Color.alphaBlend(
              Colors.black.withOpacity(deen.isDark ? 0.10 : 0.035),
              bg,
            ),
          ],
        );

    final isGlassTheme = deen.cardBackground.a < 1.0;

    Widget cardSurface = Material(
      color: Colors.transparent,
      borderRadius: borderRad,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRad,
        splashColor: onTap != null
            ? deen.accentPrimary.withOpacity(0.12)
            : Colors.transparent,
        highlightColor: onTap != null
            ? deen.accentPrimary.withOpacity(0.06)
            : Colors.transparent,
        child: Container(
          padding: padding ?? AppSpacing.cardPadding,
          decoration: BoxDecoration(
            gradient: effectiveGradient,
            borderRadius: borderRad,
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.6 : 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );

    if (isGlassTheme) {
      cardSurface = ClipRRect(
        borderRadius: borderRad,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: deen.isDark ? 18 : 14,
            sigmaY: deen.isDark ? 18 : 14,
          ),
          child: cardSurface,
        ),
      );
    }

    Widget content = Container(
      decoration: BoxDecoration(borderRadius: borderRad, boxShadow: shadows),
      child: cardSurface,
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}
