import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/delete_task.dart';

class TaskCubit extends Cubit<List<Task>> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskCubit({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super([]);

  Future<void> loadTasks() async {
    emit(await getTasks());
  }

  Future<void> addNewTask(Task task) async {
    await addTask(task);
    await loadTasks();
  }

  Future<void> updateExistingTask(Task task) async {
    await updateTask(task);
    await loadTasks();
  }

  Future<void> deleteExistingTask(int id) async {
    await deleteTask(id);
    await loadTasks();
  }
}
