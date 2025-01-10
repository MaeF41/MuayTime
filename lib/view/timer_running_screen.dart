import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muay_time/model/timer_setting.dart';
import 'package:muay_time/viewmodel/timer_running_viewmodel.dart';

class TimerRunningScreen extends ConsumerStatefulWidget {
  final TimerSettings settings;

  const TimerRunningScreen({super.key, required this.settings});

  @override
  TimerRunningScreenState createState() => TimerRunningScreenState();
}

class TimerRunningScreenState extends ConsumerState<TimerRunningScreen> {
  @override
  void initState() {
    super.initState();

    final timerViewModel =
    ref.read(timerRunningViewModelProvider(widget.settings).notifier);
    timerViewModel.start();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerRunningViewModelProvider(widget.settings));

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
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SizedBox(
                width: 234,
                child: Text(
                  textAlign: TextAlign.start,
                  timerState.formattedTime,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final timerViewModel = ref.read(
                    timerRunningViewModelProvider(widget.settings)
                        .notifier);
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
