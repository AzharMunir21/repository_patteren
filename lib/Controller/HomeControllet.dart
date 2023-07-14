import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../db/Virtual_db.dart';
import '../models/booksModel.dart';
import '../repositories/BookRepository.dart';

class HomeController extends GetxController {
  final BookRepository _bookRepo = BookRepository(VirtualDB());
  var titleFieldController = TextEditingController().obs;
  var yearFieldController = TextEditingController().obs;
  var list;
  RxInt id = 0.obs;
  RxBool updateFunEnable = false.obs;
  onInit() async {
    super.onInit();
    getAllBooks();
  }

  getAllBooks() async {
    list = await _bookRepo.getAll();
    update();
    return _bookRepo.getAll();
  }

  Future<void> addBook(Book book) {
    getWait();
    return _bookRepo.insert(book);
  }

  getWait() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      getAllBooks();
      list;
      update();
    });
  }

  Future<void> removeBook(int id) {
    return _bookRepo.delete(id).then((value) {
      Future.delayed(const Duration(milliseconds: 500));
      getAllBooks();
    });
  }

  @override
  void updateBook(
      {required String title, required String year, required int ids}) {
    titleFieldController.value = TextEditingController(text: title);
    yearFieldController.value = TextEditingController(text: year);
    id.value = ids;
    updateFunEnable.value = true;
  }

  save() {
    var book = {
      "id": id.value,
      "bookTitle": titleFieldController.value.text,
      "bookYear": yearFieldController.value.text,
    };
    print(id.value);
    print(titleFieldController.value.text);
    print(yearFieldController.value.text);
    _bookRepo.update(book);
    Future.delayed(const Duration(milliseconds: 500));
    getAllBooks();
    updateFunEnable.value = false;
  }
}
