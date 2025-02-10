import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muay_time/model/timer_setting.dart';
import 'package:muay_time/viewmodel/timer_viewmodel.dart';
import 'timer_running_screen.dart';
import '../widgets/inputs.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          textAlign: TextAlign.center,
          'Set Timer Settings.',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<TimerCubit, TimerSettings>(
          builder: (context, timerSettings) {
            final trigger = context.read<TimerCubit>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                NumberInput(
                  label: 'Number of Rounds',
                  value: timerSettings.roundCount,
                  onChanged: (value) => trigger.updateRounds(value),
                ),
                DurationInput(
                  label: 'Round Duration (seconds)',
                  value: timerSettings.roundDuration.inSeconds,
                  onChanged: (value) =>
                      trigger.updateRoundDuration(Duration(seconds: value)),
                ),
                DurationInput(
                  label: 'Break Duration (seconds)',
                  value: timerSettings.breakDuration.inSeconds,
                  onChanged: (value) =>
                      trigger.updateBreakDuration(Duration(seconds: value)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TimerRunningScreen(settings: timerSettings),
                    ),
                  ),
                  child: const Text('Start Timer'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
