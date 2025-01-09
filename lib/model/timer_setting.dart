class TimerSettings {
  final int roundCount;
  final Duration roundDuration;
  final Duration breakDuration;

  TimerSettings({
    required this.roundCount,
    required this.roundDuration,
    required this.breakDuration,
  });

/// prep for hive
  // Map<String, dynamic> toJson() => {
  //   'roundCount': roundCount,
  //   'roundDuration': roundDuration.inSeconds,
  //   'breakDuration': breakDuration.inSeconds,
  // };
  //
  // factory TimerSettings.fromJson(Map<String, dynamic> json) => TimerSettings(
  //   roundCount: json['roundCount'],
  //   roundDuration: Duration(seconds: json['roundDuration']),
  //   breakDuration: Duration(seconds: json['breakDuration']),
  // );
}
