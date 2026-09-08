import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/deen_theme_tokens.dart';
import '../../core/constants/app_design_tokens.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/storage_service.dart';
import '../../providers/prayer_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/deen_card.dart';
import '../../widgets/deen_section_header.dart';
import '../../widgets/localized_help_icon.dart';
import 'prayer_azan_settings_view.dart';
import 'calculation_settings_view.dart';
import 'location_settings_view.dart';
import 'appearance_language_settings_view.dart';
import 'app_features_settings_view.dart';
import 'subscription_view.dart';
import 'support_view.dart';
import 'legal_about_view.dart';
import '../debug/prayer_diagnostic_view.dart';

import '../../l10n/app_localizations.dart';
import '../../core/services/ui_translation_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String _userName = StorageService.userName;
  String _userEmail = StorageService.userEmail;
  String? _profilePhotoPath = StorageService.userProfilePhotoPath;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfilePhoto(AppLocalizations l10n) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        await StorageService.setUserProfilePhotoPath(image.path);
        setState(() {
          _profilePhotoPath = image.path;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.profilePhotoUpdated),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (_) {}
  }

  Future<void> _removeProfilePhoto(AppLocalizations l10n) async {
    await StorageService.setUserProfilePhotoPath(null);
    setState(() {
      _profilePhotoPath = null;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profilePhotoRemoved),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showPhotoOptions(
    BuildContext context,
    AppLocalizations l10n,
    DeenThemeTokens deen,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: deen.surfacePrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.profilePhoto,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: deen.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: deen.badgeBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.photo_library_rounded,
                      color: deen.accentPrimary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    l10n.chooseFromGallery,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: deen.textPrimary,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickProfilePhoto(l10n);
                  },
                ),
                if (_profilePhotoPath != null) ...[
                  Divider(height: 1, color: deen.cardBorder),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      l10n.removePhoto,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _removeProfilePhoto(l10n);
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final subProv = Provider.of<SubscriptionProvider>(context);
    final prayerProv = Provider.of<PrayerProvider>(context);
    final deen = context.deen;
    final l10n = AppLocalizations.of(context)!;
    final langCode = Localizations.localeOf(context).languageCode;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final isSubscribed = subProv.isSubscribed;

    return Scaffold(
      backgroundColor: deen.bgPrimary,
      appBar: AppBar(
        title: Text(
          l10n.profileAndSettings,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          LocalizedHelpIcon(
            title: l10n.profileAndSettings,
            description: l10n.helpSubscriptionDesc,
          ),
          IconButton(
            icon: Icon(Icons.edit_outlined, color: deen.accentPrimary),
            tooltip: l10n.editProfile,
            onPressed: () => _showEditProfileDialog(context, l10n, deen),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: AppSpacing.screenMargin,
          right: AppSpacing.screenMargin,
          top: 12,
          bottom: bottomInset + 32,
        ),
        children: [
          // 1. Profile Identity Card
          _buildProfileIdentityCard(isSubscribed, l10n, deen),
          const SizedBox(height: 14),

          // 2. Subscription / Ad-Free Banner Card
          _buildSubscriptionCard(
            context,
            subProv,
            isSubscribed,
            deen,
          ),
          const SizedBox(height: 18),

          // 3. Settings Categories
          DeenSectionHeader(
            title: l10n.prayerAndTimetable,
            icon: Icons.access_time_filled_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildSettingsRow(
                  icon: Icons.notifications_active_outlined,
                  color: deen.accentPrimary,
                  title: l10n.prayerAzanSettings,
                  subtitle:
                      '${prayerProv.azanEnabled ? l10n.azanAudioActive : l10n.silent} • ${prayerProv.azanSound}',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrayerAzanSettingsView(),
                    ),
                  ),
                  deen: deen,
                ),
                Divider(height: 1, color: deen.cardBorder),
                _buildSettingsRow(
                  icon: Icons.calculate_outlined,
                  color: deen.accentPrimary,
                  title: l10n.calculationJuristicMethod,
                  subtitle:
                      '${prayerProv.method.name} • ${prayerProv.juristic.name == 'hanafi' ? l10n.hanafiJuristic : l10n.standardJuristic}',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CalculationSettingsView(),
                    ),
                  ),
                  deen: deen,
                ),
                Divider(height: 1, color: deen.cardBorder),
                _buildSettingsRow(
                  icon: Icons.location_on_outlined,
                  color: deen.accentPrimary,
                  title: l10n.locationAndPrivacy,
                  subtitle:
                      '${prayerProv.city}, ${prayerProv.country} (${UiTranslationService.text(prayerProv.locationMode == "auto" ? "gps" : "manual", langCode)})',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LocationSettingsView(),
                    ),
                  ),
                  deen: deen,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          DeenSectionHeader(
            title: l10n.customizationFeatures,
            icon: Icons.tune_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildSettingsRow(
                  icon: Icons.palette_outlined,
                  color: deen.accentGold,
                  title: l10n.appearanceAndLanguage,
                  subtitle: UiTranslationService.text(
                      'profileAppearanceSubtitle', langCode),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppearanceLanguageSettingsView(),
                    ),
                  ),
                  deen: deen,
                ),
                Divider(height: 1, color: deen.cardBorder),
                _buildSettingsRow(
                  icon: Icons.star_outline_rounded,
                  color: deen.accentGold,
                  title: l10n.appFeaturesReminders,
                  subtitle: UiTranslationService.text(
                      'profileFeaturesSubtitle', langCode),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AppFeaturesSettingsView(),
                    ),
                  ),
                  deen: deen,
                ),
                Divider(height: 1, color: deen.cardBorder),
                _buildSettingsRow(
                  icon: Icons.workspace_premium_outlined,
                  color: deen.accentGold,
                  title: l10n.subscriptionAndBilling,
                  subtitle: isSubscribed
                      ? 'Ad-Free Active'
                      : 'Free (Ad-Supported)',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SubscriptionView()),
                  ),
                  deen: deen,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Community Section - Presented as "Proud Muslims"
          DeenSectionHeader(
            title: AppConstants.communityName,
            icon: Icons.people_outline_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: deen.badgeBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.people_alt_outlined,
                  color: deen.accentPrimary,
                  size: 20,
                ),
              ),
              title: Text(
                UiTranslationService.text('community', langCode),
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: deen.textPrimary,
                ),
              ),
              subtitle: Text(
                UiTranslationService.text('communityComing', langCode),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: deen.textSecondary,
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: deen.accentGold.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  UiTranslationService.text('comingSoon', langCode),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: deen.accentGold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          DeenSectionHeader(
            title: l10n.supportAndLegal,
            icon: Icons.help_outline_rounded,
          ),
          const SizedBox(height: 8),
          DeenCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildSettingsRow(
                  icon: Icons.help_outline_rounded,
                  color: deen.info,
                  title: l10n.helpFaqSupport,
                  subtitle:
                      UiTranslationService.text('supportSubtitle', langCode),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SupportView()),
                  ),
                  deen: deen,
                ),
                Divider(height: 1, color: deen.cardBorder),
                _buildSettingsRow(
                  icon: Icons.info_outline_rounded,
                  color: deen.textSecondary,
                  title: l10n.legalAndAbout,
                  subtitle: UiTranslationService.text('legalSubtitle', langCode,
                      params: {'version': AppConstants.appVersion}),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LegalAboutView()),
                  ),
                  deen: deen,
                ),
                if (kDebugMode) ...[
                  Divider(height: 1, color: deen.cardBorder),
                  _buildSettingsRow(
                    icon: Icons.bug_report_rounded,
                    color: Colors.amber,
                    title: 'Prayer & Time Diagnostics',
                    subtitle: 'Inspect UTC, IANA timezone & solar timestamps',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PrayerDiagnosticView(),
                      ),
                    ),
                    deen: deen,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileIdentityCard(
    bool isSubscribed,
    AppLocalizations l10n,
    DeenThemeTokens deen,
  ) {
    final hasCustomPhoto =
        _profilePhotoPath != null && File(_profilePhotoPath!).existsSync();

    return DeenCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showPhotoOptions(context, l10n, deen),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          isSubscribed ? deen.accentGold : deen.accentPrimary,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: deen.badgeBackground,
                    backgroundImage: hasCustomPhoto
                        ? FileImage(File(_profilePhotoPath!))
                        : null,
                    child: !hasCustomPhoto
                        ? Icon(
                            Icons.person_rounded,
                            color: deen.accentPrimary,
                            size: 32,
                          )
                        : null,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: deen.accentGold,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: deen.surfacePrimary,
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _userName,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.5,
                          color: deen.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isSubscribed
                            ? deen.accentGold.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isSubscribed ? 'AD-FREE' : 'FREE',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isSubscribed
                              ? deen.accentGold
                              : Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  _userEmail,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: deen.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit_note_rounded, color: deen.accentPrimary),
            tooltip: l10n.editProfile,
            onPressed: () => _showEditProfileDialog(context, l10n, deen),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(
    BuildContext context,
    SubscriptionProvider subProv,
    bool isSubscribed,
    DeenThemeTokens deen,
  ) {
    if (isSubscribed) {
      return DeenCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: deen.accentGold.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.verified_rounded,
                color: deen.accentGold,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Proud Muslim Ad-Free Active',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: deen.textPrimary,
                    ),
                  ),
                  Text(
                    StorageService.isPermanentAdFreeAccount
                        ? 'Permanent Ad-Free account active. Enjoy an ad-free spiritual journey.'
                        : 'All advertisements are removed across the application.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            deen.accentPrimary.withOpacity(0.85),
            deen.accentGold.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: deen.accentPrimary.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SubscriptionView()),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.block_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Go Ad-Free',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Proud Muslim is free. Subscribe to remove ads across all features.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required DeenThemeTokens deen,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: deen.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          color: deen.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 18,
        color: deen.textSecondary,
      ),
      onTap: onTap,
    );
  }

  void _showEditProfileDialog(
    BuildContext context,
    AppLocalizations l10n,
    DeenThemeTokens deen,
  ) {
    final nameCtrl = TextEditingController(text: _userName);
    final emailCtrl = TextEditingController(text: _userEmail);

    final subProv = Provider.of<SubscriptionProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: deen.surfacePrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.editProfile,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: deen.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: l10n.displayName,
                labelStyle: GoogleFonts.plusJakartaSans(
                  color: deen.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                labelText: l10n.emailAddress,
                labelStyle: GoogleFonts.plusJakartaSans(
                  color: deen.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await StorageService.logout();
              if (mounted) {
                setState(() {
                  _userName = StorageService.userName;
                  _userEmail = StorageService.userEmail;
                });
                subProv.refreshStatus();
              }
            },
            child: Text(
              'Reset / Sign Out',
              style: GoogleFonts.plusJakartaSans(color: Colors.redAccent),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.cancel,
              style: GoogleFonts.plusJakartaSans(color: deen.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameCtrl.text.trim();
              final newEmail = emailCtrl.text.trim();
              Navigator.pop(ctx);
              if (newName.isNotEmpty) {
                await StorageService.setUserName(newName);
                if (mounted) setState(() => _userName = newName);
              }
              if (newEmail.isNotEmpty) {
                await StorageService.setUserEmail(newEmail);
                if (mounted) {
                  setState(() => _userEmail = newEmail);
                  subProv.refreshStatus();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: deen.accentPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              l10n.save,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
