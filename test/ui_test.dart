import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muay_time/app.dart';
import 'package:muay_time/view/timer_running_screen.dart';
import 'package:muay_time/view/timer_settings_screen.dart';
import 'package:muay_time/viewmodel/timer_viewmodel.dart';

import 'harness.dart';

void main() {
  Size iphone16ProLogicalSize = Size(393, 852);

  testWidgets('Complete flow test with goldens', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(iphone16ProLogicalSize);
    loadFonts();

    await tester.pumpApp();

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

  testWidgets('Dedicated button stops the timer and nav to the settings screen',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(iphone16ProLogicalSize);
    loadFonts();

    await tester.pumpApp();

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

  testWidgets('Break round looks good', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(iphone16ProLogicalSize);
    loadFonts();

    final roundDuration = const Duration(seconds: 3);

    final fakeTimerViewModel = TimerViewModel();
    fakeTimerViewModel.updateBreakDuration(const Duration(seconds: 6));
    fakeTimerViewModel.updateRoundDuration(roundDuration);
    fakeTimerViewModel.updateRounds(2);

    await tester.pumpAppWithOverrides([
      timerViewModelProvider.overrideWith(
        (ref) => fakeTimerViewModel, // Return a new instance of TimerViewModel here
      ),
    ]);

    expect(find.text('2'), findsOneWidget);

    final startButton = find.text('Start Timer');
    await tester.tap(startButton);

    await tester.pump();
    await tester.pump(roundDuration);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/timer_break_screen.png'),
    );

    expect(find.text('Round 1'), findsNothing);
    expect(find.text('Break Time'), findsOneWidget);
    expect(find.text('00:06:00'), findsOneWidget);
  });

  testWidgets('User should be able to nav to settings screen when the timer finished', (WidgetTester tester) async{
    await tester.binding.setSurfaceSize(iphone16ProLogicalSize);
    loadFonts();


    final fakeTimerViewModel = TimerViewModel();
    fakeTimerViewModel.updateBreakDuration(const Duration(seconds: 0));
    fakeTimerViewModel.updateRoundDuration(const Duration(seconds: 0));
    fakeTimerViewModel.updateRounds(1);

    await tester.pumpAppWithOverrides([
      timerViewModelProvider.overrideWith(
            (ref) => fakeTimerViewModel, // Return a new instance of TimerViewModel here
      ),
    ]);

    final startButton = find.text('Start Timer');
    await tester.tap(startButton);

    await tester.pumpAndSettle();

    expect(find.text('Timer Finished!'), findsOneWidget);

    expect(find.byType(TimerRunningScreen), findsOneWidget);


    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/timer_finished_screen.png'),
    );


    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.byType(TimerRunningScreen), findsNothing);

  });
}

extension PumpsExt on WidgetTester {
  Future<void> pumpApp() async => pumpWidget(const ProviderScope(child: MyApp()));

  Future<void> pumpAppWithOverrides(List<Override> overrides) async {
    await pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MyApp(),
      ),
    );
  }
}
