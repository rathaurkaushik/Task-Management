import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/models/task_models.dart';
import 'package:task_management/repo/task_repo.dart';

class TaskViewModel extends StateNotifier<List<Task>> {
  final TaskRepository _repository;
  List<Task> _allTasks = []; // Store all tasks separately for search functionality
  String _searchQuery = ''; // Store search query
  String? _selectedPriority; // For storing selected priority for filtering

  TaskViewModel(this._repository) : super([]) {
    _loadTasks();
  }

  // Load tasks from the repository and apply any filters
  Future<void> _loadTasks() async {
    _allTasks = await _repository.getTasks();
    _applyFilters(); // Apply filters (search, priority) when loading tasks
  }

  // Add a new task
  Future<void> addTask(Task task) async {
    await _repository.addTask(task);
    _loadTasks(); // Reload tasks after adding
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    await _repository.updateTask(task);
    _loadTasks(); // Reload tasks after update
  }

  // Delete a task
  Future<void> deleteTask(int taskId) async {
    await _repository.deleteTask(taskId);
    _loadTasks(); // Reload tasks after deletion
  }

  // Function to filter tasks by priority
  void filterTasksByPriority(String? priority) {
    _selectedPriority = priority;
    _applyFilters(); // Reapply filters when priority is changed
  }

  // Function to search tasks by title
  void searchTasks(String query) {
    _searchQuery = query;
    _applyFilters(); // Reapply filters when search query is updated
  }

  // Apply search and filter logic
  void _applyFilters() {
    List<Task> filteredTasks = List.from(_allTasks); // Start with all tasks

    // Apply priority filter (if applicable)
    if (_selectedPriority != null && _selectedPriority != 'All') {
      filteredTasks = filteredTasks
          .where((task) => task.priority.toLowerCase() == _selectedPriority!.toLowerCase())
          .toList();
    }

    // Apply search filter (if there's a search query)
    if (_searchQuery.isNotEmpty) {
      filteredTasks = filteredTasks
          .where((task) => task.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    state = filteredTasks; // Update the state with filtered tasks
  }
}

// Riverpod provider for TaskViewModel
final taskViewModelProvider = StateNotifierProvider<TaskViewModel, List<Task>>((ref) {
  return TaskViewModel(TaskRepository());
});

