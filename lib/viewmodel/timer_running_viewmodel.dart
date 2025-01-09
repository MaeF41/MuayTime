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

  TimerRunningState.initial()
      : currentRound = 1,
        remainingTime = 0,
        isBreak = false,
        isFinished = false;

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

  TimerRunningViewModel(this.ref) : super(TimerRunningState.initial());

  void start() {
    final settings = ref.read(timerViewModelProvider);
    _initializePhase(settings.roundDuration.inSeconds, isBreak: false);
  }

  void _initializePhase(int duration, {required bool isBreak}) {
    state = state.copyWith(
      remainingTime: duration,
      isBreak: isBreak,
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
        _transitionToNextPhase();
      }
    });
  }

  void _transitionToNextPhase() {
    final settings = ref.read(timerViewModelProvider);

    if (state.isBreak) {
      if (state.currentRound < settings.roundCount) {
        state = state.copyWith(currentRound: state.currentRound + 1);
        _initializePhase(settings.roundDuration.inSeconds, isBreak: false);
      } else {
        _finishTimer();
      }
    } else {
      _initializePhase(settings.breakDuration.inSeconds, isBreak: true);
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
