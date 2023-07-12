class Book {
  final int id;
  final String bookTitle;
  final String bookYear;

  Book({required this.id, required this.bookTitle, required this.bookYear});

  Book.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        bookTitle = data['title'],
        bookYear = data['year'];

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': bookTitle, 'year': bookYear};
  }
}
