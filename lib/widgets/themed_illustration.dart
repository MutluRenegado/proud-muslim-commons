import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/constants/deen_theme_tokens.dart';

enum DeenIllustration {
  mosqueDawn('assets/images/illustrations/mosque_dawn.svg'),
  mosqueNight('assets/images/illustrations/mosque_night.svg'),
  quranRehal('assets/images/illustrations/quran_rehal.svg'),
  kaabaMecca('assets/images/illustrations/kaaba_mecca.svg'),
  prayerMat('assets/images/illustrations/prayer_mat.svg'),
  lantern('assets/images/illustrations/islamic_lantern.svg'),
  crescentStars('assets/images/illustrations/crescent_stars.svg'),
  tasbihBeads('assets/images/illustrations/tasbih_beads.svg'),
  duaHands('assets/images/illustrations/dua_hands.svg'),
  islamicArch('assets/images/illustrations/islamic_arch.svg');

  final String assetPath;
  const DeenIllustration(this.assetPath);
}

/// A theme-aware illustration widget that tints vectors appropriately according to active DEEN theme.
class ThemedIllustration extends StatelessWidget {
  final DeenIllustration illustration;
  final double size;
  final Color? customColor;
  final bool withGlow;
  final BoxFit fit;

  const ThemedIllustration({
    super.key,
    required this.illustration,
    this.size = 48.0,
    this.customColor,
    this.withGlow = false,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    final primaryColor = customColor ?? deen.illustrationTint;

    final svgWidget = SvgPicture.asset(
      illustration.assetPath,
      width: size,
      height: size,
      fit: fit,
      colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
    );

    if (!withGlow) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(child: svgWidget),
      );
    }

    return Container(
      width: size + 16,
      height: size + 16,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: deen.illustrationGlow,
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: svgWidget,
    );
  }
}
