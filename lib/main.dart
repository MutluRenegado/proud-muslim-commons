import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/services/storage_service.dart';
import 'core/services/quran_cache_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/analytics_service.dart';
import 'providers/theme_provider.dart';
import 'providers/prayer_provider.dart';
import 'providers/quran_provider.dart';
import 'providers/tasbih_provider.dart';
import 'providers/zakat_provider.dart';
import 'providers/subscription_provider.dart';
import 'views/home/home_view.dart';
import 'views/prayer/prayer_times_view.dart';
import 'core/constants/app_constants.dart';
import 'views/quran/quran_view.dart';
import 'views/qibla/qibla_view.dart';
import 'views/azkar/azkar_view.dart';
import 'widgets/modern_bottom_nav.dart';

import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AnalyticsService.init();
  } catch (e) {
    debugPrint('Firebase initialization note: $e');
  }

  await StorageService.init();
  await QuranCacheService.init();
  await NotificationService.init();

  runApp(const DeenPathApp());
}

class DeenPathApp extends StatelessWidget {
  const DeenPathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PrayerProvider()),
        ChangeNotifierProvider(create: (_) => QuranProvider()),
        ChangeNotifierProvider(create: (_) => TasbihProvider()),
        ChangeNotifierProvider(create: (_) => ZakatProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProv, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: themeProv.activeTheme,
            darkTheme: themeProv.activeTheme,
            themeMode: themeProv.themeMode,
            locale: themeProv.activeLocale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            navigatorObservers: [
              if (AnalyticsService.observer != null) AnalyticsService.observer!,
            ],
            home: const MainNavigationScreen(),
          );
        },
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeView(),
    PrayerTimesView(),
    QuranView(),
    QiblaView(),
    AzkarView(),
  ];

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final navItems = [
      ModernNavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: l10n?.navHome ?? 'Home',
      ),
      ModernNavItem(
        icon: Icons.access_time_outlined,
        activeIcon: Icons.access_time_filled_rounded,
        label: l10n?.navPrayer ?? 'Prayer',
      ),
      ModernNavItem(
        icon: Icons.menu_book_outlined,
        activeIcon: Icons.menu_book_rounded,
        label: l10n?.navQuran ?? 'Quran',
      ),
      ModernNavItem(
        icon: Icons.explore_outlined,
        activeIcon: Icons.explore_rounded,
        label: l10n?.navQibla ?? 'Qibla',
      ),
      ModernNavItem(
        icon: Icons.favorite_outline_rounded,
        activeIcon: Icons.favorite_rounded,
        label: l10n?.navAzkar ?? 'Azkar',
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: ModernBottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        items: navItems,
      ),
    );
  }
}
