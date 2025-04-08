import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_management/models/task_models.dart';
import 'package:task_management/viewmodel/task_view_model.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final Task? task;

  TaskDetailScreen({Key? key, this.task}) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  String priority = 'Normal';
  DateTime? selectedDueDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task?.title ?? '');
    descriptionController = TextEditingController(text: widget.task?.description ?? '');
    priority = widget.task?.priority ?? 'Normal';

    if (widget.task?.dueDate != null) {
      selectedDueDate = widget.task!.dueDate!;
      selectedTime = TimeOfDay.fromDateTime(selectedDueDate!);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() => selectedDueDate = pickedDate);
    }
  }

  void _pickDueTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() => selectedTime = pickedTime);
    }
  }

  void _saveTask() {
    if (selectedDueDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a due date and time")),
      );
      return;
    }

    final dueDateTime = DateTime(
      selectedDueDate!.year,
      selectedDueDate!.month,
      selectedDueDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final newTask = Task(
      id: widget.task?.id,
      title: titleController.text,
      description: descriptionController.text,
      priority: priority,
      status: widget.task?.status ?? 'Pending',
      dueDate: dueDateTime,
    );

    if (widget.task == null) {
      ref.read(taskViewModelProvider.notifier).addTask(newTask);
    } else {
      ref.read(taskViewModelProvider.notifier).updateTask(newTask);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? "New Task" : "Edit Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
            ElevatedButton(onPressed: _saveTask, child: Text(widget.task == null ? "Add Task" : "Save Changes")),
          ],
        ),
      ),
    );
  }
}
