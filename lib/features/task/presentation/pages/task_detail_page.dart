import 'package:flutter/material.dart';
import '../bloc/task_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import 'task_edit_page.dart';

class TaskDetailPage extends StatelessWidget {
  final Task task;
  const TaskDetailPage({super.key, required this.task});

  String _formatDate(DateTime? d) {
    if (d == null) return 'Chưa chọn';
    final local = d.toLocal();
    return '${local.day.toString().padLeft(2, '0')}-${local.month.toString().padLeft(2, '0')}-${local.year.toString().padLeft(4, '0')}';
  }

  String _priorityText(int p) {
    switch (p) {
      case 0:
        return 'Thấp';
      case 1:
        return 'Trung bình';
      case 2:
      default:
        return 'Cao';
    }
  }

  Color _priorityColor(int p) {
    switch (p) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.orange;
      case 2:
      default:
        return Colors.red;
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn xóa nhiệm vụ này?'),
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
    if (ok == true) {
      if (task.id != null) {
        await context.read<TaskCubit>().deleteExistingTask(task.id!);
      }
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxWidth =
        720.0; // giới hạn chiều rộng để giữ trải nghiệm đọc tốt trên tablet
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(task.name, overflow: TextOverflow.ellipsis),
          actions: [
            IconButton(
              tooltip: 'Chỉnh sửa',
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => TaskEditPage(task: task)),
                );
                if (Navigator.of(context).canPop()) Navigator.of(context).pop();
              },
            ),
            IconButton(
              tooltip: 'Xóa',
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            // center content on wide screens
            final contentWidth = constraints.maxWidth > maxWidth
                ? maxWidth
                : constraints.maxWidth;
            final isNarrow = contentWidth < 460;
            final horizontalPadding = isNarrow ? 12.0 : 20.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top card with a left colored stripe for quick visual scanning
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                task.name,
                                                style: theme
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Chip(
                                                label: Text(
                                                  _priorityText(task.priority),
                                                ),
                                                backgroundColor: _priorityColor(
                                                  task.priority,
                                                ).withOpacity(0.12),
                                                avatar: Icon(
                                                  Icons.flag,
                                                  color: _priorityColor(
                                                    task.priority,
                                                  ),
                                                  size: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            spacing: 8,
                                            runSpacing: 4,
                                            children: [
                                              if (task.startDate != null)
                                                Chip(
                                                  label: Text(
                                                    'Bắt đầu: ${_formatDate(task.startDate)}',
                                                  ),
                                                  avatar: const Icon(
                                                    Icons.calendar_today,
                                                    size: 18,
                                                  ),
                                                ),
                                              if (task.endDate != null)
                                                Chip(
                                                  label: Text(
                                                    'Kết thúc: ${_formatDate(task.endDate)}',
                                                  ),
                                                  avatar: const Icon(
                                                    Icons.calendar_month,
                                                    size: 18,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 6,
                            ),
                            title: const Text('Hoàn thành'),
                            subtitle: const Text(
                              'Đánh dấu nhiệm vụ đã hoàn tất',
                            ),
                            value: task.done,
                            onChanged: (v) async {
                              await context
                                  .read<TaskCubit>()
                                  .updateExistingTask(task.copyWith(done: v));
                              if (Navigator.of(context).canPop())
                                Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Mô tả',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            task.description.isEmpty
                                ? 'Không có mô tả'
                                : task.description,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Actions: on narrow screens show stacked buttons, on wide show inline
                      isNarrow
                          ? Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () async {
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              TaskEditPage(task: task),
                                        ),
                                      );
                                      if (Navigator.of(context).canPop())
                                        Navigator.of(context).pop();
                                    },
                                    icon: const Icon(Icons.edit),
                                    label: const Text('Chỉnh sửa'),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _confirmDelete(context),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Xóa',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () async {
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              TaskEditPage(task: task),
                                        ),
                                      );
                                      if (Navigator.of(context).canPop())
                                        Navigator.of(context).pop();
                                    },
                                    icon: const Icon(Icons.edit),
                                    label: const Text('Chỉnh sửa'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _confirmDelete(context),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Xóa',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper: determine if white foreground works on given background
  bool useWhiteForeground(Color backgroundColor, {double bias = 0.0}) {
    final v =
        (backgroundColor.red * 299 +
            backgroundColor.green * 587 +
            backgroundColor.blue * 114) /
        1000;
    return v < 128 + bias;
  }
}
