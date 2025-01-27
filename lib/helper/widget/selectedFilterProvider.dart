import 'package:flutter_riverpod/flutter_riverpod.dart';

// This provider manages the selected filter state
final selectedFilterProvider = StateProvider<String>((ref) {
  return 'All'; // Default filter is "All Tasks"
});
