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

  @override
  void initState() {
    super.initState();
    name = widget.task?.name ?? '';
    description = widget.task?.description ?? '';
    priority = widget.task?.priority ?? 0;
    color = widget.task?.color ?? Colors.blue.value;
  }

  Future<void> _openColorPicker() async {
    Color pickerColor = Color(color);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chọn màu'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (c) => pickerColor = c,
              enableAlpha: false,
              pickerAreaHeightPercent: 0.6,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Create Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Task Name'),
                onChanged: (val) => name = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (val) => description = val,
              ),
              DropdownButtonFormField<int>(
                value: priority,
                items: [
                  DropdownMenuItem(value: 0, child: Text('Low')),
                  DropdownMenuItem(value: 1, child: Text('Medium')),
                  DropdownMenuItem(value: 2, child: Text('High')),
                ],
                onChanged: (val) => setState(() => priority = val ?? 0),
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
              Row(
                children: [
                  const Text('Task Color: '),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _openColorPicker,
                    child: CircleAvatar(
                      backgroundColor: Color(color),
                      radius: 15,
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: _openColorPicker,
                    child: const Text('Change'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newTask = Task(
                      id: widget.task?.id,
                      name: name,
                      description: description,
                      priority: priority,
                      color: color,
                    );
                    if (widget.task == null) {
                      await context.read<TaskCubit>().addNewTask(newTask);
                    } else {
                      await context.read<TaskCubit>().updateExistingTask(
                        newTask,
                      );
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.task == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
