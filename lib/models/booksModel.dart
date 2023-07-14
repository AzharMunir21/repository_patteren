class Book {
  final int? id;
  final String bookTitle;
  final String bookYear;

  Book({this.id, required this.bookTitle, required this.bookYear});

  Book.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        bookTitle = data['bookTitle'],
        bookYear = data['bookYear'];

  Map<String, dynamic> toMap() {
    return {'bookTitle': bookTitle, 'bookYear': bookYear};
  }
}
