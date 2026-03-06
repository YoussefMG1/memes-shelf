// ignore_for_file: unused_element

import 'dart:developer';
import 'package:memetic_whats/models/meme_file.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseStoring {
  // i didn't think about the recent files yet
  // should i make it (bool recent) ?
  // and i think that adding an ID would be usefull

  // revision: Enums, Sets, Maps
  // learn: how to update , delete rows

  List<String> fileTypes = [
    "image",
    "audio",
    "sticker",
  ]; //i want to make it Enum
  String dbName = "memes_yousef";
  String memesTable = "memeFile";

  DatabaseStoring() {
    initiateDB();
  }

  initiateDB() async {
    await openDatabase(
      dbName,
      onCreate: (Database db, int version) async {
        // check the bool type in sql
        await db.execute("""CREATE TABLE $memesTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          path TEXT, displayName TEXT, 
          type TEXT, isRecent INTEGER)""");
      },
    );
  }

  void addFile(MemeFile file) async {
    Database database = await openDatabase(dbName);

    await database.transaction((action) async {
      int id1 = await action.rawInsert(
        '''INSERT INTO $memesTable (path, displayName, type, isRecent)
        VALUES (?, ?, ?, ?)
        ''',
        [file.path, file.displayName, file.type, file.isRecent ? 1 : 0],
      );
      log('inserted1: $id1');
      // file.id = id1;
    });
  }

  void addFiles(List<MemeFile> files) async {
    Database database = await openDatabase(dbName);
    Batch batch = database.batch();
    for (var f in files) {
      batch.insert(
        memesTable,
        f.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // batch.insert(memesTable, {
      //   "path": f.path,
      //   "displayName": f.displayName,
      //   "type": f.type,
      //   "isRecent": f.isRecent,
      // });
    }
    await batch.commit();
  }

  /// Get All
  Future<List<MemeFile>> getAllFiles() async {
    Database database = await openDatabase(dbName);
    var result = await database.rawQuery('SELECT * FROM $memesTable');
    log(result.toString());
    return result.map((e) => MemeFile.fromMap(e)).toList();
  }

  /// Get By Type (images, videos, audio, stickers...)
  Future<List<MemeFile>> getMediaByType(String type) async {
    Database database = await openDatabase(dbName);
    final result = await database.query(
      memesTable,
      where: 'type = ?',
      whereArgs: [type],
    );

    return result.map((e) => MemeFile.fromMap(e)).toList();
  }

  /// Get Recent
  Future<List<MemeFile>> getRecentMedia() async {
    Database database = await openDatabase(dbName);
    final result = await database.query(
      memesTable,
      where: 'isRecent = ?',
      whereArgs: [1],
    );

    return result.map((e) => MemeFile.fromMap(e)).toList();
  }

  /// Update
  Future<int> updateMedia(MemeFile media) async {
    Database database = await openDatabase(dbName);
    return await database.update(
      memesTable,
      media.toMap(),
      where: 'id = ?',
      whereArgs: [media.id],
    );
  }

  /// Delete by id
  Future<int> deleteMedia(int id) async {
    Database database = await openDatabase(dbName);
    return await database.delete(memesTable, where: 'id = ?', whereArgs: [id]);
  }

  /// Delete all
  Future<void> clearDatabase() async {
    Database database = await openDatabase(dbName);
    await database.delete(memesTable);
  }

  /// Close DB
  Future<void> close() async {
    Database database = await openDatabase(dbName);
    await database.close();
  }

  _getImages() async {
    // i think i don't need this function anymore as i should get all files and devide them by type myself (easy and faster)
    Database database = await openDatabase(dbName);
    //var result = await database.rawQuery('SELECT * FROM $memesTable WHERE type = "image"');
    var result = await database.query(
      memesTable,
      where: 'type = ?',
      whereArgs: ["image"],
    );
    log(result.toString());
  }

  _openDb() async {
    Database database = await openDatabase(
      'my_db.db',
      version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)',
        );
        await db.execute(
          'CREATE TABLE Product (id INTEGER PRIMARY KEY, name TEXT, price REAL, inStock INTEGER)',
        );
      },
    );

    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
        'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)',
      );
      log('inserted1: $id1');
      int id2 = await txn.rawInsert(
        'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
        ['another name', 12345678, 3.1416],
      );
      log('inserted2: $id2');
    });
    var batch = database.batch();
    batch.insert('Test', {'name': 'batch name 1', 'value': 111, 'num': 1.1});
    batch.insert('Test', {'name': 'batch name 2', 'value': 222, 'num': 2.2});
    batch.insert('Test', {'name': 'batch name 3', 'value': 333, 'num': 3.3});
    await batch.commit();

    batch.insert('Product', {'name': 'Product 1', 'price': 9.99, 'inStock': 1});
    batch.insert('Product', {
      'name': 'Product 2',
      'price': 19.99,
      'inStock': 0,
    });
    batch.insert('Product', {
      'name': 'Product 3',
      'price': 29.99,
      'inStock': 1,
    });
    await batch.commit();

    var result = await database.rawQuery('SELECT * FROM Test');
    var resultProduct = await database.rawQuery('SELECT * FROM Product');
    log(result.toString());
    log(resultProduct.toString());
  }

  _getData() async {
    Database database = await openDatabase('my_db.db');
    //var result = await database.rawQuery('SELECT * FROM Test WHERE id = 1');
    var result = await database.query('Test', where: 'id = ?', whereArgs: [1]);

    log(result.toString());
  }
}
