import '../db/Virtual_db.dart';
import '../models/booksModel.dart';
import 'BookInterface.dart';

class BookRepository implements IBookRepository {
  final VirtualDB _db;

  BookRepository(this._db);

  @override
  getAll() async {
    // var items = await _db.list();
    return _db.readRecord();
    // items.map((item) => Book.fromMap(item)).toList();
  }

  @override
  Future<Book?> getOne(int id) async {
    var item = await _db.findOne(id);
    return item != null ? Book.fromMap(item) : null;
  }

  @override
  Future<void> insert(Book book) async {
    print(book.toMap());
    await _db.insert(book.toMap());
  }

  @override
  update(Map<String, dynamic> item) async {
    await _db.update(item);
  }

  @override
  Future<void> delete(int id) async {
    await _db.delRecord(id);
  }
}
