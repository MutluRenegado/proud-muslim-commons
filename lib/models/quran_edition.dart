// quran_edition.dart

class QuranEdition {
  final String id; // e.g. 'tur-diyanetisleri'
  final String languageCode; // e.g. 'tr'
  final String languageName; // e.g. 'Turkish'
  final String nativeLanguageName; // e.g. 'Türkçe'
  final String translatorName; // e.g. 'Diyanet İşleri'
  final String source; // e.g. 'Diyanet İşleri Başkanlığı'
  final String apiEditionId; // e.g. 'tur-diyanetisleri'
  final bool approved; // whether translation is approved for app use
  final bool enabled; // whether translation is actively enabled in UI selector
  final String attribution; // full source & publisher note
  final String
      licenseStatus; // e.g. 'Public Domain', 'Permission Granted', 'Pending Review'
  final bool isRtl; // text direction

  const QuranEdition({
    required this.id,
    required this.languageCode,
    required this.languageName,
    required this.nativeLanguageName,
    required this.translatorName,
    required this.source,
    required this.apiEditionId,
    required this.approved,
    required this.enabled,
    required this.attribution,
    required this.licenseStatus,
    this.isRtl = false,
  });

  factory QuranEdition.fromJson(Map<String, dynamic> json) {
    return QuranEdition(
      id: json['id'] as String,
      languageCode: json['languageCode'] as String,
      languageName: json['languageName'] as String,
      nativeLanguageName: json['nativeLanguageName'] as String,
      translatorName: json['translatorName'] as String,
      source: json['source'] as String,
      apiEditionId: json['apiEditionId'] as String,
      approved: json['approved'] as bool? ?? true,
      enabled: json['enabled'] as bool? ?? true,
      attribution: json['attribution'] as String? ?? '',
      licenseStatus: json['licenseStatus'] as String? ?? 'Verified',
      isRtl: json['isRtl'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'languageCode': languageCode,
        'languageName': languageName,
        'nativeLanguageName': nativeLanguageName,
        'translatorName': translatorName,
        'source': source,
        'apiEditionId': apiEditionId,
        'approved': approved,
        'enabled': enabled,
        'attribution': attribution,
        'licenseStatus': licenseStatus,
        'isRtl': isRtl,
      };
}
