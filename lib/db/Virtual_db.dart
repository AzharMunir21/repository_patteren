import 'dart:math';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class VirtualDB {
  List<Map<String, dynamic>> _items = [];
  static final VirtualDB _db = VirtualDB._privateConstructor();

  VirtualDB._privateConstructor();

  factory VirtualDB() {
    return _db;
  }

  static const dbName = "myDatabase.db";
  static const tableName = "tableName";
  static const id = "id";
  static const bookTitle = "bookTitle";
  static const bookYear = "bookYear";
  // static const bookId = "bookId";
  static const version = 1;
  Database? _database;

  static final VirtualDB instance = VirtualDB();
  Future<Database?> get database async {
    _database ??= await initDb();
    return _database;
  }

  initDb() async {
    final directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return openDatabase(path, version: version, onCreate: onCreate);
  }

  onCreate(Database db, int version) async {
    await db.execute('''create table $tableName 
    ($id integer primary key autoincrement,  
    $bookTitle Text,
    $bookYear Text)
    ''');
  }
  // onCreate(Database db, int version) async {
  //   await db.execute('''create table $tableName
  //   ($id integer primary,
  //   $bookTitle Text Not Null,
  //   $bookYear Text Not Null)''');
  // }

  insert(Map<String, dynamic> item) async {
    Database? db = await database;
    return db?.insert(tableName, item);
    // _items.add(item);
  }

  delRecord(int ids) async {
    Database? db = await database;
    return db!.delete(tableName, where: "$id= ?", whereArgs: [ids]);
  }

  update(Map<String, dynamic> updatedItem) async {
    Database? db = await database;
    int ids = updatedItem[id];
    return db!
        .update(tableName, updatedItem, where: "$id : ?", whereArgs: [ids]);
  }

  readRecord() async {
    Database? db = await database;
    return db!.query(tableName);
  }

  Future<List<Map<String, dynamic>>> list() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _items;
  }

  Future<Map<String, dynamic>?> findOne(int id) async {
    return _items.firstWhere((item) => item['id'] == id);
  }
}
