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
      expect(state.remainingTime, settings.roundDuration.inMilliseconds);
      expect(state.isBreak, false);
      expect(state.isFinished, false);
    });

    test('Timer starts only once when the screen initializes', () {
      FakeAsync().run((async) {
        fakeTicker(Duration duration, void Function(Timer) callback) {
          return Timer.periodic(duration, (timer) => callback(timer));
        }

        final viewModel = TimerRunningViewModel(
          settings,
          ticker: fakeTicker,
        );

        expect(viewModel.state.remainingTime, settings.roundDuration.inMilliseconds);

        viewModel.start();

        async.elapse(const Duration(milliseconds: 10));

        expect(viewModel.state.remainingTime, settings.roundDuration.inMilliseconds - 10);

        async.elapse(const Duration(milliseconds: 20));
      });
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
        expect(viewModel.state.remainingTime,
            settings.roundDuration.inMilliseconds - 1000); //milliseconds
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

        viewModel.start();

        async.elapse(settings.roundDuration);

        expect(viewModel.state.isBreak, true);
        expect(viewModel.state.remainingTime, settings.breakDuration.inMilliseconds);
      });
    });

    test('Timer finishes after all rounds', () {
      FakeAsync().run((async) {
        fakeTicker(Duration duration, void Function(Timer) callback) {
          return Timer.periodic(duration, (timer) => callback(timer));
        }

        final viewModel = TimerRunningViewModel(
          settings,
          ticker: fakeTicker,
        );

        viewModel.start();

        final totalDuration =
            (settings.roundDuration + settings.breakDuration) * settings.roundCount;
        async.elapse(totalDuration);

        async.flushTimers();

        expect(viewModel.state.isFinished, true);
      });
    });
  });
}
