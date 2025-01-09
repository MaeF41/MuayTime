import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:muay_time/model/timer_setting.dart';
import 'package:muay_time/viewmodel/timer_running_viewmodel.dart';

void main() {
  group('TimerRunningViewModel Tests', () {
    late ProviderContainer container;
    late TimerSettings settings;

    setUp(() {
      container = ProviderContainer();
      settings = TimerSettings(
        roundCount: 3,
        roundDuration: const Duration(seconds: 10),
        breakDuration: const Duration(seconds: 5),
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state is correct', () {
      container.read(timerRunningViewModelProvider(settings).notifier);
      final state = container.read(timerRunningViewModelProvider(settings));

      expect(state.currentRound, 1);
      expect(state.remainingTime, settings.roundDuration.inSeconds);
      expect(state.isBreak, false);
      expect(state.isFinished, false);
    });

    test('Start transitions to countdown state with FakeAsync', () {
      FakeAsync().run((async) {
        fakeTicker(Duration duration, void Function(Timer) callback) {
          return Timer.periodic(duration, (timer) => callback(timer));
        }

        final viewModel = TimerRunningViewModel(
          settings,
          ticker: fakeTicker,
        );

        viewModel.start();
        async.elapse(const Duration(seconds: 1));
        expect(viewModel.state.remainingTime, settings.roundDuration.inSeconds - 1);
      });
    });


    test('State transitions from round to break', () {
      FakeAsync().run((async) {
        fakeTicker(Duration duration, void Function(Timer) callback) {
          return Timer.periodic(duration, (timer) => callback(timer));
        }

        final viewModel = TimerRunningViewModel(
          settings,
          ticker: fakeTicker,
        );

        // Start the timer
        viewModel.start();

        async.elapse(settings.roundDuration);

        expect(viewModel.state.isBreak, false);

        async.elapse(const Duration(seconds: 1));
        expect(viewModel.state.isBreak, true);

        expect(viewModel.state.remainingTime, settings.breakDuration.inSeconds);
      });
    });

    test('Timer finishes after all rounds', () {
      final viewModel =
      container.read(timerRunningViewModelProvider(settings).notifier);

      // Simulate end of last round
      viewModel.state = viewModel.state.copyWith(
        currentRound: 3,
        remainingTime: 0,
        isBreak: false,
      );
      viewModel.start();

      expect(
        container.read(timerRunningViewModelProvider(settings)).isFinished,
        true,
      );
    });
  });
}
