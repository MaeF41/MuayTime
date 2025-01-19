import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muay_time/model/timer_running_state.dart';
import 'package:muay_time/model/timer_setting.dart';

typedef Ticker = Timer Function(Duration duration, void Function(Timer) callback);

final timerRunningViewModelProvider = StateNotifierProvider.autoDispose
    .family<TimerRunningViewModel, TimerRunningState, TimerSettings>(
  (ref, settings) {
    return TimerRunningViewModel(
      settings,
      ticker: (duration, callback) => Timer.periodic(duration, callback),
    );
  },
);

class TimerRunningViewModel extends StateNotifier<TimerRunningState> {
  Timer? _timer;
  final TimerSettings settings;
  final Ticker ticker;

  TimerRunningViewModel(this.settings, {required this.ticker})
      : super(TimerRunningState(
          currentRound: 1,
          remainingTime: settings.roundDuration.inMilliseconds,
          isBreak: false,
          isPaused: false,
          isFinished: false,
        ));

  void start() { // this call is called on TimerRunningScreen init
    _startCountdown();
  }

  void continueTimer() {
    _startCountdown();
    state = state.copyWith(isPaused: false);
  }

  void _startCountdown() {
    _timer?.cancel(); // Cancel any existing timer to prevent overlaps

    _timer = ticker(const Duration(milliseconds: 10), (timer) {
      final remaining = state.remainingTime - 10; // Subtract 10ms on every tick

      if (remaining > 0) {
        state = state.copyWith(remainingTime: remaining);
      } else {
        timer.cancel();
        _transitionToNextPhase();
      }
    });
  }

  void _transitionToNextPhase() {
    if (state.isBreak) {
      if (state.currentRound < settings.roundCount) {
        state = state.copyWith(
          currentRound: state.currentRound + 1,
          remainingTime: settings.roundDuration.inMilliseconds,
          isBreak: false,
        );
        start(); // Restart timer for next round
      } else {
        _finishTimer();
      }
    } else {
      state = state.copyWith(
        remainingTime: settings.breakDuration.inMilliseconds,
        isBreak: true,
      );
      start(); // Restart timer for break
    }
  }

  void _finishTimer() {
    _timer?.cancel();
    state = state.copyWith(isFinished: true);
  }

  void stopTimer() {
    _timer?.cancel();
    state = state.copyWith(isPaused: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
