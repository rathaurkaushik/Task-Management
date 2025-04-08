import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/models/task_models.dart';
import 'package:task_management/controller/task_controller.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;
  final int index;

  EditTaskPage({required this.task, required this.index});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final taskController = Get.find<TaskController>();
  late TextEditingController titleController;
  late TextEditingController descController;
  late DateTime selectedDateTime;
  late String selectedPriority;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descController = TextEditingController(text: widget.task.description);
    selectedDateTime = widget.task.dueDate;
    selectedPriority = widget.task.priority;
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _updateTask() {
    final updatedTask = Task(
      id: widget.task.id,
      title: titleController.text,
      description: descController.text,
      dueDate: selectedDateTime,
      status: widget.task.status,
      priority: selectedPriority,
    );

    taskController.updateTask(widget.index, updatedTask);
    Get.back();
    Get.snackbar("Updated", "Task updated successfully",
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Task")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedPriority,
              decoration: InputDecoration(labelText: "Priority", border: OutlineInputBorder()),
              items: ['Low', 'Medium', 'High'].map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedPriority = value;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Due: ${DateFormat.yMMMd().add_jm().format(selectedDateTime)}",
                  ),
                ),
                TextButton(
                  onPressed: _pickDateTime,
                  child: Text("Pick Date & Time"),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _updateTask,
              child: Text("Update Task"),
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
            ),
          ],
        ),
      ),
    );
  }
}
