import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muay_time/view/timer_settings_screen.dart';
import 'package:muay_time/widgets/inputs.dart';

void main() {
  testWidgets('TimerScreenSettings renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: SettingsScreen()),
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
        child: MaterialApp(home: SettingsScreen()),
      ),
    );
    expect(find.text('3'), findsOneWidget);
    expect(find.text('4'), findsNothing);

    final incrementButton = find.widgetWithIcon(IconButton, Icons.add).first;

    await tester.tap(incrementButton);
    await tester.pump();

    expect(find.text('4'), findsOneWidget);
    expect(find.text('3'), findsNothing);
  });

  testWidgets('Updates round duration when + tapped', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: SettingsScreen()),
      ),
    );

    final incrementButton = find.widgetWithIcon(IconButton, Icons.add).at(1);

    expect(find.text('180 s'), findsOneWidget);
    expect(find.text('190 s'), findsNothing);

    await tester.tap(incrementButton);
    await tester.pump();

    expect(find.text('190 s'), findsOneWidget);
    expect(find.text('180 s'), findsNothing);
  });

  testWidgets('Updates break duration when + tapped', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: SettingsScreen()),
      ),
    );

    final incrementButton = find.widgetWithIcon(IconButton, Icons.add).last;

    expect(find.text('30 s'), findsOneWidget);
    expect(find.text('40 s'), findsNothing);

    await tester.tap(incrementButton);
    await tester.pump();

    expect(find.text('40 s'), findsOneWidget);
    expect(find.text('30 s'), findsNothing);
  });

  testWidgets('Starts timer when Start Timer button is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: SettingsScreen()),
      ),
    );

    final startButton = find.text('Start Timer');
    await tester.tap(startButton);
    await tester.pump();
    await tester.pump(Duration(milliseconds: 300));

    expect(find.text('Round 1'), findsOneWidget);
  });

  group('NumberInput Widget Tests', () {
    testWidgets('Displays label and value correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: NumberInput(
            label: 'Quantity',
            value: 5,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Quantity'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('Increment button increases the value', (WidgetTester tester) async {
      int currentValue = 5;

      await tester.pumpWidget(
        MaterialApp(
          home: NumberInput(
            label: 'Quantity',
            value: currentValue,
            onChanged: (newValue) {
              currentValue = newValue;
            },
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(currentValue, 6);
    });

    testWidgets('Decrement button decreases the value', (WidgetTester tester) async {
      int currentValue = 5;

      await tester.pumpWidget(
        MaterialApp(
          home: NumberInput(
            label: 'Quantity',
            value: currentValue,
            onChanged: (newValue) {
              currentValue = newValue;
            },
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(currentValue, 4);
    });

    testWidgets('Decrement button does not decrease below 1', (WidgetTester tester) async {
      int currentValue = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: NumberInput(
            label: 'Quantity',
            value: currentValue,
            onChanged: (newValue) {
              currentValue = newValue;
            },
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(currentValue, 1);
    });
  });

  group('DurationInput Widget Tests', () {
    testWidgets('Displays label and value correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DurationInput(
            label: 'Timer',
            value: 30,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Timer'), findsOneWidget);
      expect(find.text('30 s'), findsOneWidget);
    });

    testWidgets('Increment button increases the value by 10', (WidgetTester tester) async {
      int currentValue = 30;

      await tester.pumpWidget(
        MaterialApp(
          home: DurationInput(
            label: 'Timer',
            value: currentValue,
            onChanged: (newValue) {
              currentValue = newValue;
            },
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(currentValue, 40);
    });

    testWidgets('Decrement button decreases the value by 10', (WidgetTester tester) async {
      int currentValue = 30;

      await tester.pumpWidget(
        MaterialApp(
          home: DurationInput(
            label: 'Timer',
            value: currentValue,
            onChanged: (newValue) {
              currentValue = newValue;
            },
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(currentValue, 20);
    });

    testWidgets('Decrement button does not decrease below 10', (WidgetTester tester) async {
      int currentValue = 10;

      await tester.pumpWidget(
        MaterialApp(
          home: DurationInput(
            label: 'Timer',
            value: currentValue,
            onChanged: (newValue) {
              currentValue = newValue;
            },
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(currentValue, 10);
    });
  });
}
