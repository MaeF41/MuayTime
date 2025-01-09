import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muay_time/view/timer_settings_screen.dart';

void main() {
  testWidgets('TimerScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: TimerSettings()),
      ),
    );

    expect(find.text('Number of Rounds'), findsOneWidget);
    expect(find.text('Round Duration (seconds)'), findsOneWidget);
    expect(find.text('Break Duration (seconds)'), findsOneWidget);
    expect(find.text('3'), findsOneWidget); // Default round count
  });

  testWidgets('Updates round count when + button is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: TimerSettings()),
      ),
    );

    final incrementButton = find.widgetWithIcon(IconButton, Icons.add).first;

    await tester.tap(incrementButton);
    await tester.pump();

    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('Starts timer when Start Timer button is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: TimerSettings()),
      ),
    );

    final startButton = find.text('Start Timer');
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    expect(find.text('Timer Running'), findsOneWidget);
  });
}
