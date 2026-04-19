enum TaskPriority {
  low,      // 0
  medium,   // 1
  high,     // 2
  critical; // 3

  static TaskPriority fromInt(int value) =>
      TaskPriority.values[value.clamp(0, TaskPriority.values.length - 1)];

  int toInt() => index;

  String get label => switch (this) {
    TaskPriority.low      => 'Low',
    TaskPriority.medium   => 'Medium',
    TaskPriority.high     => 'High',
    TaskPriority.critical => 'Critical',
  };
}