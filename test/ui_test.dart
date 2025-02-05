import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muay_time/app.dart';
import 'package:muay_time/view/timer_settings_screen.dart';
import 'package:muay_time/viewmodel/timer_viewmodel.dart';

import 'harness.dart';

void main() {
  Size iphone16ProLogicalSize = Size(393, 852);
  // TODO: FIX THIS. I WANT 100% test coverage
  // testWidgets('Complete flow test with goldens', (WidgetTester tester) async {
  //   await tester.binding.setSurfaceSize(iphone16ProLogicalSize);
  //   loadFonts();
  //
  //   await tester.pumpApp();
  //
  //   await tester.pumpAndSettle();
  //   await expectLater(
  //     find.byType(MaterialApp),
  //     matchesGoldenFile('goldens/main_screen.png'),
  //   );
  //
  //   final incrementButton = find.widgetWithIcon(IconButton, Icons.add).first;
  //   await tester.tap(incrementButton);
  //   await tester.pump();
  //
  //   expect(find.text('4'), findsOneWidget);
  //
  //   final startButton = find.text('Start Timer');
  //   await tester.tap(startButton);
  //
  //   await tester.pump();
  //   await tester.pump(const Duration(milliseconds: 300));
  //
  //   expect(find.text('Round 1 of 4'), findsOneWidget);
  //
  //   await expectLater(
  //     find.byType(MaterialApp),
  //     matchesGoldenFile('goldens/timer_ticking_screen.png'),
  //   );
  //
  //   await tester.pump();
  //   await tester.pump(const Duration(seconds: 179));
  //   await tester.pump(const Duration(milliseconds: 690));
  //
  //   await expectLater(
  //     find.byType(MaterialApp),
  //     matchesGoldenFile('goldens/timer_ticking_passed_time_screen.png'),
  //   );
  // });

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
    expect(find.text('Round 1 of 4'), findsOneWidget);

    await tester.tap(find.text('Stop'));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.text('Round 1'), findsNothing);
  });

  testWidgets('Dedicated button pauses the timer and then the other button continues the timer',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(iphone16ProLogicalSize);

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
    expect(find.text('Round 1 of 4'), findsOneWidget);

    expect(find.text('02:58:70'), findsOneWidget); // 1s 300ms passed because of the previous pumps

    await tester.tap(find.text('Pause'));
    await tester.pumpAndSettle();

    expect(
        find.text('02:58:70'),
        reason: "pumpAndSettle has no power cause the timer is passed",
        findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(
        find.text('02:57:70'),
        reason: "pump 1 second after the timer continuation",
        findsOneWidget);
  });
  // TODO: FIX THIS. I WANT 100% test coverage
  // testWidgets('Break round looks good', (WidgetTester tester) async {
  //   await tester.binding.setSurfaceSize(iphone16ProLogicalSize);
  //   loadFonts();
  //
  //   final roundDuration = const Duration(seconds: 3);
  //
  //   final fakeTimerCubit = TimerCubit();
  //   fakeTimerCubit.updateBreakDuration(const Duration(seconds: 6));
  //   fakeTimerCubit.updateRoundDuration(roundDuration);
  //   fakeTimerCubit.updateRounds(2);
  //
  //   await tester.pumpAppWithOverrides(fakeTimerCubit);
  //
  //   expect(find.text('2'), findsOneWidget);
  //
  //   final startButton = find.text('Start Timer');
  //   await tester.tap(startButton);
  //
  //   await tester.pump();
  //   await tester.pump(roundDuration);
  //
  //   await expectLater(
  //     find.byType(MaterialApp),
  //     matchesGoldenFile('goldens/timer_break_screen.png'),
  //   );
  //
  //   expect(find.text('Round 1'), findsNothing);
  //   expect(find.text('Break Time'), findsOneWidget);
  //   expect(find.text('00:06:00'), findsOneWidget);
  // });
  //
  // testWidgets('User should be able to nav to settings screen when the timer finished',
  //     (WidgetTester tester) async {
  //   await tester.binding.setSurfaceSize(iphone16ProLogicalSize);
  //   loadFonts();
  //
  //   final fakeTimerCubit = TimerCubit();
  //   fakeTimerCubit.updateBreakDuration(const Duration(seconds: 0));
  //   fakeTimerCubit.updateRoundDuration(const Duration(seconds: 0));
  //   fakeTimerCubit.updateRounds(1);
  //
  //   await tester.pumpAppWithOverrides(fakeTimerCubit);
  //
  //   final startButton = find.text('Start Timer');
  //   await tester.tap(startButton);
  //
  //   await tester.pumpAndSettle();
  //
  //   expect(find.text('Timer Finished!'), findsOneWidget);
  //
  //   expect(find.byType(TimerRunningScreen), findsOneWidget);
  //
  //   await expectLater(
  //     find.byType(MaterialApp),
  //     matchesGoldenFile('goldens/timer_finished_screen.png'),
  //   );
  //
  //   await tester.tap(find.byType(ElevatedButton));
  //   await tester.pumpAndSettle();
  //
  //   expect(find.byType(TimerRunningScreen), findsNothing);
  // });
}

extension PumpsExt on WidgetTester {
  Future<void> pumpApp() async {
    await pumpWidget(
      BlocProvider(
        create: (context) => TimerCubit(),
        child: const MyApp(),
      ),
    );
  }

  Future<void> pumpAppWithOverrides(TimerCubit fakeCubit) async {
    await pumpWidget(
      BlocProvider(
        create: (context) => fakeCubit,
        child: const MyApp(),
      ),
    );
  }
}
