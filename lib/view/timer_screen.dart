import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muay_time/viewmodel/timer_viewmodel.dart';
import 'package:muay_time/widgets/inputs.dart';
import 'timer_running_screen.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerSettings = ref.watch(timerViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Fight Timer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set Timer Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            NumberInput(
              label: 'Number of Rounds',
              value: timerSettings.roundCount,
              onChanged: (value) =>
                  ref.read(timerViewModelProvider.notifier).updateRounds(value),
            ),
            DurationInput(
              label: 'Round Duration (seconds)',
              value: timerSettings.roundDuration.inSeconds,
              onChanged: (value) => ref
                  .read(timerViewModelProvider.notifier)
                  .updateRoundDuration(Duration(seconds: value)),
            ),
            DurationInput(
              label: 'Break Duration (seconds)',
              value: timerSettings.breakDuration.inSeconds,
              onChanged: (value) => ref
                  .read(timerViewModelProvider.notifier)
                  .updateBreakDuration(Duration(seconds: value)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TimerRunningScreen(),
                ),
              ),
              child: const Text('Start Timer'),
            ),
          ],
        ),
      ),
    );
  }
}
