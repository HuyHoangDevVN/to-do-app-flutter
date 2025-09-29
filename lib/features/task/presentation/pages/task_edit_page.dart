import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../bloc/task_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';

class TaskEditPage extends StatefulWidget {
  final Task? task;
  const TaskEditPage({super.key, this.task});

  @override
  State<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String description;
  late int priority;
  late int color;
  late DateTime? startDate;
  late DateTime? endDate;

  @override
  void initState() {
    super.initState();
    name = widget.task?.name ?? '';
    description = widget.task?.description ?? '';
    priority = widget.task?.priority ?? 0;
    color = widget.task?.color ?? Colors.blue.value;
    startDate = widget.task?.startDate;
    endDate = widget.task?.endDate;
  }

  Future<void> _openColorPicker() async {
    Color pickerColor = Color(color);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chọn màu'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: pickerColor,
              availableColors: [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.teal,
                Colors.blue,
                Colors.indigo,
                Colors.purple,
                Colors.pink,
                Colors.brown,
                Colors.grey,
                Colors.black,
              ],
              onColorChanged: (c) => pickerColor = c,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => color = pickerColor.value);
                Navigator.of(context).pop();
              },
              child: const Text('Chọn'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime? d) {
    if (d == null) return 'Chưa chọn';
    final local = d.toLocal();
    return '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickStartDate() async {
    final initial = startDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
        // ensure endDate is not before startDate
        if (endDate != null && endDate!.isBefore(startDate!)) {
          endDate = startDate;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final initial = endDate ?? (startDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      if (startDate != null && picked.isBefore(startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ngày kết thúc phải sau hoặc bằng ngày bắt đầu'),
          ),
        );
        return;
      }
      setState(() {
        endDate = picked;
      });
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    final newTask = Task(
      id: widget.task?.id,
      name: name.trim(),
      description: description.trim(),
      startDate: startDate,
      endDate: endDate,
      priority: priority,
      color: color,
    );
    if (widget.task == null) {
      await context.read<TaskCubit>().addNewTask(newTask);
    } else {
      await context.read<TaskCubit>().updateExistingTask(newTask);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? 'Tạo nhiệm vụ' : 'Chỉnh sửa nhiệm vụ',
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Name
                        TextFormField(
                          initialValue: name,
                          decoration: InputDecoration(
                            labelText: 'Tên nhiệm vụ',
                            prefixIcon: const Icon(Icons.task),
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (v) => name = v,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Vui lòng nhập tên nhiệm vụ'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        // Description
                        TextFormField(
                          initialValue: description,
                          decoration: InputDecoration(
                            labelText: 'Mô tả',
                            prefixIcon: const Icon(Icons.notes),
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (v) => description = v,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 12),
                        // Priority
                        InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Mức ưu tiên',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: priority,
                              items: const [
                                DropdownMenuItem(value: 0, child: Text('Thấp')),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text('Trung bình'),
                                ),
                                DropdownMenuItem(value: 2, child: Text('Cao')),
                              ],
                              onChanged: (v) =>
                                  setState(() => priority = v ?? 0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Dates area
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.calendar_today),
                                title: const Text('Bắt đầu'),
                                subtitle: Text(_formatDate(startDate)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_calendar),
                                      onPressed: _pickStartDate,
                                    ),
                                    if (startDate != null)
                                      IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () =>
                                            setState(() => startDate = null),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.calendar_month),
                                title: const Text('Kết thúc'),
                                subtitle: Text(_formatDate(endDate)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_calendar),
                                      onPressed: _pickEndDate,
                                    ),
                                    if (endDate != null)
                                      IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () =>
                                            setState(() => endDate = null),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        // Color
                        Row(
                          children: [
                            const Icon(Icons.color_lens),
                            const SizedBox(width: 12),
                            const Text('Màu nhiệm vụ'),
                            const Spacer(),
                            GestureDetector(
                              onTap: _openColorPicker,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Color(color),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: _openColorPicker,
                              child: const Text('Thay đổi'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Hủy'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(widget.task == null ? 'Lưu' : 'Cập nhật'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
