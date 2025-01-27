import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muay_time/model/timer_running_state.dart';
import 'package:muay_time/model/timer_setting.dart';

typedef Ticker = Timer Function(Duration duration, void Function(Timer) callback);

class TimerRunningCubit extends Cubit<TimerRunningState> {
  Timer? _timer;
  final TimerSettings settings;
  final Ticker ticker;

  TimerRunningCubit(this.settings, {required this.ticker})
      : super(TimerRunningState(
    currentRound: 1,
    remainingTime: settings.roundDuration.inMilliseconds,
    isBreak: false,
    isPaused: false,
    isFinished: false,
  ));

  void start() {
    _startCountdown();
  }

  void continueTimer() {
    _startCountdown();
    emit(state.copyWith(isPaused: false));
  }

  void _startCountdown() {
    _timer?.cancel(); // Cancel existing timer

    _timer = ticker(const Duration(milliseconds: 10), (timer) {
      final remaining = state.remainingTime - 10;

      if (remaining > 0) {
        emit(state.copyWith(remainingTime: remaining));
      } else {
        timer.cancel();
        _transitionToNextPhase();
      }
    });
  }

  void _transitionToNextPhase() {
    if (state.isBreak) {
      if (state.currentRound < settings.roundCount) {
        emit(state.copyWith(
          currentRound: state.currentRound + 1,
          remainingTime: settings.roundDuration.inMilliseconds,
          isBreak: false,
        ));
        start();
      } else {
        _finishTimer();
      }
    } else {
      emit(state.copyWith(
        remainingTime: settings.breakDuration.inMilliseconds,
        isBreak: true,
      ));
      start();
    }
  }

  void _finishTimer() {
    _timer?.cancel();
    emit(state.copyWith(isFinished: true));
  }

  void stopTimer() {
    _timer?.cancel();
    emit(state.copyWith(isPaused: true));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
