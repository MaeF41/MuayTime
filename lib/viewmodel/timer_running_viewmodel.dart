import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muay_time/viewmodel/timer_viewmodel.dart';

final timerRunningViewModelProvider =
StateNotifierProvider<TimerRunningViewModel, TimerRunningState>((ref) {
  return TimerRunningViewModel(ref);
});

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
  final Ref ref;

  TimerRunningViewModel(this.ref)
      : super(TimerRunningState(
    currentRound: 0,
    remainingTime: 0,
    isBreak: false,
    isFinished: false,
  )) {
    _startNextPhase();
  }

  void _startNextPhase() {
    final settings = ref.read(timerViewModelProvider);
    if (state.isBreak) {
      _initializePhase(settings.breakDuration.inSeconds, false);
    } else {
      if (state.currentRound < settings.roundCount) {
        _initializePhase(settings.roundDuration.inSeconds, true);
        state = state.copyWith(currentRound: state.currentRound + 1);
      } else {
        _finishTimer();
      }
    }
  }

  void _initializePhase(int duration, bool isBreakPhase) {
    state = state.copyWith(
      remainingTime: duration,
      isBreak: isBreakPhase,
    );
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime > 0) {
        state = state.copyWith(remainingTime: state.remainingTime - 1);
      } else {
        timer.cancel();
        _startNextPhase();
      }
    });
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
