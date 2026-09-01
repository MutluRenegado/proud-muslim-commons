import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../models/tasbih_model.dart';
import '../../widgets/deen_card.dart';

class PlacesView extends StatelessWidget {
  const PlacesView({super.key});

  @override
  Widget build(BuildContext context) {
    final deen = context.deen;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final masjids = [
      MasjidModel(
        name: 'Grand Central Mosque',
        address: '142 Islamic Center Way, Central City',
        distanceKm: 1.2,
        prayerTimesInfo: 'Jummah: 1:15 PM & 2:00 PM',
        hasWuduArea: true,
        hasWomenSection: true,
        hasParking: true,
        rating: 4.9,
      ),
      MasjidModel(
        name: 'Al-Noor Community Center & Masjid',
        address: '88 Peace Blvd, West District',
        distanceKm: 2.8,
        prayerTimesInfo: 'Jummah: 1:30 PM',
        hasWuduArea: true,
        hasWomenSection: true,
        hasParking: false,
        rating: 4.8,
      ),
      MasjidModel(
        name: 'Masjid Al-Taqwa',
        address: '204 Heritage Road, East Valley',
        distanceKm: 4.5,
        prayerTimesInfo: 'Jummah: 1:00 PM',
        hasWuduArea: true,
        hasWomenSection: true,
        hasParking: true,
        rating: 4.7,
      ),
    ];

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          'Nearby Mosques & Halal Places',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(
          left: AppSpacing.screenMargin,
          right: AppSpacing.screenMargin,
          top: 14,
          bottom: bottomInset + 32,
        ),
        itemCount: masjids.length,
        itemBuilder: (context, index) {
          final m = masjids[index];
          return DeenCard(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        m.name,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: deen.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: deen.accentGold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: deen.accentGold,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${m.rating}',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: deen.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: deen.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        m.address,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: deen.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  children: [
                    if (m.hasWuduArea)
                      _buildAmenityChip(
                        'Wudu Area',
                        Icons.water_drop_outlined,
                        deen,
                      ),
                    if (m.hasWomenSection)
                      _buildAmenityChip('Women Section', Icons.female, deen),
                    if (m.hasParking)
                      _buildAmenityChip('Parking', Icons.local_parking, deen),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAmenityChip(String label, IconData icon, DeenThemeTokens deen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: deen.badgeBackground,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: deen.badgeBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: deen.accentPrimary),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: deen.accentPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
