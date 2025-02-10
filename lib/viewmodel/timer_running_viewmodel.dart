import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muay_time/model/timer_running_state.dart';
import 'package:muay_time/model/timer_setting.dart';

typedef Ticker = Timer Function(Duration duration, void Function(Timer) callback);

enum SoundTypeAsset {
  shortBell("assets/sound/bell-short.mp3"),
  longBell("assets/sound/bell.mp3");

  final String dir;

  const SoundTypeAsset(this.dir);
}

class TimerRunningCubit extends Cubit<TimerRunningState> {
  Timer? _timer;
  final TimerSettings settings;
  final Ticker ticker;

  TimerRunningCubit(this.settings, {required this.ticker,  })
      : super(TimerRunningState(
          currentRound: 1,
          remainingTime: settings.roundDuration.inMilliseconds,
          isBreak: false,
          isPaused: false,
          isFinished: false,
        ));

  final shortPlayer = AudioPlayer();
  final longPlayer = AudioPlayer();

  void _playSound(AudioPlayer player) {
    player.play();
  }


  void startTimer() {
  shortPlayer.setAsset(SoundTypeAsset.shortBell.dir);
  longPlayer.setAsset(SoundTypeAsset.longBell.dir);

  _startCountdown();
    emit(state.copyWith(isPaused: false));
  }

  void _startCountdown() {
    _timer?.cancel(); // Cancel existing timer

    _timer = ticker(const Duration(milliseconds: 10), (timer) {
      final remaining = state.remainingTime - 10;

      if (remaining > 0) {
        emit(state.copyWith(remainingTime: remaining));
      } else {
        timer.cancel();
        _transitionToNextPhase();
      }
    });
  }

  void _transitionToNextPhase() {
    _playSound(shortPlayer);
    if (state.isBreak) {
      _handleBreakPhase();
    } else {
      _handleRoundPhase();
    }
  }

  void _handleBreakPhase() {
    _startNextRound();
  }

  void _handleRoundPhase() {
    if (_isLastRound()) {
      _playSound(shortPlayer);
      _finishTimer();
    } else {
      emit(state.copyWith(
        remainingTime: settings.breakDuration.inMilliseconds,
        isBreak: true,
      ));
      startTimer();
    }
  }

  bool _isLastRound() {
    return state.currentRound == settings.roundCount;
  }

  void _startNextRound() {
    emit(state.copyWith(
      currentRound: state.currentRound + 1,
      remainingTime: settings.roundDuration.inMilliseconds,
      isBreak: false,
    ));
    startTimer();
  }

  void _finishTimer() {
    _timer?.cancel();
    _playSound(longPlayer);
    emit(state.copyWith(isFinished: true));
  }

  void stopTimer() {
    _timer?.cancel();
    emit(state.copyWith(isPaused: true));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
