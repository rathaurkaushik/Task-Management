import 'package:get/get.dart';
import 'package:task_management/models/task_models.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;

  // ✅ Add this line:
  var filter = 'All'.obs;

  List<Task> get filteredTasks {
    if (filter.value == 'Pending') {
      return tasks.where((task) => task.status == 'Pending').toList();
    } else if (filter.value == 'Completed') {
      return tasks.where((task) => task.status == 'Completed').toList();
    } else {
      return tasks;
    }
  }

  void addTask(Task task) {
    tasks.add(task);
  }

  void deleteTask(int id) {
    tasks.removeWhere((t) => t.id == id);
  }

  void updateTask(int index, Task updatedTask) {
    tasks[index] = updatedTask;
  }
}
