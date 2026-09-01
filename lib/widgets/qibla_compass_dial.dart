import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/constants/deen_theme_tokens.dart';

class QiblaCompassDial extends StatelessWidget {
  final double heading; // Device compass heading in degrees (0..360)
  final double qiblaBearing; // True Kaaba bearing in degrees (0..360)
  final bool isAligned;
  final double size;

  const QiblaCompassDial({
    super.key,
    required this.heading,
    required this.qiblaBearing,
    required this.isAligned,
    this.size = 300.0,
  });

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;

    // Angle of dial rotation (-heading in radians)
    final dialRotation = -heading * (math.pi / 180.0);
    // Angle of Qibla relative to device screen (qiblaBearing - heading in radians)
    final qiblaRelativeAngle = (qiblaBearing - heading) * (math.pi / 180.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Glowing Outer Ring when Aligned
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isAligned
                      ? deen.accentGold.withOpacity(0.5)
                      : deen.accentPrimary.withOpacity(0.12),
                  blurRadius: isAligned ? 30 : 14,
                  spreadRadius: isAligned ? 6 : 1,
                ),
              ],
            ),
          ),

          // 2. Rotating Compass Dial (ticks, degrees, cardinals)
          Transform.rotate(
            angle: dialRotation,
            child: CustomPaint(
              size: Size(size, size),
              painter: _CompassDialPainter(
                primaryColor: deen.accentPrimary,
                surfaceColor: deen.cardBackground,
                textColor: deen.textPrimary,
                outlineColor: deen.cardBorder,
                goldColor: deen.accentGold,
                isDark: deen.isDark,
                isAligned: isAligned,
              ),
            ),
          ),

          // 3. Rotating Qibla Needle pointing towards Kaaba
          Transform.rotate(
            angle: qiblaRelativeAngle,
            child: SizedBox(
              width: size,
              height: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Needle Stem
                  Positioned(
                    top: size * 0.16,
                    child: Container(
                      width: 4,
                      height: size * 0.34,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            deen.accentGold,
                            deen.accentPrimary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: deen.accentGold.withOpacity(0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Kaaba Head Badge
                  Positioned(
                    top: size * 0.08,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isAligned ? deen.accentGold : deen.accentPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isAligned ? Colors.white : deen.accentGold,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: deen.accentGold.withOpacity(0.6),
                            blurRadius: 10,
                            spreadRadius: isAligned ? 3 : 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.mosque_rounded,
                          size: 20,
                          color: isAligned ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Fixed Top Device Heading Needle Marker
          Positioned(
            top: 2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: deen.accentGold,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Colors.black38, blurRadius: 4),
                ],
              ),
              child: const Icon(
                Icons.arrow_drop_down,
                size: 16,
                color: Colors.black,
              ),
            ),
          ),

          // 5. Central Golden Hub Pivot
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: deen.accentPrimary,
              shape: BoxShape.circle,
              border: Border.all(color: deen.accentGold, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: deen.accentGold,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompassDialPainter extends CustomPainter {
  final Color primaryColor;
  final Color surfaceColor;
  final Color textColor;
  final Color outlineColor;
  final Color goldColor;
  final bool isDark;
  final bool isAligned;

  _CompassDialPainter({
    required this.primaryColor,
    required this.surfaceColor,
    required this.textColor,
    required this.outlineColor,
    required this.goldColor,
    required this.isDark,
    required this.isAligned,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Compass Surface Background
    final bgPaint = Paint()
      ..color = surfaceColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 4, bgPaint);

    // 2. Concentric Outer Decorative Ring
    final outerRingPaint = Paint()
      ..color = isAligned
          ? goldColor
          : (isDark
              ? Colors.white.withOpacity(0.12)
              : Colors.black.withOpacity(0.1))
      ..style = PaintingStyle.stroke
      ..strokeWidth = isAligned ? 2.5 : 1.5;
    canvas.drawCircle(center, radius - 6, outerRingPaint);

    // Inner Concentric Ring
    final innerRingPaint = Paint()
      ..color = isAligned
          ? goldColor.withOpacity(0.5)
          : primaryColor.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, radius * 0.65, innerRingPaint);

    // 3. Ticks & Degree Markings
    final tickPaint = Paint()..style = PaintingStyle.stroke;

    for (int deg = 0; deg < 360; deg += 5) {
      final isMajor = deg % 30 == 0;
      final isCardinal = deg % 90 == 0;
      final angle = deg * (math.pi / 180.0);

      tickPaint.strokeWidth = isCardinal ? 2.5 : (isMajor ? 1.5 : 0.8);
      tickPaint.color = isCardinal
          ? (deg == 0 ? Colors.redAccent : goldColor)
          : (isMajor
              ? textColor.withOpacity(0.6)
              : textColor.withOpacity(0.25));

      final tickLength = isCardinal ? 14.0 : (isMajor ? 9.0 : 5.0);
      final outerPoint = Offset(
        center.dx + (radius - 8) * math.sin(angle),
        center.dy - (radius - 8) * math.cos(angle),
      );
      final innerPoint = Offset(
        center.dx + (radius - 8 - tickLength) * math.sin(angle),
        center.dy - (radius - 8 - tickLength) * math.cos(angle),
      );

      canvas.drawLine(outerPoint, innerPoint, tickPaint);

      // Cardinal Labels (N, E, S, W)
      if (isCardinal) {
        String label;
        Color labelColor;
        switch (deg) {
          case 0:
            label = 'N';
            labelColor = Colors.redAccent;
            break;
          case 90:
            label = 'E';
            labelColor = goldColor;
            break;
          case 180:
            label = 'S';
            labelColor = goldColor;
            break;
          case 270:
            label = 'W';
            labelColor = goldColor;
            break;
          default:
            label = '';
            labelColor = textColor;
        }

        final textSpan = TextSpan(
          text: label,
          style: TextStyle(
            color: labelColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        final labelRadius = radius - 32;
        final labelPos = Offset(
          center.dx + labelRadius * math.sin(angle) - (textPainter.width / 2),
          center.dy - labelRadius * math.cos(angle) - (textPainter.height / 2),
        );
        textPainter.paint(canvas, labelPos);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CompassDialPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.surfaceColor != surfaceColor ||
        oldDelegate.isAligned != isAligned ||
        oldDelegate.isDark != isDark;
  }
}
