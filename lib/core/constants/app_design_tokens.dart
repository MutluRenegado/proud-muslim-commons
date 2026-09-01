import 'package:flutter/material.dart';

/// Centralized layout, spacing, corner radius, and shadow tokens for DEEN.
class AppSpacing {
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 12.0;
  static const double l = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 40.0;

  // Screen horizontal padding
  static const double screenMargin = 18.0;
  // Card internal padding
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardPaddingComfortable = EdgeInsets.all(20.0);
}

class AppRadius {
  static const double xs = 6.0;
  static const double s = 10.0;
  static const double m = 14.0;
  static const double l = 18.0;
  static const double xl = 24.0;
  static const double xxl = 30.0;
  static const double full = 999.0;

  static const BorderRadius roundedS = BorderRadius.all(Radius.circular(s));
  static const BorderRadius roundedM = BorderRadius.all(Radius.circular(m));
  static const BorderRadius roundedL = BorderRadius.all(Radius.circular(l));
  static const BorderRadius roundedXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius roundedFull = BorderRadius.all(
    Radius.circular(full),
  );
}

class AppShadows {
  static List<BoxShadow> soft({Color? color}) => [
        BoxShadow(
          color: color ?? Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ];

  static List<BoxShadow> elevated({Color? color}) => [
        BoxShadow(
          color: color ?? Colors.black.withOpacity(0.07),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> glow(Color color, {double radius = 16.0}) => [
        BoxShadow(
          color: color.withOpacity(0.35),
          blurRadius: radius,
          spreadRadius: 1.0,
          offset: const Offset(0, 3),
        ),
      ];
}
