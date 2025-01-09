import 'package:flutter_test/flutter_test.dart';
import 'package:muay_time/provider/timer_provider.dart';

void main() {
  group('TimerProvider Tests', () {
    test('Initial state is correct', () {
      final provider = TimerNotifier();

      expect(provider.state.roundCount, 3);
      expect(provider.state.roundDuration, Duration(minutes: 3));
      expect(provider.state.breakDuration, Duration(seconds: 30));
    });

    test('Updates round count', () {
      final provider = TimerNotifier();

      provider.updateRounds(5);

      expect(provider.state.roundCount, 5);
    });

    test('Updates round duration', () {
      final provider = TimerNotifier();

      provider.updateRoundDuration(Duration(minutes: 5));

      expect(provider.state.roundDuration, Duration(minutes: 5));
    });

    test('Updates break duration', () {
      final provider = TimerNotifier();

      provider.updateBreakDuration(Duration(seconds: 60));

      expect(provider.state.breakDuration, Duration(seconds: 60));
    });
  });
}
