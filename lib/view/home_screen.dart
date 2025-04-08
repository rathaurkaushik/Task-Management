import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/helper/widget/buildFilterButton.dart';
import 'package:task_management/helper/widget/constants/app_color.dart';
import 'package:task_management/view/to_do_create_screen.dart';
import 'package:task_management/viewmodel/task_view_model.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskViewModelProvider);
    final taskViewModel = ref.read(taskViewModelProvider.notifier);
    final selectedFilter = ref.watch(selectedFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: Column(
          children: [
            // Search Bar
            TextField(
              onChanged: (query) {
                taskViewModel.searchTasks(query);
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_outlined),
                hintText: 'Search tasks...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
            SizedBox(height: 5),
// Filter Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['All', 'Low', 'Normal', 'High'].map((priority) {
                return buildFilterButton(ref, priority, selectedFilter);
              }).toList(),
            ),
            SizedBox(height: 5),

            // Task List
            tasks.isEmpty
                ? Center(
                    child: Text(
                      'No tasks available',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16.0),
                            title: Text(
                              task.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(task.description ?? 'No description',
                                    style: TextStyle(color: Colors.grey)),
                                Text('Priority: ${task.priority}',
                                    style: TextStyle(
                                        color:
                                            getPriorityColor(task.priority))),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TaskDetailScreen(task: task),
                                ),
                              );
                            },
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                ref
                                    .read(taskViewModelProvider.notifier)
                                    .deleteTask(task.id!);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskDetailScreen()),
          );
        },
        child: Icon(Icons.add, size: 30),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

}

// Riverpod Provider to manage selected filter state
final selectedFilterProvider = StateProvider<String>((ref) => 'All');
