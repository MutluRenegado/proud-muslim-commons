import 'package:flutter_test/flutter_test.dart';
import 'package:deen_path/core/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deen_path/main.dart';

void main() {
  testWidgets('Deen Path app launches and renders root screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();

    await tester.pumpWidget(const DeenPathApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Prayer'), findsWidgets);
    expect(find.text('Quran'), findsWidgets);
    expect(find.text('Qibla'), findsWidgets);
    expect(find.text('Azkar'), findsWidgets);

    // Tap Profile & Settings button in top AppBar
    await tester.tap(find.byTooltip('Profile & Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Profile & Settings'), findsOneWidget);
    expect(find.text('Prayer & Azan Settings'), findsOneWidget);
    expect(find.text('Calculation & Juristic Method'), findsOneWidget);
    expect(find.text('Location & Privacy'), findsOneWidget);
  });
}

