import 'package:books/models/book_model.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

const String booksT = 'books';

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(dbPath, 'books.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $booksT(id INTEGER primary key autoincrement, name TEXT, author TEXT, date TEXT, category TEXT, status INTEGER, numberOfReads INTEGER, rate REAL)');
    }, version: 1);
  }

  static Future<void> insert(String table, Book book) async {
    final db = await DBHelper.database();
    db.insert(table, book.toMap());
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<int> update(String table, Book book) async {
    final db = await DBHelper.database();
    return await db
        .update(table, book.toMap(), where: 'id = ?', whereArgs: [book.id]);
  }

  static Future<int> delete(String table, int id) async {
    final db = await DBHelper.database();
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
