///
/// Represents static configuration data for the timer
///
class TimerSettings {
  final int roundCount;
  final Duration roundDuration;
  final Duration breakDuration;

  TimerSettings({
    required this.roundCount,
    required this.roundDuration,
    required this.breakDuration,
  });

  TimerSettings copyWith({
    int? roundCount,
    Duration? roundDuration,
    Duration? breakDuration,
  }) {
    return TimerSettings(
      roundCount: roundCount ?? this.roundCount,
      roundDuration: roundDuration ?? this.roundDuration,
      breakDuration: breakDuration ?? this.breakDuration,
    );
  }
}
