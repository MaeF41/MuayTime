import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muay_time/app.dart';

import 'harness.dart';

void main() {
Size iphone16ProLogicalSize=Size(393, 852);

  testWidgets('Complete flow test', (WidgetTester tester) async {
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
    await tester.pumpAndSettle();

    expect(find.text('4'), findsOneWidget);

    final startButton = find.text('Start Timer');
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/timer_ticking_screen.png'),
    );


    // Verify navigation to TimerRunningScreen
    expect(find.text('Timer Running'), findsOneWidget);
    expect(find.text('Round 1'), findsOneWidget);


  });
}
