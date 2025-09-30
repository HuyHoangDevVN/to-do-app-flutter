import 'package:flutter/material.dart';
import 'package:too_do_app/features/task/domain/entities/task.dart';
import '../bloc/task_cubit.dart';
import 'task_edit_page.dart';
import 'task_detail_page.dart';
import '../widgets/task_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskCubit>().loadTasks();
    });
  }

  Future<bool?> _confirmDelete(BuildContext context, Task t) async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa "${t.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý công việc')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm nhiệm vụ',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _query = ''),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              onChanged: (v) => setState(() => _query = v.trim()),
            ),
          ),
          Expanded(
            child: BlocBuilder<TaskCubit, List<Task>>(
              builder: (context, tasks) {
                final filtered = _query.isEmpty
                    ? tasks
                    : tasks
                          .where(
                            (t) =>
                                t.name.toLowerCase().contains(
                                  _query.toLowerCase(),
                                ) ||
                                t.description.toLowerCase().contains(
                                  _query.toLowerCase(),
                                ),
                          )
                          .toList();

                if (filtered.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async =>
                        context.read<TaskCubit>().loadTasks(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.12,
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.list_alt,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Không có nhiệm vụ',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Nhấn nút + để thêm nhiệm vụ mới',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => context.read<TaskCubit>().loadTasks(),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80, top: 6),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final task = filtered[index];
                      return Dismissible(
                        key: ValueKey(task.id ?? task.hashCode),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) async {
                          final ok = await _confirmDelete(context, task);
                          if (ok == true) {
                            if (task.id != null)
                              await context
                                  .read<TaskCubit>()
                                  .deleteExistingTask(task.id!);
                            context.read<TaskCubit>().loadTasks();
                          }
                          return ok == true;
                        },
                        background: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          padding: const EdgeInsets.only(right: 20),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: TaskItem(
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
                          onChecked: (v) async {
                            if (v != null) {
                              await context
                                  .read<TaskCubit>()
                                  .updateExistingTask(task.copyWith(done: v));
                              context.read<TaskCubit>().loadTasks();
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
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
