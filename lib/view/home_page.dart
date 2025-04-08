import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/controller/theme_controller.dart';
import 'package:task_management/models/task_models.dart';
import 'package:task_management/view/add_task_page.dart';
import 'package:task_management/view/edit_task_page.dart';



class HomePage extends StatelessWidget {
  final taskController = Get.put(TaskController());
  final themeController = Get.find<ThemeController>();

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("To-Do Tasks", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: Icon(Icons.light_mode,color: Colors.white,),
            onPressed: () => themeController.toggleTheme(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Get.to(() => AddTaskPage()),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['All', 'Pending', 'Completed']
                  .map((status) => Obx(() => ChoiceChip(
                label: Text(status),
                selected: taskController.filter.value == status,
                onSelected: (_) => taskController.filter.value = status,
              )))
                  .toList(),
            ),
          ),
          
          /// task card widgets 
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: taskController.filteredTasks.length,
              itemBuilder: (context, index) {
                final task = taskController.filteredTasks[index];
                return GestureDetector(
                  onTap: () => Get.to(EditTaskPage(task: task, index: index)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Task Info Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    task.description,
                                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Due: ${DateFormat.yMMMd().add_jm().format(task.dueDate)}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                  ),
                                  Text(
                                    'Priority: ${
                                    task.priority}',
                                    style: TextStyle(
                                      color: getPriorityColor(task.priority),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Priority + Delete Icon
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: "Delete Task",
                                      middleText: "Are you sure you want to delete this task?",
                                      textCancel: "Cancel",
                                      textConfirm: "Delete",
                                      confirmTextColor: Colors.white,
                                      onConfirm: () {
                                        taskController.deleteTask(task.id!);
                                        Get.back();
                                        Get.snackbar(
                                          "Deleted",
                                          "Task deleted successfully",
                                          backgroundColor: Colors.redAccent,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      },
                                    );
                                  },
                                ),
                            
                            
                                Switch(
                                  value: task.status == 'Completed',
                                  onChanged: (value) {
                                    final updatedTask = Task(
                                      id: task.id,
                                      title: task.title,
                                      description: task.description,
                                      dueDate: task.dueDate,
                                      status: value ? 'Completed' : 'Pending',
                                      priority: task.priority,
                                    );
                                    taskController.updateTask(index, updatedTask);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )),
          )
        ],
      ),
    );
  }
}
