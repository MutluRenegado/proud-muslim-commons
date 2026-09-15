import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_design_tokens.dart';
import '../../core/constants/deen_theme_tokens.dart';
import '../../core/services/advanced_prayer_times_service.dart';
import '../../core/services/prayer_explanation_service.dart';
import '../../core/services/time_service.dart';
import '../../core/services/timezone_service.dart';
import '../../providers/prayer_provider.dart';
import '../../widgets/deen_card.dart';

class AdvancedPrayerTimesTab extends StatelessWidget {
  const AdvancedPrayerTimesTab({required this.provider, super.key});

  final PrayerProvider provider;

  static const _ui = <String, Map<String, String>>{
    'en': {'warning': 'Kerahat Time', 'more': 'More Information', 'close': 'Close', 'authority': 'Calculation authority', 'school': 'Asr juristic method', 'offline': 'Available offline'},
    'tr': {'warning': 'Kerahat Vakti', 'more': 'Daha Fazla Bilgi', 'close': 'Kapat', 'authority': 'Hesaplama kurumu', 'school': 'İkindi fıkıh yöntemi', 'offline': 'Çevrimdışı kullanılabilir'},
    'ar': {'warning': 'وقت الكراهة', 'more': 'معلومات إضافية', 'close': 'إغلاق', 'authority': 'جهة الحساب', 'school': 'المذهب في وقت العصر', 'offline': 'متاح دون اتصال'},
    'de': {'warning': 'Makruh-Zeit', 'more': 'Weitere Informationen', 'close': 'Schließen', 'authority': 'Berechnungsstelle', 'school': 'Asr-Rechtsmethode', 'offline': 'Offline verfügbar'},
    'fr': {'warning': 'Période déconseillée', 'more': 'Plus d’informations', 'close': 'Fermer', 'authority': 'Autorité de calcul', 'school': 'Méthode juridique de l’Asr', 'offline': 'Disponible hors ligne'},
    'es': {'warning': 'Periodo desaconsejado', 'more': 'Más información', 'close': 'Cerrar', 'authority': 'Autoridad de cálculo', 'school': 'Método jurídico de Asr', 'offline': 'Disponible sin conexión'},
    'pt': {'warning': 'Período desaconselhado', 'more': 'Mais informações', 'close': 'Fechar', 'authority': 'Autoridade de cálculo', 'school': 'Método jurídico de Asr', 'offline': 'Disponível offline'},
    'ru': {'warning': 'Нежелательное время', 'more': 'Подробнее', 'close': 'Закрыть', 'authority': 'Метод расчёта', 'school': 'Правовой метод Асра', 'offline': 'Доступно офлайн'},
    'id': {'warning': 'Waktu Makruh', 'more': 'Informasi Selengkapnya', 'close': 'Tutup', 'authority': 'Otoritas perhitungan', 'school': 'Metode fikih Asar', 'offline': 'Tersedia offline'},
    'ur': {'warning': 'وقتِ کراہت', 'more': 'مزید معلومات', 'close': 'بند کریں', 'authority': 'ادارۂ حساب', 'school': 'عصر کا فقہی طریقہ', 'offline': 'آف لائن دستیاب'},
    'ms': {'warning': 'Waktu Makruh', 'more': 'Maklumat Lanjut', 'close': 'Tutup', 'authority': 'Pihak pengiraan', 'school': 'Kaedah fiqh Asar', 'offline': 'Tersedia di luar talian'},
  };

