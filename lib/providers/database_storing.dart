//   import 'package:sqflite/sqflite.dart';

//   openDb() async {
//     Database database = await openDatabase('my_db.db', version: 1,
//         onCreate: (Database db, int version) async {
//       // When creating the db, create the table
//       await db.execute(
//           'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
//       await db.execute(
//           'CREATE TABLE Product (id INTEGER PRIMARY KEY, name TEXT, price REAL, inStock INTEGER)'); 
//     });

//     await database.transaction((txn) async {
//       int id1 = await txn.rawInsert(
//           'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
//       log('inserted1: $id1');
//       int id2 = await txn.rawInsert(
//           'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
//           ['another name', 12345678, 3.1416]);
//       log('inserted2: $id2');
//     });
//     var batch = database.batch();
//     batch.insert('Test', {'name': 'batch name 1', 'value': 111, 'num': 1.1});
//     batch.insert('Test', {'name': 'batch name 2', 'value': 222, 'num': 2.2});
//     batch.insert('Test', {'name': 'batch name 3', 'value': 333, 'num': 3.3});
//     await batch.commit();
//     batch.insert('Product', {'name': 'Product 1', 'price': 9.99, 'inStock': 1});
//     batch
//         .insert('Product', {'name': 'Product 2', 'price': 19.99, 'inStock': 0});
//     batch
//         .insert('Product', {'name': 'Product 3', 'price': 29.99, 'inStock': 1});
//     await batch.commit();
//     var result = await database.rawQuery('SELECT * FROM Test');
//     var resultProduct = await database.rawQuery('SELECT * FROM Product');
//     log(result.toString());
//     log(resultProduct.toString());
//   }

//   getData() async {
//     Database database = await openDatabase('my_db.db');
//     //var result = await database.rawQuery('SELECT * FROM Test WHERE id = 1');
//     var result = await database.query('Test', where: 'id = ?', whereArgs: [1]);

//     log(result.toString());
//   }
// }