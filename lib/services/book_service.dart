import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/services.dart' show rootBundle;

/// Splits raw text into non-empty trimmed lines — runs on a background isolate.
List<String> _parseLines(String raw) {
  return raw
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();
}

class BookService {
  /// Returns the raw text of [bookName] from assets/texts/, loaded off the
  /// main thread so large files (Strong's, encyclopedias) don't skip frames.
  static Future<String> getBookContent(String bookName) async {
    try {
      // rootBundle must be called on the main isolate, but the work is tiny.
      final raw = await rootBundle.loadString('assets/texts/$bookName');
      return raw;
    } catch (_) {
      return 'Book not found.';
    }
  }

  /// Returns the text split into paragraphs, parsed on a background isolate.
  /// Use this when displaying or searching large files to avoid jank.
  static Future<List<String>> getBookLines(String bookName) async {
    try {
      final raw = await rootBundle.loadString('assets/texts/$bookName');
      return compute(_parseLines, raw);
    } catch (_) {
      return ['Book not found.'];
    }
  }
}
