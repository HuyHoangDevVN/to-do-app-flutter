import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    int? id,
    required String name,
    required String description,
    DateTime? startDate,
    DateTime? endDate,
    required int priority,
    required int color,
    bool done = false,
  }) : super(
         id: id,
         name: name,
         description: description,
         startDate: startDate,
         endDate: endDate,
         priority: priority,
         color: color,
         done: done,
       );

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      startDate: map['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startDate'])
          : null,
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'])
          : null,
      priority: map['priority'],
      color: map['color'],
      done: map['done'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'priority': priority,
      'color': color,
      'done': done ? 1 : 0,
    };
  }
}
