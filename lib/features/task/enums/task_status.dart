enum TaskStatus {
  todo,       // 0
  inProgress, // 1
  done,       // 2
  cancelled;  // 3

  static TaskStatus fromInt(int value) =>
      TaskStatus.values[value.clamp(0, TaskStatus.values.length - 1)];

  int toInt() => index;

  String get label => switch (this) {
    TaskStatus.todo       => 'To do',
    TaskStatus.inProgress => 'In progress',
    TaskStatus.done       => 'Done',
    TaskStatus.cancelled  => 'Cancelled',
  };
}