import 'package:task_management/models/task_models.dart';
import 'package:task_management/services/task_database_services.dart';
 // Import database service

class TaskRepository {
  final TaskDatabase _db = TaskDatabase.instance;

  Future<List<Task>> getTasks() async {
    return await _db.fetchTasks();
  }

  Future<void> addTask(Task task) async {
    await _db.insertTask(task);
  }

  Future<void> updateTask(Task task) async {
    await _db.updateTask(task);
  }

  Future<void> deleteTask(int id) async {
    await _db.deleteTask(id);
    // _loadTasks();
  }
}
