import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muay_time/model/timer_running_state.dart';
import 'package:muay_time/model/timer_setting.dart';
import 'package:muay_time/view/timer_settings_screen.dart';
import 'package:muay_time/viewmodel/timer_running_viewmodel.dart';
import 'package:muay_time/widgets/haptic_text_button.dart';

class TimerRunningScreen extends StatelessWidget {
  final TimerSettings settings;

   TimerRunningScreen({super.key, required this.settings});

  final audioPlayer= AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerRunningCubit(
        settings,
        player: audioPlayer,
        ticker: (duration, callback) => Timer.periodic(duration, callback),
      )..startTimer(),
      child: BlocBuilder<TimerRunningCubit, TimerRunningState>(
        builder: (context, timerState) {
          final timerCubit = context.read<TimerRunningCubit>();

          final totalDuration = timerState.isBreak
              ? settings.breakDuration.inMilliseconds
              : settings.roundDuration.inMilliseconds;

          final progress = 1 - (timerState.remainingTime / totalDuration);

          return Scaffold(
            body: Stack(
              children: [
                Container(color: Colors.green),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 40),
                    width: MediaQuery.of(context).size.width * progress.clamp(0.0, 1.0),
                    color: Colors.red,
                  ),
                ),
                Center(
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
                        onPressed: () => pushReplaceToSettingsScreen(context),
                        child: const Text('Back to Settings'),
                      ),
                    ],
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(height: 48),
                            SafeArea(
                              child: Text(
                                timerState.isBreak
                                    ? 'Break Time'
                                    : 'Round ${timerState.currentRound} of ${settings.roundCount}',
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              timerState.formattedTime,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 48,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: conditionalActionButton(
                                    timerState, timerCubit)),
                            Expanded(
                              child: HapticTextButton(
                                onTap: () {
                                  timerCubit.stopTimer();
                                  pushReplaceToSettingsScreen(context);
                                },
                                child: const Text('Stop'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  HapticTextButton conditionalActionButton(
      TimerRunningState timerState, TimerRunningCubit timerCubit) {
    return timerState.isPaused
        ? HapticTextButton(
      onTap: () => timerCubit.startTimer(),
      child: const Text('Continue'),
    )
        : HapticTextButton(
      onTap: () => timerCubit.stopTimer(),
      child: const Text('Pause'),
    );
  }

  Future<dynamic> pushReplaceToSettingsScreen(BuildContext context) {
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) {
          return const SettingsScreen();
        },
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }
}
