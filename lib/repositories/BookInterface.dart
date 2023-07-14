import '../models/booksModel.dart';

abstract class IBookRepository {
  getAll();
  Future<Book?> getOne(int id);
  Future<void> insert(Book book);
  update(Map<String, dynamic> book);
  Future<void> delete(int id);
}
