import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muay_time/viewmodel/timer_viewmodel.dart';
import 'timer_running_screen.dart';
import '../widgets/inputs.dart';

class TimerSettingsScreen extends ConsumerWidget {
  const TimerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerSettings = ref.watch(timerViewModelProvider);
    final trigger = ref.watch(timerViewModelProvider.notifier);
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
              onChanged: (value) => trigger.updateRounds(value),
            ),
            DurationInput(
              label: 'Round Duration (seconds)',
              value: timerSettings.roundDuration.inSeconds,
              onChanged: (value) => trigger.updateRoundDuration(Duration(seconds: value)),
            ),
            DurationInput(
              label: 'Break Duration (seconds)',
              value: timerSettings.breakDuration.inSeconds,
              onChanged: (value) => trigger.updateBreakDuration(Duration(seconds: value)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TimerRunningScreen(settings: timerSettings),
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
