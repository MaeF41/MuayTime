import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muay_time/model/timer_setting.dart';

final timerViewModelProvider =
StateNotifierProvider<TimerViewModel, TimerSettings>((ref) {
  return TimerViewModel();
});

class TimerViewModel extends StateNotifier<TimerSettings> {
  TimerViewModel()
      : super(TimerSettings(
    roundCount: 3,
    roundDuration: const Duration(minutes: 3),
    breakDuration: const Duration(seconds: 30),
  ));

  void updateRounds(int count) {
    state = state.copyWith(roundCount: count);
  }

  void updateRoundDuration(Duration duration) {
    state = state.copyWith(roundDuration: duration);
  }

  void updateBreakDuration(Duration duration) {
    state = state.copyWith(breakDuration: duration);
  }
}