  @override
  Widget build(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;
    final labels = _ui[language] ?? _ui['en']!;
    final deen = context.deen;
    final today = provider.todayPrayerTimes;
    final tomorrow = provider.tomorrowPrayerTimes;
    if (today == null || tomorrow == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final values = AdvancedPrayerTimesService.calculate(
      today: today,
      nextFajrUtc: tomorrow.fajrUtc,
      latitude: provider.latitude,
      longitude: provider.longitude,
    );
    final kerahat = AdvancedPrayerTimesService.isKerahatActive(
      values,
      TimeService.nowUtc(),
    );

    return FutureBuilder<PrayerExplanationContent>(
      future: PrayerExplanationService.forLanguage(language),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final content = snapshot.data!;
        return ListView(
          padding: EdgeInsets.only(
            left: AppSpacing.screenMargin,
            right: AppSpacing.screenMargin,
            top: 14,
            bottom: MediaQuery.of(context).padding.bottom + 32,
          ),
          children: [
            DeenCard(
              child: Column(
                children: [
                  Text(
                    provider.city,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: deen.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    provider.getFormattedLocalDate(),
                    style: GoogleFonts.plusJakartaSans(color: deen.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    labels['offline']!,
                    style: GoogleFonts.plusJakartaSans(
                      color: deen.accentPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (kerahat) ...[
              const SizedBox(height: 10),
              Semantics(
                liveRegion: true,
                label: labels['warning'],
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(labels['warning']!, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(content.note, style: GoogleFonts.plusJakartaSans(color: deen.textSecondary)),
            const SizedBox(height: 12),
            ...List.generate(18, (index) => _timeCard(
              context,
              deen,
              content,
              labels,
              values,
              index,
            )),
            const SizedBox(height: 12),
            DeenCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${labels['authority']}: ${_methodName(provider.method)}', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: deen.textPrimary)),
                  const SizedBox(height: 6),
                  Text('${labels['school']}: ${_schoolName(provider.juristic)}', style: GoogleFonts.plusJakartaSans(color: deen.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(content.sourcesTitle, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: deen.textPrimary)),
            const SizedBox(height: 8),
            ...content.sources.asMap().entries.map((entry) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Text('${entry.key + 1}.', style: TextStyle(color: deen.accentGold)),
              title: Text(entry.value.label, style: GoogleFonts.plusJakartaSans(color: deen.accentPrimary)),
              trailing: const Icon(Icons.open_in_new_rounded, size: 16),
              onTap: () => launchUrl(Uri.parse(entry.value.url), mode: LaunchMode.externalApplication),
            )),
          ],
        );
      },
    );
  }

  Widget _timeCard(
    BuildContext context,
    DeenThemeTokens deen,
    PrayerExplanationContent content,
    Map<String, String> labels,
    List<DateTime> values,
    int index,
  ) {
    final warningEntry = index == 2 || index == 5 || index == 9;
    final now = TimeService.nowUtc();
    final start = values[index];
    var end = index + 1 < values.length ? values[index + 1] : start.add(const Duration(hours: 1));
    if (!end.isAfter(start)) end = end.add(const Duration(days: 1));
    var adjustedNow = now;
    if (adjustedNow.isBefore(start) && end.day != start.day) adjustedNow = adjustedNow.add(const Duration(days: 1));
    final total = end.difference(start).inSeconds;
    final elapsed = adjustedNow.difference(start).inSeconds;
    final progress = total <= 0
        ? 0.0
        : (elapsed / total).clamp(0.0, 1.0).toDouble();
    final activeWarning = warningEntry && !adjustedNow.isBefore(start) && adjustedNow.isBefore(end);
    final local = TimezoneService.toLocal(values[index], provider.ianaTimeZone);

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: DeenCard(
        padding: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showExplanation(context, deen, content, labels, index),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    if (warningEntry) ...[
                      Icon(Icons.warning_amber_rounded, size: 18, color: activeWarning ? Colors.red : deen.textSecondary),
                      const SizedBox(width: 7),
                    ],
                    Expanded(child: Text(content.names[index], style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: activeWarning ? Colors.red : deen.textPrimary))),
                    Text(DateFormat('HH:mm').format(local), style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: activeWarning ? Colors.red : deen.accentPrimary)),
                  ],
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  borderRadius: BorderRadius.circular(4),
                  color: activeWarning ? Colors.red : deen.accentPrimary,
                  backgroundColor: (activeWarning ? Colors.red : deen.textSecondary).withValues(alpha: 0.16),
                  semanticsLabel: content.names[index],
                  semanticsValue: '${(progress * 100).round()}%',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showExplanation(BuildContext context, DeenThemeTokens deen, PrayerExplanationContent content, Map<String, String> labels, int index) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: deen.surfacePrimary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(content.names[index], style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: deen.textPrimary)),
              const SizedBox(height: 12),
              Text(content.shortTexts[index], style: GoogleFonts.plusJakartaSans(color: deen.textSecondary)),
              const SizedBox(height: 8),
              Text('${content.sourcesTitle}: ${content.references[index]}', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: deen.accentPrimary)),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showMoreInformation(ctx, deen, content, labels, index),
                  child: Text(labels['more']!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoreInformation(BuildContext context, DeenThemeTokens deen, PrayerExplanationContent content, Map<String, String> labels, int index) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: deen.surfacePrimary,
        title: Text(content.names[index]),
        content: SingleChildScrollView(child: Text('${content.longTexts[index]}\n\n${content.sourcesTitle}: ${content.references[index]}')),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(labels['close']!))],
      ),
    );
  }

  String _methodName(dynamic method) => method.toString().split('.').last == 'shiaIthnaAshari'
      ? 'Ja‘fari — Leva Research Institute, Qum'
      : method.toString().split('.').last;

  String _schoolName(dynamic method) {
    final value = method.toString().split('.').last;
    if (value == 'standard' || value == 'shafii') return 'Shafi‘i (1:1)';
    if (value == 'hanafi') return 'Hanafi (2:1)';
    return value[0].toUpperCase() + value.substring(1);
  }
}
