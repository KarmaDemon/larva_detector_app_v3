import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('larva_data.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE larva_analysis (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        stage_1 INTEGER,
        stage_2 INTEGER,
        stage_3 INTEGER,
        stage_4 INTEGER,
        stage_5 INTEGER,
        stage_6 INTEGER,
        total INTEGER
      )
    ''');
  }

  Future<int> insertAnalysis(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('larva_analysis', data);
  }

  Future<List<Map<String, dynamic>>> fetchAllAnalysis() async {
    final db = await instance.database;
    return await db.query('larva_analysis', orderBy: 'timestamp DESC');
  }
}