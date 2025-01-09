import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muay_time/provider/timer_provider.dart';
import 'package:muay_time/screen/timer_running_screen.dart';


class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerSettings = ref.watch(timerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Fight Timer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Timer Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _NumberInput(
              label: 'Number of Rounds',
              value: timerSettings.roundCount,
              onChanged: (value) => ref
                  .read(timerProvider.notifier)
                  .updateRounds(value),
            ),
            _DurationInput(
              label: 'Round Duration (seconds)',
              value: timerSettings.roundDuration.inSeconds,
              onChanged: (value) => ref
                  .read(timerProvider.notifier)
                  .updateRoundDuration(Duration(seconds: value)),
            ),
            _DurationInput(
              label: 'Break Duration (seconds)',
              value: timerSettings.breakDuration.inSeconds,
              onChanged: (value) => ref
                  .read(timerProvider.notifier)
                  .updateBreakDuration(Duration(seconds: value)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Spusti časovač
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimerRunningScreen()),
                );
              },
              child: Text('Start Timer'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberInput extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _NumberInput({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => onChanged(value > 1 ? value - 1 : 1),
            ),
            Text('$value', style: TextStyle(fontSize: 18)),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }
}

class _DurationInput extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _DurationInput({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => onChanged(value > 10 ? value - 10 : 10),
            ),
            Text('$value s', style: TextStyle(fontSize: 18)),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => onChanged(value + 10),
            ),
          ],
        ),
      ],
    );
  }
}
