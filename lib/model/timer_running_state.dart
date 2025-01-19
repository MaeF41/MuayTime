///
/// Represents the dynamic state of the timer as it runs.
///
class TimerRunningState {
  final int currentRound;
  final int remainingTime; // In milliseconds
  final bool isBreak;
  final bool isPaused;
  final bool isFinished;

  TimerRunningState({
    required this.currentRound,
    required this.remainingTime,
    required this.isBreak,
    required this.isPaused,
    required this.isFinished,
  });

  TimerRunningState copyWith({
    int? currentRound,
    int? remainingTime,
    bool? isBreak,
    bool? isPaused,
    bool? isFinished,
  }) {
    return TimerRunningState(
      currentRound: currentRound ?? this.currentRound,
      remainingTime: remainingTime ?? this.remainingTime,
      isBreak: isBreak ?? this.isBreak,
      isPaused: isPaused ?? this.isPaused,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  // Formatted time in mm:ss:SS format
  String get formattedTime {
    final minutes = (remainingTime ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((remainingTime % 60000) ~/ 1000).toString().padLeft(2, '0');
    final milliseconds = ((remainingTime % 1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds:$milliseconds';
  }
}