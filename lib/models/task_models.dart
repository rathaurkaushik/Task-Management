class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime dueDate; // ✅ Change this to DateTime
  final String priority;
  final String status;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate, // ✅ Add DateTime parameter
    required this.priority,
    required this.status,
  });

  // Convert Task to Map (for storing in SQLite or Hive)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(), // ✅ Convert DateTime to String
      'priority': priority,
      'status': status,
    };
  }

  // Create Task from Map (for retrieving from SQLite or Hive)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']), // ✅ Parse String to DateTime
      priority: map['priority'],
      status: map['status'],
    );
  }
}
