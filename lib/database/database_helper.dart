import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/student_model.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      'students.db',
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE students (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            course TEXT NOT NULL,
            email TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // CREATE
  Future<int> insertStudent(StudentModel student) async {
    final db = await database;

    return await db.insert(
      'students',
      student.toMap(),
    );
  }

  // READ
  Future<List<StudentModel>> getStudents() async {
    final db = await database;

    final result = await db.query(
      'students',
      orderBy: 'id DESC',
    );

    return result
        .map((map) => StudentModel.fromMap(map))
        .toList();
  }

  // UPDATE
  Future<int> updateStudent(StudentModel student) async {
    final db = await database;

    return await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  // DELETE
  Future<int> deleteStudent(int id) async {
    final db = await database;

    return await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}