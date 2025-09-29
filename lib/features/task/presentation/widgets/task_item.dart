import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskItem({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.name),
      subtitle: Text(task.description),
      leading: CircleAvatar(
        backgroundColor: Color(task.color),
        child: Text(task.name[0]),
      ),
      trailing: Icon(
        task.done ? Icons.check_circle : Icons.radio_button_unchecked,
        color: task.done ? Colors.green : Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
