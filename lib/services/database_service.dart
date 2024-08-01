import 'package:crud_sqlite/models/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseService {
  static Database? _db;

  static final DataBaseService instance = DataBaseService._constructor();

  final String _tasksTableName = "tasks";
  final String _tasksIdColumnName = "id";
  final String _tasksContentColumnName = "content";
  final String _tasksStatusColumnName = "status";

  DataBaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDataBase();
    return _db!;
  }

  Future<Database> getDataBase() async {
    final dataBaseDirPath = await getDatabasesPath();
    final dataBasePath = join(dataBaseDirPath, "master_db.db");

    final dataBase = await openDatabase(
      version: 1,
      dataBasePath,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_tasksTableName (
          $_tasksIdColumnName INTEGER PRIMARY KEY,
          $_tasksContentColumnName TEXT NOT NULL,
          $_tasksStatusColumnName INTEGER NOT NULL
        )
        ''');
      },
    );

    return dataBase;
  }

  void addTask(String task) async {
    final db = await database;
    await db.insert(_tasksTableName, {
      _tasksContentColumnName: task,
      _tasksStatusColumnName: 0,
    });
  }

  Future<List<TaskModel>> getTask() async {
    final db = await database;
    final data = await db.query(_tasksTableName);
    List<TaskModel> tasks = data
        .map(
          (e) => TaskModel(
              status: e['status'] as int,
              id: e['id'] as int,
              content: e['content'] as String),
        )
        .toList();

    return tasks;
  }

  void updateTaskStatus(int id, int status) async {
    final db = await database;
    await db.update(
        _tasksTableName,
        {
          _tasksStatusColumnName: status,
        },
        where: 'id = ?',
        whereArgs: [id]);
  }

  void deleteTask(int id) async {
    final db = await database;
    await db.delete(_tasksTableName, where: 'id = ?', whereArgs: [id]);
  }
}
