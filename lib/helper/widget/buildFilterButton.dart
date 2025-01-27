import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/helper/widget/selectedFilterProvider.dart';
import 'package:task_management/viewmodel/task_view_model.dart';

Widget buildFilterButton(WidgetRef ref, String label, String selectedFilter) {
  bool isSelected = selectedFilter == label;
  return ElevatedButton(
    onPressed: () {
      ref.read(selectedFilterProvider.notifier).state = label;
      ref.read(taskViewModelProvider.notifier).filterTasksByPriority(label);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: isSelected ? Colors.blueAccent : Colors.grey[300],
      foregroundColor: isSelected ? Colors.white : Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    child: Text(label, style: TextStyle(fontSize: 12)),
  );
}