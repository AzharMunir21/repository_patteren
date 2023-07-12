import 'dart:convert';

import '../db/Virtual_db.dart';
import '../models/booksModel.dart';
import '../repositories/BookRepository.dart';

class HomeController {
  final BookRepository _bookRepo = BookRepository(VirtualDB());

  Future<List<Book>> getAllBooks() {
    return _bookRepo.getAll();
  }

  Future<void> addBook(Book book) {
    return _bookRepo.insert(book);
  }

  Future<void> removeBook(int id) {
    return _bookRepo.delete(id);
  }
}
