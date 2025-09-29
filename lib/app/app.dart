import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:too_do_app/features/counter/data/repositories/counter_repository_impl.dart';
import 'package:too_do_app/features/counter/presentation/bloc/counter_cubit.dart';
import 'package:too_do_app/features/task/data/datasources/task_local_datasource.dart';
import 'package:too_do_app/features/task/data/repositories/task_repository_impl.dart';
import 'package:too_do_app/features/task/domain/usecases/add_task.dart';
import 'package:too_do_app/features/task/domain/usecases/delete_task.dart';
import 'package:too_do_app/features/task/domain/usecases/get_tasks.dart';
import 'package:too_do_app/features/task/domain/usecases/update_task.dart';
import 'package:too_do_app/features/task/presentation/bloc/task_cubit.dart';
import 'package:too_do_app/features/task/presentation/pages/task_list_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CounterCubit(CounterRepositoryImpl())..loadCounter(),
        ),
        BlocProvider(
          create: (_) {
            final datasource = TaskLocalDatasource();
            final repository = TaskRepositoryImpl(datasource);
            return TaskCubit(
              getTasks: GetTasks(repository),
              addTask: AddTask(repository),
              updateTask: UpdateTask(repository),
              deleteTask: DeleteTask(repository),
            )..loadTasks();
          },
        ),
      ],
      child: MaterialApp(
        title: 'Task Management App',
        home:
            const TaskListPage(), // hoặc dùng Navigator/router để chọn màn hình
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
