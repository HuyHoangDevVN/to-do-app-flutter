import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onChecked;
  const TaskItem({super.key, required this.task, this.onTap, this.onChecked});

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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Row(
          children: [
            // priority stripe
            Container(
              width: 6,
              height: 72,
              decoration: BoxDecoration(
                color: _priorityColor(task.priority),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // avatar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Color(task.color),
                child: Text(
                  task.name.isNotEmpty ? task.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      task.description.isEmpty
                          ? 'Không có mô tả'
                          : task.description,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // actions
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      task.done
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task.done ? Colors.green : Colors.grey,
                    ),
                    onPressed: () => onChecked?.call(!task.done),
                    tooltip: task.done
                        ? 'Đánh dấu chưa hoàn thành'
                        : 'Đánh dấu hoàn thành',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
