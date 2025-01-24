import 'package:flutter/material.dart';

Widget buildFilterButton(/*WidgetRef ref,*/ String label, String selectedFilter) {
  bool isSelected = selectedFilter == label;

  return SizedBox(
    width: 100,
    child: ElevatedButton(
      onPressed: () => {},/*ref.read(selectedFilterProvider.notifier).state = label,*/
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Color(0xff4567b7) : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      child: Text(label,style: TextStyle(fontSize: 12),),
    ),
  );
}
