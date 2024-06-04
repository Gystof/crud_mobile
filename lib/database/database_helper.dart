import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/request.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('requests.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const dateType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE requests ( 
  id $idType, 
  title $textType,
  fullName $textType,
  position $textType,
  employeeNumber $textType,
  department $textType,
  startDate $dateType,
  endDate $dateType
  )
''');
  }

  Future<void> createRequest(Request request) async {
    final db = await instance.database;
    await db.insert('requests', request.toMap());
  }

  Future<List<Request>> readAllRequests() async {
    final db = await instance.database;

    final result = await db.query('requests');

    return result.map((json) => Request.fromMap(json)).toList();
  }

  Future<void> updateRequest(Request request) async {
    final db = await instance.database;

    await db.update(
      'requests',
      request.toMap(),
      where: 'id = ?',
      whereArgs: [request.id],
    );
  }

  Future<void> deleteRequest(String id) async {
    final db = await instance.database;

    await db.delete(
      'requests',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}