import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muay_time/model/timer_running_state.dart';
import 'package:muay_time/model/timer_setting.dart';
import 'package:muay_time/view/timer_settings_screen.dart';
import 'package:muay_time/viewmodel/timer_running_viewmodel.dart';
import 'package:muay_time/widgets/haptic_text_button.dart';

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

    final timerViewModel = ref.read(timerRunningViewModelProvider(widget.settings).notifier);
    timerViewModel.start();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerRunningViewModelProvider(widget.settings));

    final totalDuration = timerState.isBreak
        ? widget.settings.breakDuration.inMilliseconds
        : widget.settings.roundDuration.inMilliseconds;

    final progress = 1 - (timerState.remainingTime / totalDuration);

    final timerViewModel = ref.read(timerRunningViewModelProvider(widget.settings).notifier);

    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.green),
          Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 40), // Smooth transition
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
                            SizedBox(
                              height: 48,
                            ),
                            SafeArea(
                              child: Text(
                                timerState.isBreak
                                    ? 'Break Time'
                                    : 'Round ${timerState.currentRound} of ${widget.settings.roundCount}',
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                            Spacer(),
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
                            Expanded(child: conditionalActionButton(timerState, timerViewModel)),
                            Expanded(
                              child: HapticTextButton(
                                onTap: () {
                                  timerViewModel.stopTimer();
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
  }

  HapticTextButton conditionalActionButton(
          TimerRunningState timerState, TimerRunningViewModel timerViewModel) =>
      timerState.isPaused
          ? HapticTextButton(
              onTap: () => timerViewModel.continueTimer(),
              child: const Text('Continue'),
            )
          : HapticTextButton(
              onTap: () => timerViewModel.stopTimer(),
              child: const Text('Pause'),
            );

  Future<dynamic> pushReplaceToSettingsScreen(BuildContext context) {
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) {
          return SettingsScreen();
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
