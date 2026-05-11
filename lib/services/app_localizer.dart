import 'package:translator/translator.dart';

enum AppText {
  title,
  translation,
  language,
  book,
  chapter,
  voice,
  readChapter,
  stop,
  textSize,
  readSpeed,
  noVerses,
  noVoices,
  voiceHint,
}

class AppLocalizer {
  final GoogleTranslator _translator = GoogleTranslator();
  final Map<String, Map<AppText, String>> _cache = {
    'en': fallbackStrings,
  };

  static const Map<AppText, String> fallbackStrings = {
    AppText.title: 'Old Bibles Reader',
    AppText.translation: 'Translation',
    AppText.language: 'Language',
    AppText.book: 'Book',
    AppText.chapter: 'Chapter',
    AppText.voice: 'Voice',
    AppText.readChapter: 'Read Chapter',
    AppText.stop: 'Stop',
    AppText.textSize: 'Text Size',
    AppText.readSpeed: 'Read Speed',
    AppText.noVerses: 'No verses available for this chapter in this translation.',
    AppText.noVoices: 'No installed voices were found for this language.',
    AppText.voiceHint: 'Download more voices in your device text-to-speech settings.',
  };

  Future<Map<AppText, String>> load(String languageCode) async {
    final normalized = languageCode.toLowerCase();
    if (_cache.containsKey(normalized)) {
      return _cache[normalized]!;
    }

    try {
      final translated = <AppText, String>{};
      for (final entry in fallbackStrings.entries) {
        final result = await _translator.translate(entry.value, to: normalized);
        translated[entry.key] = result.text;
      }
      _cache[normalized] = translated;
      return translated;
    } catch (_) {
      return fallbackStrings;
    }
  }
}
