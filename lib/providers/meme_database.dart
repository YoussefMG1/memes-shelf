import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '/models/meme_file.dart';

class MemeDatabase {
  // Singleton
  // MemeDatabase._internal();
  MemeDatabase._();
  static final MemeDatabase instance = MemeDatabase._();

  static Database? _database;

  static const String _dbName = 'memes_yousef.db';
  static const String memesTable = 'memeFile';

  /// ========= DB Getter (هنا التهيئة الصح) =========
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  /// ========= Init Database =========
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    log('Database Path: $path');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  /// ========= Create Tables =========
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $memesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT NOT NULL,
        displayName TEXT NOT NULL,
        type TEXT NOT NULL,
        isRecent INTEGER NOT NULL
      )
      ''');

    log('Database Created');
  }

  // =================================================
  // ================= CRUD METHODS ==================
  // =================================================

  /// Insert single file (rawInsert زي ما انت عايز)
  Future<int> addFile(MemeFile file) async {
    final db = await database;

    final id = await db.rawInsert(
      '''
      INSERT INTO $memesTable (path, displayName, type, isRecent)
      VALUES (?, ?, ?, ?)
      ''',
      [file.path, file.displayName, file.type, file.isRecent ? 1 : 0],
    );

    return id;
  }

  /// Insert multiple files (Batch)
  Future<void> addFiles(List<MemeFile> files) async {
    final db = await database;
    final batch = db.batch();

    for (final file in files) {
      batch.insert(
        memesTable,
        file.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  /// Get all files
  Future<List<MemeFile>> getAllFiles() async {
    final db = await database;

    final result = await db.rawQuery('SELECT * FROM $memesTable');

    return result.map((e) => MemeFile.fromMap(e)).toList();
  }

  /// Get files by type
  Future<List<MemeFile>> getFilesByType(String type) async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT * FROM $memesTable WHERE type = ?',
      [type],
    );

    return result.map((e) => MemeFile.fromMap(e)).toList();
  }

  /// Get recent files
  Future<List<MemeFile>> getRecentFiles() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT * FROM $memesTable WHERE isRecent = 1 ORDER BY id DESC',
    );

    return result.map((e) => MemeFile.fromMap(e)).toList();
  }

  /// Update
  Future<int> updateFile(MemeFile media) async {
    final db = await database;
    return await db.update(
      memesTable,
      media.toMap(),
      where: 'id = ?',
      whereArgs: [media.id],
    );
  }

  /// Delete by id
  Future<int> deleteFile(int id) async {
    final db = await database;

    return await db.rawDelete('DELETE FROM $memesTable WHERE id = ?', [id]);
  }

  /// Clear table
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete(memesTable);
  }

  /// Close DB
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// search by name
  Future<List<MemeFile>> searchFiles(String query) async {
    final db = await database;

    if (query.trim().isEmpty) {
      return await getAllFiles();
    }

    final result = await db.rawQuery(
      '''
    SELECT * FROM $memesTable
    WHERE displayName LIKE ? COLLATE NOCASE
    ORDER BY id DESC
    ''',
      ['%${query.trim()}%'],
    );

    return result.map((e) => MemeFile.fromMap(e)).toList();
  }
}
