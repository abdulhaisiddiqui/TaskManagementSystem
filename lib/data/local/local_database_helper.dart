import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/task_model.dart';
import '../models/user_model.dart';

class LocalDatabaseHelper {
  static final LocalDatabaseHelper _instance = LocalDatabaseHelper._internal();
  factory LocalDatabaseHelper() => _instance;
  LocalDatabaseHelper._internal();

  static const String _dbName = 'task_app_local.db';
  static const int _dbVersion = 1;

  static const String usersTable = 'users';
  static const String tasksTable = 'tasks';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
			CREATE TABLE $usersTable (
				uid TEXT PRIMARY KEY,
				email TEXT,
				displayName TEXT,
				photoURL TEXT,
				createdAt INTEGER
			)
		''');

    await db.execute('''
			CREATE TABLE $tasksTable (
				id TEXT PRIMARY KEY,
				userId TEXT,
				title TEXT,
				description TEXT,
				startTime INTEGER,
				endTime INTEGER,
				priority TEXT,
				category TEXT,
				status TEXT
			)
		''');
  }

  Future<void> saveUserOffline({
    required String uid,
    required String email,
    String? displayName,
    String? photoURL,
    required DateTime createdAt,
  }) async {
    final db = await database;
    await db.insert(
      usersTable,
      {
        'uid': uid,
        'email': email,
        'displayName': displayName ?? '',
        'photoURL': photoURL ?? '',
        'createdAt': createdAt.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getSavedUser() async {
    final db = await database;
    final list = await db.query(usersTable, limit: 1);
    if (list.isEmpty) return null;
    final row = list.first;
    return {
      'uid': row['uid'],
      'email': row['email'],
      'displayName': row['displayName'],
      'photoURL': row['photoURL'],
      'createdAt': DateTime.fromMillisecondsSinceEpoch(row['createdAt'] as int),
    };
  }

  Future<void> clearSavedUser() async {
    final db = await database;
    await db.delete(usersTable);
  }

  Future<void> insertTaskForUser(TaskModel t, {required String userId}) async {
    final db = await database;
    await db.insert(
      tasksTable,
      {
        'id': t.id ?? '${DateTime.now().millisecondsSinceEpoch}',
        'userId': userId,
        'title': t.title,
        'description': t.description ?? '',
        'startTime': t.startTime.millisecondsSinceEpoch,
        'endTime': t.endTime.millisecondsSinceEpoch,
        'priority': t.priority,
        'category': t.category,
        'status': t.status,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TaskModel>> getAllTasksForUser(String uid) async {
    final db = await database;
    final rows = await db.query(tasksTable, where: 'userId = ?', whereArgs: [uid]);
    return rows.map((r) {
      return TaskModel(
        id: r['id'] as String?,
        userId: r['userId'] as String,
        title: r['title'] as String,
        description: (r['description'] as String).isEmpty ? null : r['description'] as String,
        startTime: DateTime.fromMillisecondsSinceEpoch(r['startTime'] as int),
        endTime: DateTime.fromMillisecondsSinceEpoch(r['endTime'] as int),
        priority: r['priority'] as String,
        category: r['category'] as String,
        status: r['status'] as String,
      );
    }).toList();
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete(tasksTable);
    await db.delete(usersTable);
  }
}

