import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDatasource datasource;

  TaskRepositoryImpl(this.datasource);

  @override
  Future<List<Task>> getTasks() async {
    return await datasource.getTasks();
  }

  @override
  Future<void> addTask(Task task) async {
    await datasource.insertTask(
      TaskModel(
        name: task.name,
        description: task.description,
        startDate: task.startDate,
        endDate: task.endDate,
        priority: task.priority,
        color: task.color,
        done: task.done,
      ),
    );
  }

  @override
  Future<void> updateTask(Task task) async {
    await datasource.updateTask(
      TaskModel(
        id: task.id,
        name: task.name,
        description: task.description,
        startDate: task.startDate,
        endDate: task.endDate,
        priority: task.priority,
        color: task.color,
        done: task.done,
      ),
    );
  }

  @override
  Future<void> deleteTask(int id) async {
    await datasource.deleteTask(id);
  }
}
