import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muay_time/model/timer_setting.dart';

typedef Ticker = Timer Function(Duration duration, void Function(Timer) callback);

final timerRunningViewModelProvider =
StateNotifierProvider.autoDispose.family<TimerRunningViewModel, TimerRunningState, TimerSettings>(
      (ref, settings) {
    return TimerRunningViewModel(
      settings,
      ticker: (duration, callback) => Timer.periodic(duration, callback),
    );
  },
);

class TimerRunningState {
  final int currentRound;
  final int remainingTime;
  final bool isBreak;
  final bool isFinished;

  TimerRunningState({
    required this.currentRound,
    required this.remainingTime,
    required this.isBreak,
    required this.isFinished,
  });

  TimerRunningState copyWith({
    int? currentRound,
    int? remainingTime,
    bool? isBreak,
    bool? isFinished,
  }) {
    return TimerRunningState(
      currentRound: currentRound ?? this.currentRound,
      remainingTime: remainingTime ?? this.remainingTime,
      isBreak: isBreak ?? this.isBreak,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

class TimerRunningViewModel extends StateNotifier<TimerRunningState> {
  Timer? _timer;
  final TimerSettings settings;
  final Ticker ticker;

  TimerRunningViewModel(this.settings, {required this.ticker})
      : super(TimerRunningState(
    currentRound: 1,
    remainingTime: settings.roundDuration.inSeconds,
    isBreak: false,
    isFinished: false,
  ));


  void start() {
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = ticker(const Duration(seconds: 1), (timer) {
      if (state.remainingTime > 0) {
        state = state.copyWith(remainingTime: state.remainingTime - 1);
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
          remainingTime: settings.roundDuration.inSeconds,
          isBreak: false,
        );
        _startCountdown();
      } else {
        _finishTimer();
      }
    } else {
      state = state.copyWith(
        remainingTime: settings.breakDuration.inSeconds,
        isBreak: true,
      );
      _startCountdown();
    }
  }

  void _finishTimer() {
    _timer?.cancel();
    state = state.copyWith(isFinished: true);
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
