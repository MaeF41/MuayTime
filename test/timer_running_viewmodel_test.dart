import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muay_time/model/timer_setting.dart';
import 'package:muay_time/viewmodel/timer_running_viewmodel.dart';

typedef Ticker = Timer Function(Duration duration, void Function(Timer) callback);

void main() {
  group('TimerRunningCubit Tests', () {
    late TimerSettings settings;

    setUp(() {
      settings = TimerSettings(
        roundCount: 3,
        roundDuration: const Duration(seconds: 10),
        breakDuration: const Duration(seconds: 5),
      );
    });

    test('Initial state is correct', () {
      fakeTicker(Duration duration, void Function(Timer) callback) =>
          Timer.periodic(duration, (timer) => callback(timer));
      final cubit = TimerRunningCubit(settings, ticker: fakeTicker);

      final state = cubit.state;

      expect(state.currentRound, 1);
      expect(state.remainingTime, settings.roundDuration.inMilliseconds);
      expect(state.isBreak, false);
      expect(state.isPaused, false);
      expect(state.isFinished, false);
    });

    test('Timer transitions from round to break phase', () {
      FakeAsync().run((async) {
        fakeTicker(Duration duration, void Function(Timer) callback) {
          return Timer.periodic(duration, (timer) => callback(timer));
        }

        final cubit = TimerRunningCubit(settings, ticker: fakeTicker);

        cubit.startTimer();

        async.elapse(settings.roundDuration);

        final state = cubit.state;

        expect(state.isBreak, true);
        expect(state.currentRound, 1);
        expect(state.remainingTime, settings.breakDuration.inMilliseconds);
        expect(state.isFinished, false);
      });
    });

    test('Timer transitions from break to next round', () {
      FakeAsync().run((async) {
        fakeTicker(Duration duration, void Function(Timer) callback) {
          return Timer.periodic(duration, (timer) => callback(timer));
        }

        final cubit = TimerRunningCubit(settings, ticker: fakeTicker);

        cubit.startTimer();

        async.elapse(settings.roundDuration + settings.breakDuration);

        final state = cubit.state;

        expect(state.isBreak, false);
        expect(state.currentRound, 2);
        expect(state.remainingTime, settings.roundDuration.inMilliseconds);
        expect(state.isFinished, false);
      });
    });

    test('State transitions from round to break', () {
      FakeAsync().run((async) {
        fakeTicker(Duration duration, void Function(Timer) callback) {
          return Timer.periodic(duration, (timer) => callback(timer));
        }

        final cubit = TimerRunningCubit(settings, ticker: fakeTicker);

        cubit.startTimer();

        final totalDuration =
            (settings.roundDuration + settings.breakDuration) * settings.roundCount;
        async.elapse(totalDuration);

        final state = cubit.state;

        expect(state.isFinished, true);
        expect(state.isBreak, false);
        expect(state.currentRound, settings.roundCount);
      });
    });

    test('Timer pauses and resumes correctly', () {
      FakeAsync().run((async) {
        fakeTicker(Duration duration, void Function(Timer) callback) {
          return Timer.periodic(duration, (timer) => callback(timer));
        }

        final cubit = TimerRunningCubit(settings, ticker: fakeTicker);

        cubit.startTimer();

        async.elapse(const Duration(seconds: 2));

        cubit.stopTimer();

        final pausedState = cubit.state;

        expect(pausedState.isPaused, true);
        expect(pausedState.remainingTime, settings.roundDuration.inMilliseconds - 2000);

        cubit.startTimer();

        async.elapse(const Duration(seconds: 2));

        final resumedState = cubit.state;

        expect(resumedState.isPaused, false);
        expect(resumedState.remainingTime, settings.roundDuration.inMilliseconds - 4000);
      });
    });

    test('Timer handles stop and start correctly', () {
      FakeAsync().run((async) {
        fakeTicker(Duration duration, void Function(Timer) callback) {
          return Timer.periodic(duration, (timer) => callback(timer));
        }

        final cubit = TimerRunningCubit(settings, ticker: fakeTicker);

        cubit.startTimer();

        async.elapse(const Duration(seconds: 2));

        cubit.stopTimer();

        final stoppedState = cubit.state;

        expect(stoppedState.isPaused, true);
        expect(stoppedState.remainingTime, settings.roundDuration.inMilliseconds - 2000);

        cubit.startTimer();

        async.elapse(const Duration(seconds: 3));

        final resumedState = cubit.state;

        expect(resumedState.isPaused, false);
        expect(resumedState.remainingTime, settings.roundDuration.inMilliseconds - 5000);
      });


    });

    test('Transitions correctly within the last round', () {
      FakeAsync().run((async) {
        fakeTicker(Duration duration, void Function(Timer) callback) {
          return Timer.periodic(duration, (timer) => callback(timer));
        }

        final cubit = TimerRunningCubit(settings, ticker: fakeTicker);

        cubit.startTimer();

        async.elapse(settings.roundDuration); // Round 1
        async.elapse(settings.breakDuration); // Break 1
        async.elapse(settings.roundDuration); // Round 2
        async.elapse(settings.breakDuration); // Break 2
        async.elapse(settings.roundDuration); // Last Round (No Break)

        final state = cubit.state;

        expect(state.isFinished, true);
        expect(state.isBreak, false);
      });
    });
  });
}
