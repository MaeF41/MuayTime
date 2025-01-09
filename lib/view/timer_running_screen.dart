import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muay_time/viewmodel/timer_running_viewmodel.dart';

class TimerRunningScreen extends ConsumerWidget {
  const TimerRunningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerRunningViewModelProvider);
    final timerViewModel = ref.read(timerRunningViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer Running'),
      ),
      body: Center(
        child: timerState.isFinished
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Timer Finished!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Settings'),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              timerState.isBreak
                  ? 'Break Time'
                  : 'Round ${timerState.currentRound}',
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              '${timerState.remainingTime} s',
              style: const TextStyle(
                  fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                timerViewModel.stopTimer();
                Navigator.pop(context);
              },
              child: const Text('Stop'),
            ),
          ],
        ),
      ),
    );
  }
}
