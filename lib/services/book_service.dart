import 'package:flutter/services.dart' show rootBundle;

class BookService {
  static Future<String> getBookContent(String bookName) async {
    try {
      return await rootBundle.loadString('assets/texts/$bookName');
    } catch (_) {
      return 'Book not found.';
    }
  }
}
