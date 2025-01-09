import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muay_time/provider/timer_provider.dart';
import 'dart:async';


class TimerRunningScreen extends ConsumerStatefulWidget {
  const TimerRunningScreen({super.key});

  @override
  TimerRunningScreenState createState() => TimerRunningScreenState();
}

class TimerRunningScreenState extends ConsumerState<TimerRunningScreen> {
  Timer? _timer;
  int _currentRound = 0;
  int _currentTime = 0;
  bool _isBreak = false;

  @override
  void initState() {
    super.initState();
    _startRound();
  }

  void _startRound() {
    final settings = ref.read(timerProvider);
    setState(() {
      _currentRound++;
      _currentTime = settings.roundDuration.inSeconds;
      _isBreak = false;
    });

    _startTimer();
  }

  void _startBreak() {
    final settings = ref.read(timerProvider);
    setState(() {
      _currentTime = settings.breakDuration.inSeconds;
      _isBreak = true;
    });

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentTime <= 0) {
        timer.cancel();
        if (_isBreak || _currentRound == ref.read(timerProvider).roundCount) {
          // End round or all rounds
          if (_currentRound == ref.read(timerProvider).roundCount) {
            _finish();
          } else {
            _startRound();
          }
        } else {
          _startBreak();
        }
      } else {
        setState(() {
          _currentTime--;
        });
      }
    });
  }

  void _finish() {
    _timer?.cancel();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Timer Finished!')));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer Running'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isBreak ? 'Break Time' : 'Round $_currentRound',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$_currentTime s',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _timer?.cancel();
                Navigator.pop(context);
              },
              child: Text('Stop'),
            ),
          ],
        ),
      ),
    );
  }
}
