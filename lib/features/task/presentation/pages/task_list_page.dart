import 'package:flutter/material.dart';
import 'package:too_do_app/features/task/domain/entities/task.dart';
import '../bloc/task_cubit.dart';
import 'task_edit_page.dart';
import 'task_detail_page.dart';
import '../widgets/task_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Your Daily Task')),
      body: BlocBuilder<TaskCubit, List<Task>>(
        builder: (context, tasks) {
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskItem(
                task: task,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaskDetailPage(task: task),
                    ),
                  );
                  context.read<TaskCubit>().loadTasks();
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskEditPage()),
          );
          context.read<TaskCubit>().loadTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
