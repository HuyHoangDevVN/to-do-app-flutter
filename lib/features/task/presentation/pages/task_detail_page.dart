import 'package:flutter/material.dart';
import '../bloc/task_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';

class TaskDetailPage extends StatelessWidget {
  final Task task;
  const TaskDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${task.description}'),
            const SizedBox(height: 10),
            Text('Priority: ${['Low', 'Medium', 'High'][task.priority]}'),
            const SizedBox(height: 10),
            Text('Start: ${task.startDate?.toString() ?? 'N/A'}'),
            Text('End: ${task.endDate?.toString() ?? 'N/A'}'),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('Done: '),
                Checkbox(
                  value: task.done,
                  onChanged: (val) async {
                    await context.read<TaskCubit>().updateExistingTask(
                      task.copyWith(done: val ?? false),
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                await context.read<TaskCubit>().deleteExistingTask(task.id!);
                Navigator.pop(context);
              },
              child: const Text('Delete Task'),
            ),
          ],
        ),
      ),
    );
  }
}
