import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deen_path/core/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:deen_path/main.dart';
import 'package:deen_path/views/profile/profile_view.dart';

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

    // Tap Profile avatar in top AppBar
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileView), findsOneWidget);
  });
}


