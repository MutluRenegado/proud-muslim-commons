import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../core/services/location_service.dart';
import '../../core/services/qibla_service.dart';
import '../../providers/prayer_provider.dart';
import '../../widgets/qibla_compass_dial.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/themed_illustration.dart';
import '../../widgets/localized_help_icon.dart';

import '../../l10n/app_localizations.dart';
import '../../core/services/ui_translation_service.dart';

import '../../core/services/compass_sensor_service.dart';

class QiblaView extends StatefulWidget {
  const QiblaView({super.key});

  @override
  State<QiblaView> createState() => _QiblaViewState();
}

class _QiblaViewState extends State<QiblaView> {
  StreamSubscription<double>? _headingSubscription;
  double _smoothedHeading = 0.0;
  double? _accuracy;
  bool _hasCompassSensor = true;
  bool _isLoading = true;
  bool _wasAligned = false;
  bool _isRefreshingLocation = false;
  bool _firstHeadingReceived = false;

  @override
  void initState() {
    super.initState();
    _initCompass();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prayerProv = Provider.of<PrayerProvider>(context, listen: false);
      if (prayerProv.locationMode == 'auto') {
        _autoSyncLocation(prayerProv);
      }
    });
  }

  Future<void> _autoSyncLocation(PrayerProvider prayerProv) async {
    try {
      final pos = await LocationService.requestDeviceLocation(context);
      if (pos != null && mounted) {
        final cityPreset = LocationService.findNearestCity(
          pos.latitude,
          pos.longitude,
        );
        prayerProv.updateLocation(
          pos.latitude,
          pos.longitude,
          cityPreset.city,
          cityPreset.country,
          mode: 'auto',
        );
      }
    } catch (_) {}
  }

  void _initCompass() {
    CompassSensorService.startListening();
    _headingSubscription = CompassSensorService.headingStream.listen(
      (rawHeading) {
        if (!mounted) return;

        final raw = (rawHeading + 360.0) % 360.0;
        final smoothed = _firstHeadingReceived
            ? QiblaService.smoothHeading(
                _smoothedHeading,
                raw,
                alpha: 0.35,
              )
            : raw;
        _firstHeadingReceived = true;

        setState(() {
          _hasCompassSensor = true;
          _isLoading = false;
          _smoothedHeading = smoothed;
        });
      },
      onError: (err) {
        if (!mounted) return;
        setState(() {
          _hasCompassSensor = false;
          _isLoading = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _headingSubscription?.cancel();
    CompassSensorService.stopListening();
    super.dispose();
  }

  Future<void> _refreshGpsLocation(
    BuildContext ctx,
    PrayerProvider prayerProv,
    DeenThemeTokens deen,
  ) async {
    setState(() => _isRefreshingLocation = true);
    final pos = await LocationService.requestDeviceLocation(ctx);
    if (!mounted) return;
    if (pos != null) {
      final cityPreset = LocationService.findNearestCity(
        pos.latitude,
        pos.longitude,
      );
      prayerProv.updateLocation(
        pos.latitude,
        pos.longitude,
        cityPreset.city,
        cityPreset.country,
        mode: 'auto',
      );
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              'Location updated: ${cityPreset.city}, ${cityPreset.country}',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
            ),
            backgroundColor: deen.accentPrimary,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
    setState(() => _isRefreshingLocation = false);
  }

  @override
  Widget build(BuildContext context) {
    final prayerProv = Provider.of<PrayerProvider>(context);
    final qiblaBearing = QiblaService.calculateQiblaBearing(
      prayerProv.latitude,
      prayerProv.longitude,
    );
    final distanceKm = QiblaService.calculateDistanceToMakkah(
      prayerProv.latitude,
      prayerProv.longitude,
    );

    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final langCode = Localizations.localeOf(context).languageCode;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final relativeDiff = QiblaService.calculateRelativeAngle(
      _smoothedHeading,
      qiblaBearing,
    );
    final isAligned = relativeDiff.abs() <= 4.0;

    // Trigger haptic vibration on entering alignment
    if (isAligned && !_wasAligned) {
      HapticFeedback.mediumImpact();
    }
    _wasAligned = isAligned;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          l10n.qiblaCompass,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          LocalizedHelpIcon(
            title: l10n.helpQiblaTitle,
            description: l10n.helpQiblaDesc,
          ),
          IconButton(
            icon: _isRefreshingLocation
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: deen.accentPrimary,
                    ),
                  )
                : Icon(Icons.my_location_rounded, color: deen.accentPrimary),
            tooltip: l10n.updateGpsLocation,
            onPressed: _isRefreshingLocation
                ? null
                : () => _refreshGpsLocation(context, prayerProv, deen),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppSpacing.screenMargin,
          right: AppSpacing.screenMargin,
          top: 14.0,
          bottom: bottomInset + 32,
        ),
        child: Column(
          children: [
            // 1. Location & Kaaba Distance Banner with Vector Illustration
            DeenCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const ThemedIllustration(
                    illustration: DeenIllustration.kaabaMecca,
                    size: 38,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _localizedLocation(
                            context,
                            prayerProv.city,
                            prayerProv.country,
                          ),
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: deen.textPrimary,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.visible,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${distanceKm.toStringAsFixed(0)} ${l10n.distanceToKaaba}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: deen.accentGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Metrics Capsules (Qibla Bearing & Device Heading)
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: l10n.qiblaBearing,
                    value: '${qiblaBearing.toStringAsFixed(1)}°',
                    subtitle: l10n.trueNorthAngle,
                    accentColor: deen.accentGold,
                    icon: Icons.explore_rounded,
                    deen: deen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: l10n.phoneHeading,
                    value: _hasCompassSensor
                        ? '${_smoothedHeading.toStringAsFixed(0)}°'
                        : 'N/A',
                    subtitle: _hasCompassSensor
                        ? _getCardinalDirection(_smoothedHeading)
                        : 'No Sensor',
                    accentColor: deen.accentPrimary,
                    icon: Icons.navigation_rounded,
                    deen: deen,
                    badgeText: _accuracy != null && _accuracy! > 20
                        ? 'Calibrate'
                        : null,
                    onTap: () => _showCalibrationDialog(context, deen),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // 3. Sensor Missing Warning OR Real Live Compass Dial
            if (!_hasCompassSensor) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: deen.warning.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: deen.warning.withOpacity(0.4)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.sensors_off_rounded,
                      color: deen.warning,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.sensorNotAvailable,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: deen.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.sensorNotAvailableDesc,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        height: 1.4,
                        color: deen.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (_isLoading) ...[
              SizedBox(
                height: 280,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: deen.accentPrimary),
                      const SizedBox(height: 16),
                      Text(
                        'Calibrating sensor compass...',
                        style: GoogleFonts.plusJakartaSans(
                          color: deen.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Real Live Compass Dial
              QiblaCompassDial(
                heading: _smoothedHeading,
                qiblaBearing: qiblaBearing,
                isAligned: isAligned,
                size: 290,
              ),
            ],
            const SizedBox(height: 22),

            // 4. Alignment Status Badge
            if (_hasCompassSensor && !_isLoading) ...[
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isAligned
                      ? deen.success.withOpacity(0.15)
                      : deen.badgeBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isAligned ? deen.success : deen.badgeBorder,
                    width: isAligned ? 2 : 1,
                  ),
                  boxShadow: isAligned
                      ? AppShadows.glow(deen.success, radius: 12)
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isAligned
                          ? Icons.check_circle_rounded
                          : Icons.navigation_rounded,
                      color: isAligned ? deen.success : deen.accentPrimary,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        isAligned
                            ? l10n.alignedWithKaaba
                            : relativeDiff > 0
                                ? UiTranslationService.text(
                                    'turnRight', langCode, params: {
                                    'degrees':
                                        relativeDiff.abs().toStringAsFixed(0)
                                  })
                                : UiTranslationService.text(
                                    'turnLeft', langCode, params: {
                                    'degrees':
                                        relativeDiff.abs().toStringAsFixed(0)
                                  }),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: isAligned ? deen.success : deen.textPrimary,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 18),

            // 5. Calibration Guide
            if (_accuracy != null && _accuracy! > 25.0) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: deen.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: deen.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sync_problem_rounded,
                      color: deen.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.compassAccuracyLow,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          height: 1.3,
                          color: deen.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // 6. Practical Tips Accordion Card
            DeenCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.tips_and_updates_outlined,
                        size: 18,
                        color: deen.accentGold,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        UiTranslationService.text('qiblaTipsTitle', langCode),
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: deen.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildTipRow(
                    UiTranslationService.text('qiblaTip1', langCode),
                    deen,
                  ),
                  _buildTipRow(
                    UiTranslationService.text('qiblaTip2', langCode),
                    deen,
                  ),
                  _buildTipRow(
                    UiTranslationService.text('qiblaTip3', langCode),
                    deen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipRow(String text, DeenThemeTokens deen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12.5,
          color: deen.textSecondary,
          height: 1.35,
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required Color accentColor,
    required IconData icon,
    required DeenThemeTokens deen,
    String? badgeText,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: DeenCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: deen.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (badgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: deen.warning.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: deen.warning.withOpacity(0.4)),
                    ),
                    child: Text(
                      badgeText,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: deen.warning,
                      ),
                    ),
                  ),
                Icon(icon, size: 18, color: accentColor),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: deen.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCalibrationDialog(BuildContext context, DeenThemeTokens deen) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: deen.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.explore_rounded, color: deen.accentPrimary),
            const SizedBox(width: 8),
            Text(
              'Compass Calibration',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: deen.textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'If the compass needle is erratic or points in the wrong direction:',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                color: deen.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            _buildCalibStep('1', 'Hold your phone flat in front of you.', deen),
            _buildCalibStep('2', 'Move your phone in a figure-8 motion (∞) in the air 3 to 4 times.', deen),
            _buildCalibStep('3', 'Ensure your device is away from magnets, laptop speakers, or metal objects.', deen),
            _buildCalibStep('4', 'Ensure GPS Location is active so true Qibla bearing is computed.', deen),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            style: FilledButton.styleFrom(
              backgroundColor: deen.accentPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildCalibStep(String num, String text, DeenThemeTokens deen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: deen.accentPrimary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                num,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: deen.accentPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                color: deen.textSecondary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCardinalDirection(double heading) {
    if (heading >= 337.5 || heading < 22.5) return 'North (N)';
    if (heading >= 22.5 && heading < 67.5) return 'North-East (NE)';
    if (heading >= 67.5 && heading < 112.5) return 'East (E)';
    if (heading >= 112.5 && heading < 157.5) return 'South-East (SE)';
    if (heading >= 157.5 && heading < 202.5) return 'South (S)';
    if (heading >= 202.5 && heading < 247.5) return 'South-West (SW)';
    if (heading >= 247.5 && heading < 292.5) return 'West (W)';
    if (heading >= 292.5 && heading < 337.5) return 'North-West (NW)';
    return '';
  }

  String _localizedLocation(BuildContext context, String city, String country) {
    final languageCode = Localizations.localeOf(context).languageCode;
    const makkahNames = <String, String>{
      'ar': 'مكة',
      'de': 'Mekka',
      'en': 'Makkah',
      'es': 'La Meca',
      'fr': 'La Mecque',
      'id': 'Makkah',
      'ms': 'Makkah',
      'pt': 'Meca',
      'ru': 'Мекка',
      'tr': 'Mekke',
      'ur': 'مکہ',
    };
    const saudiArabiaNames = <String, String>{
      'ar': 'المملكة العربية السعودية',
      'de': 'Saudi-Arabien',
      'en': 'Saudi Arabia',
      'es': 'Arabia Saudita',
      'fr': 'Arabie saoudite',
      'id': 'Arab Saudi',
      'ms': 'Arab Saudi',
      'pt': 'Arábia Saudita',
      'ru': 'Саудовская Аравия',
      'tr': 'Suudi Arabistan',
      'ur': 'سعودی عرب',
    };

    final cityKey = city.trim().toLowerCase();
    final countryKey = country.trim().toLowerCase();
    final isMakkah =
        cityKey == 'makkah' || cityKey == 'mecca' || cityKey == 'meccah';
    final isSaudi =
        countryKey == 'saudi arabia' || countryKey == 'saudia arabia';
    final localizedCity = isMakkah ? (makkahNames[languageCode] ?? city) : city;
    final localizedCountry =
        isSaudi ? (saudiArabiaNames[languageCode] ?? country) : country;
    return '$localizedCity, $localizedCountry';
  }
}
