import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('assets.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE locations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        address TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE assets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        serialNumber TEXT UNIQUE NOT NULL,
        barcode TEXT UNIQUE,
        purchaseDate TEXT,
        purchaseCost REAL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE asset_assignments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        assetId INTEGER NOT NULL,
        userId INTEGER NOT NULL,
        locationId INTEGER NOT NULL,
        assignedDate TEXT NOT NULL,
        returnDate TEXT,
        notes TEXT,
        FOREIGN KEY (assetId) REFERENCES assets (id),
        FOREIGN KEY (userId) REFERENCES users (id),
        FOREIGN KEY (locationId) REFERENCES locations (id)
      )
    ''');
  }

  // Helper methods for transactions
  Future<T> transaction<T>(Future<T> Function(Transaction t) action) async {
    final db = await instance.database;
    return db.transaction(action);
  }
}