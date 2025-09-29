class Task {
  final int? id;
  final String name;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final int priority;
  final int color;
  final bool done;

  Task({
    this.id,
    required this.name,
    required this.description,
    this.startDate,
    this.endDate,
    required this.priority,
    required this.color,
    this.done = false,
  });

  Task copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? priority,
    int? color,
    bool? done,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      priority: priority ?? this.priority,
      color: color ?? this.color,
      done: done ?? this.done,
    );
  }
}
