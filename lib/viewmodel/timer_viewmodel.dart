import 'package:muay_time/model/timer_setting.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class TimerCubit extends Cubit<TimerSettings> {
  TimerCubit()
      : super(
    TimerSettings(
      roundCount: 3,
      roundDuration: const Duration(minutes: 3),
      breakDuration: const Duration(seconds: 30),
    ),
  );

  void updateRounds(int count) {
    emit(state.copyWith(roundCount: count));
  }

  void updateRoundDuration(Duration duration) {
    emit(state.copyWith(roundDuration: duration));
  }

  void updateBreakDuration(Duration duration) {
    emit(state.copyWith(breakDuration: duration));
  }
}
