import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muay_time/app.dart';
import 'package:muay_time/view/timer_settings_screen.dart';

import 'harness.dart';

void main() {
  Size iphone16ProLogicalSize = Size(393, 852);

  testWidgets('Complete flow test with goldens', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(iphone16ProLogicalSize);
    loadFonts();

    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/main_screen.png'),
    );

    final incrementButton = find.widgetWithIcon(IconButton, Icons.add).first;
    await tester.tap(incrementButton);
    await tester.pump();

    expect(find.text('4'), findsOneWidget);

    final startButton = find.text('Start Timer');
    await tester.tap(startButton);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Round 1'), findsOneWidget);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/timer_ticking_screen.png'),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 179));
    await tester.pump(const Duration(milliseconds: 690));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/timer_ticking_passed_time_screen.png'),
    );
  });

  testWidgets('button stops the timer and nav to the settings screen', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(iphone16ProLogicalSize);
    loadFonts();

    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    await tester.pumpAndSettle();

    final incrementButton = find.widgetWithIcon(IconButton, Icons.add).first;
    await tester.tap(incrementButton);
    await tester.pump();

    expect(find.text('4'), findsOneWidget);

    final startButton = find.text('Start Timer');
    await tester.tap(startButton);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(SettingsScreen), findsNothing);
    expect(find.text('Round 1'), findsOneWidget);

    await tester.tap(find.text('Stop'));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.text('Round 1'), findsNothing);
  });
}
