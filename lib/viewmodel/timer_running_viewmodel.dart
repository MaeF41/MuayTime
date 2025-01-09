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
  final int remainingTime; // In milliseconds
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

  // Formatted time in mm:ss:SS format
  String get formattedTime {
    final minutes = (remainingTime ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((remainingTime % 60000) ~/ 1000).toString().padLeft(2, '0');
    final milliseconds = ((remainingTime % 1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds:$milliseconds';
  }
}

class TimerRunningViewModel extends StateNotifier<TimerRunningState> {
  Timer? _timer;
  final TimerSettings settings;
  final Ticker ticker;
  int elapsedTicks = 0;

  TimerRunningViewModel(this.settings, {required this.ticker})
      : super(TimerRunningState(
    currentRound: 1,
    remainingTime: settings.roundDuration.inMilliseconds,
    isBreak: false,
    isFinished: false,
  ));

  void start() {
    elapsedTicks = 0;
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = ticker(const Duration(milliseconds: 10), (timer) {
      elapsedTicks += 1;
      final elapsedTime = elapsedTicks * 10; // Total elapsed time in ms
      final remaining = settings.roundDuration.inMilliseconds - elapsedTime;

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
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
