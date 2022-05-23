import 'package:books/models/book_model.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

const String booksT = 'books';

abstract class UseCase<type> {
  Future<void> call(type tName);
}

@Singleton()
class DBHelper implements UseCase<String> {
  late final sql.Database? db;

  @override
  Future<void> call(String tName) async {
    final dbPath = await sql.getDatabasesPath();
    db = await sql.openDatabase(path.join(dbPath, 'books.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $tName(id INTEGER primary key autoincrement, name TEXT, author TEXT, date TEXT, category TEXT, status INTEGER, numberOfReads INTEGER, rate REAL)');
    }, version: 1);
  }

  Future<int> insert(String table, Book book) async {
    return db!.insert(table, book.toMap());
  }

  Future deleteDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.deleteDatabase(path.join(dbPath, 'books.db'));
  }

  Future<List<Map<String, dynamic>>> getData(String table) async {
    return db!.query(table);
  }

  Future<int> update(String table, Book book) async {
    return await db!
        .update(table, book.toMap(), where: 'id = ?', whereArgs: [book.id]);
  }

  Future<int> delete(String table, int id) async {
    return await db!.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
