import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../core/services/audio_service.dart';
import '../../providers/prayer_provider.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/deen_section_header.dart';
import '../../widgets/localized_help_icon.dart';
import '../../l10n/app_localizations.dart';

class PrayerAzanSettingsView extends StatefulWidget {
  const PrayerAzanSettingsView({super.key});

  @override
  State<PrayerAzanSettingsView> createState() => _PrayerAzanSettingsViewState();
}

class _PrayerAzanSettingsViewState extends State<PrayerAzanSettingsView> {
  static const _prayers = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];

  @override
  void dispose() {
    AudioService.stop();
    super.dispose();
  }

  String _titleFor(AppLocalizations l10n, String prayer) {
    switch (prayer) {
      case 'fajr':
        return '${l10n.fajr} Adhan';
      case 'dhuhr':
        return '${l10n.dhuhr} Adhan';
      case 'asr':
        return '${l10n.asr} Adhan';
      case 'maghrib':
        return '${l10n.maghrib} Adhan';
      case 'isha':
        return '${l10n.isha} Adhan';
      default:
        return prayer;
    }
  }

  String _fileName(String path) => path.split('/').last;

  @override
  Widget build(BuildContext context) {
    final prayerProv = context.watch<PrayerProvider>();
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(l10n.prayerAzanSettings,
            style:
                GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          LocalizedHelpIcon(
              title: l10n.helpEzanTitle, description: l10n.helpEzanDesc),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(
            left: AppSpacing.screenMargin,
            right: AppSpacing.screenMargin,
            top: 14,
            bottom: bottomInset + 32),
        children: [
          DeenSectionHeader(
              title: l10n.prayerAzanSettings.toUpperCase(),
              icon: Icons.notifications_active_rounded),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: Column(children: [
              SwitchListTile(
                title: Text(l10n.enableAzanAudio,
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600, color: deen.textPrimary)),
                subtitle: Text(l10n.enableAzanAudioDesc,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 12, color: deen.textSecondary)),
                value: prayerProv.azanEnabled,
                activeColor: deen.accentGold,
                onChanged: prayerProv.setAzanEnabled,
              ),
              Divider(height: 1, color: deen.cardBorder),
              ListTile(
                title: Text(l10n.azanSoundMuezzin,
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600, color: deen.textPrimary)),
                subtitle: Text('Fajr • Dhuhr • Asr • Maghrib • Isha',
                    style: GoogleFonts.plusJakartaSans(
                        color: deen.accentPrimary,
                        fontWeight: FontWeight.bold)),
                trailing: Icon(Icons.chevron_right_rounded,
                    color: deen.textSecondary),
                onTap: () => _showPrayerSounds(context, prayerProv, l10n, deen),
              ),
              Divider(height: 1, color: deen.cardBorder),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.azanVolume,
                                style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w600,
                                    color: deen.textPrimary)),
                            Text('${(prayerProv.azanVolume * 100).round()}%',
                                style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    color: deen.accentPrimary)),
                          ]),
                      Slider(
                          value: prayerProv.azanVolume,
                          min: 0,
                          max: 1,
                          divisions: 10,
                          activeColor: deen.accentPrimary,
                          onChanged: prayerProv.setAzanVolume),
                    ]),
              ),
              Divider(height: 1, color: deen.cardBorder),
              SwitchListTile(
                title: Text(l10n.vibrateOnAzan,
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600, color: deen.textPrimary)),
                subtitle: Text('Vibrate when the scheduled Adhan begins',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 12, color: deen.textSecondary)),
                value: prayerProv.vibrateOnAzan,
                activeColor: deen.accentPrimary,
                onChanged: prayerProv.setVibrateOnAzan,
              ),
              Divider(height: 1, color: deen.cardBorder),
              SwitchListTile(
                title: Text('Silent Mode / DND Override',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600, color: deen.textPrimary)),
                subtitle: Text('Respect system silent mode settings',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 12, color: deen.textSecondary)),
                value: prayerProv.silentModeDnd,
                activeColor: deen.accentPrimary,
                onChanged: prayerProv.setSilentModeDnd,
              ),
            ]),
          ),
          const SizedBox(height: 20),
          DeenSectionHeader(
              title: 'PRE-PRAYER & IQAMAH REMINDERS',
              icon: Icons.timer_rounded),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: Column(children: [
              ListTile(
                title: Text(l10n.reminderBeforeAzan,
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600, color: deen.textPrimary)),
                subtitle: Text(
                    prayerProv.reminderBeforeAzan == 0
                        ? l10n.disabled
                        : '${prayerProv.reminderBeforeAzan} min before',
                    style: GoogleFonts.plusJakartaSans(
                        color: deen.accentGold, fontWeight: FontWeight.w600)),
                trailing: Icon(Icons.chevron_right_rounded,
                    color: deen.textSecondary),
                onTap: () => _showReminderPicker(context,
                    title: l10n.reminderBeforeAzan,
                    current: prayerProv.reminderBeforeAzan,
                    options: const [0, 5, 10, 15, 20, 30],
                    onSelected: prayerProv.setReminderBeforeAzan,
                    deen: deen),
              ),
              Divider(height: 1, color: deen.cardBorder),
              ListTile(
                title: Text(l10n.iqamahReminder,
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600, color: deen.textPrimary)),
                subtitle: Text(
                    prayerProv.iqamahReminder == 0
                        ? l10n.disabled
                        : '${prayerProv.iqamahReminder} min after Azan',
                    style: GoogleFonts.plusJakartaSans(
                        color: deen.accentGold, fontWeight: FontWeight.w600)),
                trailing: Icon(Icons.chevron_right_rounded,
                    color: deen.textSecondary),
                onTap: () => _showReminderPicker(context,
                    title: l10n.iqamahReminder,
                    current: prayerProv.iqamahReminder,
                    options: const [0, 10, 15, 20, 25, 30],
                    onSelected: prayerProv.setIqamahReminder,
                    deen: deen),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          DeenSectionHeader(
              title: 'INDIVIDUAL PRAYER ALERTS', icon: Icons.checklist_rounded),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: Column(children: [
              _buildPrayerRow(context, prayerProv, 'fajr', l10n, deen),
              Divider(height: 1, color: deen.cardBorder),
              _buildSunriseRow(context, prayerProv, l10n, deen),
              Divider(height: 1, color: deen.cardBorder),
              _buildPrayerRow(context, prayerProv, 'dhuhr', l10n, deen),
              Divider(height: 1, color: deen.cardBorder),
              _buildPrayerRow(context, prayerProv, 'asr', l10n, deen),
              Divider(height: 1, color: deen.cardBorder),
              _buildPrayerRow(context, prayerProv, 'maghrib', l10n, deen),
              Divider(height: 1, color: deen.cardBorder),
              _buildPrayerRow(context, prayerProv, 'isha', l10n, deen),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSunriseRow(BuildContext context, PrayerProvider prov,
      AppLocalizations l10n, DeenThemeTokens deen) {
    final enabled = prov.prayerNotificationToggles['sunrise'] ?? false;
    return ListTile(
      title: Text(l10n.sunrise,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            color: enabled ? deen.textPrimary : deen.textSecondary,
          )),
      subtitle: Text(l10n.shuruqReminderDesc,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: deen.textSecondary,
          )),
      trailing: Switch(
        value: enabled,
        activeColor: deen.accentGold,
        onChanged: (v) => prov.togglePrayerNotification('sunrise', v),
      ),
      onTap: () => prov.togglePrayerNotification('sunrise', !enabled),
    );
  }

  Widget _buildPrayerRow(BuildContext context, PrayerProvider prov,
      String prayer, AppLocalizations l10n, DeenThemeTokens deen) {
    final enabled = prov.prayerNotificationToggles[prayer] ?? true;
    final adhanEnabled = prov.isPrayerAdhanEnabled(prayer);
    final asset = prov.prayerAdhanAsset(prayer);
    return ValueListenableBuilder<String?>(
      valueListenable: AudioService.currentPlayingIdNotifier,
      builder: (context, playingId, _) {
        final isPlaying = playingId == 'prayer_adhan_$prayer';
        return ListTile(
          title: Text(_titleFor(l10n, prayer),
              style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: enabled ? deen.textPrimary : deen.textSecondary)),
          subtitle: Text(
              '${adhanEnabled ? 'Adhan ON' : 'Adhan OFF'} • ${_fileName(asset)}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 11, color: deen.textSecondary)),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              tooltip: isPlaying ? l10n.stopAudio : 'Preview Adhan',
              onPressed: isPlaying
                  ? AudioService.stop
                  : () => AudioService.playAdhanAssetPreview(prayer, asset),
              icon: Icon(
                  isPlaying
                      ? Icons.stop_circle_rounded
                      : Icons.play_circle_outline_rounded,
                  color: isPlaying ? Colors.redAccent : deen.accentGold),
            ),
            Switch(
                value: enabled,
                activeColor: deen.accentGold,
                onChanged: (v) => prov.togglePrayerNotification(prayer, v)),
          ]),
          onTap: () =>
              _showPrayerAdhanOptions(context, prov, prayer, l10n, deen),
        );
      },
    );
  }

  void _showPrayerSounds(BuildContext context, PrayerProvider prov,
      AppLocalizations l10n, DeenThemeTokens deen) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: deen.surfacePrimary,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.azanSoundMuezzin,
                    style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: deen.textPrimary)),
                const SizedBox(height: 10),
                ..._prayers
                    .map((prayer) => _soundRow(ctx, prov, prayer, l10n, deen)),
              ]),
        ),
      ),
    ).whenComplete(AudioService.stop);
  }

  Widget _soundRow(BuildContext context, PrayerProvider prov, String prayer,
      AppLocalizations l10n, DeenThemeTokens deen) {
    final asset = prov.prayerAdhanAsset(prayer);
    return ValueListenableBuilder<String?>(
      valueListenable: AudioService.currentPlayingIdNotifier,
      builder: (context, playingId, _) {
        final isPlaying = playingId == 'prayer_adhan_$prayer';
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.mosque_rounded, color: deen.accentGold),
          title: Text(_titleFor(l10n, prayer),
              style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700, color: deen.textPrimary)),
          subtitle: Text(_fileName(asset),
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 11, color: deen.textSecondary)),
          trailing: IconButton(
            tooltip: isPlaying ? l10n.stopAudio : 'Preview Adhan',
            onPressed: isPlaying
                ? AudioService.stop
                : () => AudioService.playAdhanAssetPreview(prayer, asset),
            icon: Icon(
                isPlaying
                    ? Icons.stop_circle_rounded
                    : Icons.play_circle_fill_rounded,
                color: isPlaying ? Colors.redAccent : deen.accentGold),
          ),
        );
      },
    );
  }

  void _showPrayerAdhanOptions(BuildContext context, PrayerProvider prov,
      String prayer, AppLocalizations l10n, DeenThemeTokens deen) {
    showModalBottomSheet(
      context: context,
      backgroundColor: deen.surfacePrimary,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Consumer<PrayerProvider>(builder: (context, p, _) {
        final asset = p.prayerAdhanAsset(prayer);
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_titleFor(l10n, prayer),
                      style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: deen.textPrimary)),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Play Adhan for this prayer',
                        style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            color: deen.textPrimary)),
                    value: p.isPrayerAdhanEnabled(prayer),
                    activeColor: deen.accentGold,
                    onChanged: (v) => p.setPrayerAdhanEnabled(prayer, v),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.azanSoundMuezzin,
                        style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            color: deen.textPrimary)),
                    subtitle: Text(_fileName(asset),
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 12, color: deen.textSecondary)),
                    trailing: IconButton(
                        icon: Icon(Icons.play_circle_fill_rounded,
                            color: deen.accentGold),
                        onPressed: () =>
                            AudioService.playAdhanAssetPreview(prayer, asset)),
                  ),
                ]),
          ),
        );
      }),
    ).whenComplete(AudioService.stop);
  }

  void _showReminderPicker(
    BuildContext context, {
    required String title,
    required int current,
    required List<int> options,
    required void Function(int) onSelected,
    required DeenThemeTokens deen,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: deen.surfacePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: deen.textPrimary,
                  )),
              const SizedBox(height: 14),
              ...options.map((opt) => RadioListTile<int>(
                    title: Text(opt == 0 ? 'Disabled' : '$opt minutes',
                        style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            color: deen.textPrimary)),
                    value: opt,
                    groupValue: current,
                    activeColor: deen.accentGold,
                    onChanged: (val) {
                      if (val != null) {
                        onSelected(val);
                        Navigator.pop(ctx);
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
