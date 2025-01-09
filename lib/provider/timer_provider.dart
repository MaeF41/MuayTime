
import 'package:muay_time/model/timer_setting.dart';
import 'package:riverpod/riverpod.dart';

final timerProvider = StateNotifierProvider<TimerNotifier, TimerSettings>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<TimerSettings> {
  TimerNotifier() : super(TimerSettings(
    roundCount: 3,
    roundDuration: Duration(minutes: 3),
    breakDuration: Duration(seconds: 30),
  ));

  void updateRounds(int count) {
    state = TimerSettings(
      roundCount: count,
      roundDuration: state.roundDuration,
      breakDuration: state.breakDuration,
    );
  }

  void updateRoundDuration(Duration duration) {
    state = TimerSettings(
      roundCount: state.roundCount,
      roundDuration: duration,
      breakDuration: state.breakDuration,
    );
  }

  void updateBreakDuration(Duration duration) {
    state = TimerSettings(
      roundCount: state.roundCount,
      roundDuration: state.roundDuration,
      breakDuration: duration,
    );
  }
}
