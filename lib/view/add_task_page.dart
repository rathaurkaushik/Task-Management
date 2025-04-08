import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/models/task_models.dart';


class AddTaskPage extends StatefulWidget {
  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final taskController = Get.find<TaskController>();

  DateTime? selectedDateTime;
  String selectedPriority = 'Medium'; // Default

  Future<void> _selectDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
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

  String getFormattedDateTime() {
    if (selectedDateTime == null) return 'Select Due Date & Time';
    return DateFormat.yMMMMd().add_jm().format(selectedDateTime!);
  }

  void _saveTask() {
    final title = titleController.text.trim();
    final description = descController.text.trim();

    if (title.isEmpty || description.isEmpty || selectedDateTime == null) {
      Get.snackbar(
        "Missing Fields",
        "Please fill all fields and select date/time",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final newTask = Task(
      title: title,
      description: description,
      dueDate: selectedDateTime!,
      status: 'Pending',
      priority: selectedPriority,
    );

    taskController.addTask(newTask);
    Get.back();

    Get.snackbar(
      "Success",
      "Task added successfully!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            ),
            SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              maxLines: 2,
            ),
            SizedBox(height: 20),

            Text("Priority", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: selectedPriority,
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: ['Low', 'Medium', 'High'].map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedPriority = value);
                }
              },
            ),

            SizedBox(height: 20),
            Text("Due Date & Time", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Row(
              children: [
                // Date & Time Display
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.grey[200],
                    ),
                    child: Text(
                      getFormattedDateTime(),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(width: 10),

                // Pick Button with Icon
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _selectDateTime(context),
                  icon: Icon(Icons.calendar_today, size: 18,color: Colors.white,),
                  label: Text('Pick', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
                ),
              ],
            ),


            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text("Save Task"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  onPressed: _saveTask,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
