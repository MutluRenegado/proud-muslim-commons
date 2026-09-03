import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../providers/prayer_provider.dart';
import '../../core/services/location_service.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/deen_section_header.dart';
import '../../widgets/localized_help_icon.dart';
import '../../l10n/app_localizations.dart';

class LocationSettingsView extends StatefulWidget {
  const LocationSettingsView({super.key});

  @override
  State<LocationSettingsView> createState() => _LocationSettingsViewState();
}

class _LocationSettingsViewState extends State<LocationSettingsView> {
  bool _isLocating = false;

  @override
  Widget build(BuildContext context) {
    final prayerProv = Provider.of<PrayerProvider>(context);
    final isAuto = prayerProv.locationMode == 'auto';
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          l10n.locationAndPrivacy,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          LocalizedHelpIcon(
            title: l10n.locationAndPrivacy,
            description: l10n.locationPrivacyNotice,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: AppSpacing.screenMargin,
          right: AppSpacing.screenMargin,
          top: 14,
          bottom: bottomInset + 32,
        ),
        children: [
          // Prominent Privacy Notice Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: deen.badgeBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: deen.badgeBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: deen.accentPrimary.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shield_outlined,
                        color: deen.accentPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'WE ONLY ACCESS YOUR DEVICE LOCATION',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: deen.accentPrimary,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'We only access your device location to provide accurate prayer times and location-based features. Your personal data remains private. You can safely enable location services.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 1.45,
                    color: deen.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Current Location Card
          const DeenSectionHeader(
            title: 'CURRENT LOCATION STATUS',
            icon: Icons.location_on_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: deen.accentGold,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${prayerProv.city}, ${prayerProv.country}',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: deen.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isAuto ? deen.badgeBackground : deen.cardBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isAuto ? deen.badgeBorder : deen.cardBorder,
                        ),
                      ),
                      child: Text(
                        isAuto ? 'GPS (AUTO)' : 'MANUAL',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color:
                              isAuto ? deen.accentPrimary : deen.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Time Zone: ${prayerProv.ianaTimeZone} (${prayerProv.getUtcOffsetDisplay()})',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: deen.accentPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lat: ${prayerProv.latitude.toStringAsFixed(4)}°, Long: ${prayerProv.longitude.toStringAsFixed(4)}°',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: deen.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLocating
                        ? null
                        : () => _fetchGpsLocation(context, prayerProv, deen),
                    icon: _isLocating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.my_location_rounded, size: 18),
                    label: Text(
                      _isLocating
                          ? 'Detecting Precise Location...'
                          : 'Update via Precise GPS',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: deen.accentPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Manual City Selection
          const DeenSectionHeader(
            title: 'MANUAL GLOBAL CITY SELECTION',
            icon: Icons.public_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: deen.badgeBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.travel_explore_rounded,
                  color: deen.accentPrimary,
                  size: 20,
                ),
              ),
              title: Text(
                'Choose City from Database',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: deen.textPrimary,
                ),
              ),
              subtitle: Text(
                'Select from 100+ major global Islamic cities',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: deen.textSecondary,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: deen.textSecondary,
              ),
              onTap: () => _showCityPicker(context, prayerProv, deen),
            ),
          ),
          const SizedBox(height: 22),
          DeenCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.language_rounded, color: deen.accentGold),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Prayer times wherever you are',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          color: deen.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 128,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _WorldMapPainter(
                      landColor: deen.accentPrimary.withOpacity(0.34),
                      lineColor: deen.accentGold.withOpacity(0.48),
                      locationColor: deen.accentGold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Location is processed on your device to calculate local prayer times and Qibla direction.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    height: 1.4,
                    color: deen.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchGpsLocation(
    BuildContext context,
    PrayerProvider prayerProv,
    DeenThemeTokens deen,
  ) async {
    setState(() => _isLocating = true);
    final pos = await LocationService.requestDeviceLocation(context);
    if (!mounted) return;
    if (pos != null) {
      final cityPreset = LocationService.findNearestCity(
        pos.latitude,
        pos.longitude,
      );
      final meta = LocationService.resolveLocationMetadata(
        pos.latitude,
        pos.longitude,
        city: cityPreset.city,
        country: cityPreset.country,
      );

      prayerProv.updateLocation(
        pos.latitude,
        pos.longitude,
        cityPreset.city,
        cityPreset.country,
        mode: 'auto',
        ianaTimeZone: meta.ianaTimeZone,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Updated to ${cityPreset.city}, ${cityPreset.country} (${meta.ianaTimeZone})',
            ),
            backgroundColor: deen.accentPrimary,
          ),
        );
      }
    }
    setState(() => _isLocating = false);
  }

  void _showCityPicker(
    BuildContext context,
    PrayerProvider prayerProv,
    DeenThemeTokens deen,
  ) {
    final cities = LocationService.popularIslamicCities;
    String search = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: deen.surfacePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = cities.where((c) {
              final q = search.toLowerCase();
              return c.city.toLowerCase().contains(q) ||
                  c.country.toLowerCase().contains(q);
            }).toList();

            return SafeArea(
              top: false,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select City',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: deen.textPrimary,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(ctx),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: TextField(
                          onChanged: (val) => setModalState(() => search = val),
                          style: GoogleFonts.plusJakartaSans(
                            color: deen.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search city or country...',
                            prefixIcon: Icon(
                              Icons.search,
                              color: deen.accentPrimary,
                            ),
                            filled: true,
                            fillColor: deen.cardBackground,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: deen.cardBorder),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: deen.cardBorder),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, idx) {
                            final c = filtered[idx];
                            final isSelected = prayerProv.city == c.city;
                            return ListTile(
                              title: Text(
                                c.city,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? deen.accentPrimary
                                      : deen.textPrimary,
                                ),
                              ),
                              subtitle: Text(
                                '${c.country} • ${c.ianaTimeZone}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: deen.textSecondary,
                                ),
                              ),
                              trailing: isSelected
                                  ? Icon(
                                      Icons.check_circle,
                                      color: deen.accentPrimary,
                                    )
                                  : null,
                              onTap: () {
                                prayerProv.updateLocation(
                                  c.lat,
                                  c.lng,
                                  c.city,
                                  c.country,
                                  mode: 'manual',
                                  ianaTimeZone: c.ianaTimeZone,
                                );
                                Navigator.pop(ctx);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _WorldMapPainter extends CustomPainter {
  final Color landColor;
  final Color lineColor;
  final Color locationColor;

  const _WorldMapPainter({
    required this.landColor,
    required this.lineColor,
    required this.locationColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = lineColor.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final land = Paint()
      ..color = landColor
      ..style = PaintingStyle.fill;
    final border = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final globe = Rect.fromLTWH(4, 4, size.width - 8, size.height - 8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(globe, const Radius.circular(18)),
      grid,
    );
    for (final fraction in [0.25, 0.5, 0.75]) {
      canvas.drawLine(
        Offset(size.width * fraction, 7),
        Offset(size.width * fraction, size.height - 7),
        grid,
      );
    }
    for (final fraction in [0.33, 0.66]) {
      canvas.drawLine(
        Offset(7, size.height * fraction),
        Offset(size.width - 7, size.height * fraction),
        grid,
      );
    }

    Path continent(List<Offset> points) {
      final path = Path()
        ..moveTo(points.first.dx * size.width, points.first.dy * size.height);
      for (final point in points.skip(1)) {
        path.lineTo(point.dx * size.width, point.dy * size.height);
      }
      return path..close();
    }

    final continents = [
      continent(const [
        Offset(.08, .28),
        Offset(.19, .17),
        Offset(.31, .23),
        Offset(.27, .42),
        Offset(.18, .49),
        Offset(.12, .40),
      ]),
      continent(const [
        Offset(.26, .48),
        Offset(.34, .52),
        Offset(.31, .76),
        Offset(.26, .91),
        Offset(.22, .67),
      ]),
      continent(const [
        Offset(.43, .28),
        Offset(.54, .20),
        Offset(.65, .29),
        Offset(.58, .40),
        Offset(.48, .39),
      ]),
      continent(const [
        Offset(.47, .43),
        Offset(.59, .41),
        Offset(.64, .61),
        Offset(.55, .84),
        Offset(.47, .64),
      ]),
      continent(const [
        Offset(.62, .27),
        Offset(.78, .19),
        Offset(.92, .33),
        Offset(.84, .52),
        Offset(.69, .46),
      ]),
      continent(const [
        Offset(.80, .68),
        Offset(.92, .70),
        Offset(.89, .84),
        Offset(.79, .81),
      ]),
    ];
    for (final path in continents) {
      canvas.drawPath(path, land);
      canvas.drawPath(path, border);
    }
    final marker = Offset(size.width * .59, size.height * .43);
    canvas.drawCircle(marker, 5, Paint()..color = locationColor);
    canvas.drawCircle(
      marker,
      10,
      Paint()
        ..color = locationColor.withOpacity(0.28)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _WorldMapPainter oldDelegate) =>
      oldDelegate.landColor != landColor ||
      oldDelegate.lineColor != lineColor ||
      oldDelegate.locationColor != locationColor;
}
