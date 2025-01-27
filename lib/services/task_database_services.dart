import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_management/models/task_models.dart';

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._init();
  static Database? _database;

  TaskDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      onDowngrade: _onDowngrade,
    );
  }

  // Create database and table
  Future _createDB(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        due_date TEXT,
        priority TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');
  }

  // Handle database schema upgrades
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // If you need to upgrade your schema, you can handle it here.
      await db.execute("ALTER TABLE tasks ADD COLUMN due_date TEXT;");
      await db.execute("ALTER TABLE tasks ADD COLUMN description TEXT;");
    }
  }

  // Handle downgrades (optional)
  Future _onDowngrade(Database db, int oldVersion, int newVersion) async {
    print("Database downgrade from $oldVersion to $newVersion");
  }

  // Fetch tasks from the database
  Future<List<Task>> fetchTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    print("Fetched tasks: $result"); // Debugging: check fetched tasks
    return result.map((map) => Task.fromMap(map)).toList();
  }

  // Insert a new task into the database
  Future<int> insertTask(Task task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  // Update an existing task in the database
  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return await db.update('tasks', task.toMap(),
        where: 'id = ?', whereArgs: [task.id]);
  }

  // Delete a task from the database
  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // Close the database (optional)
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
