import 'package:flutter/material.dart';

class AppLanguage {
  const AppLanguage({
    required this.locale,
    required this.label,
  });

  final Locale locale;
  final String label;

  String get languageCode => locale.languageCode.toLowerCase();
}

class AppLanguageCatalog {
  static final List<AppLanguage> languages = (() {
    final list = _localeTags
        .map(_parseLocaleTag)
        .map(
          (locale) => AppLanguage(
            locale: locale,
            label: _labelFor(locale),
          ),
        )
        .toList()
      ..sort((a, b) => a.label.compareTo(b.label));
    return list;
  })();

  static const List<String> _localeTags = [
    'af',
    'am',
    'ar',
    'ar-DZ',
    'ar-EG',
    'ar-SA',
    'as',
    'az',
    'be',
    'bg',
    'bn',
    'bn-BD',
    'bs',
    'ca',
    'cs',
    'cy',
    'da',
    'de',
    'de-AT',
    'de-CH',
    'el',
    'en',
    'en-AU',
    'en-CA',
    'en-GB',
    'en-IN',
    'en-NZ',
    'en-US',
    'en-ZA',
    'es',
    'es-419',
    'es-AR',
    'es-ES',
    'es-MX',
    'et',
    'eu',
    'fa',
    'fi',
    'fil',
    'fr',
    'fr-BE',
    'fr-CA',
    'fr-CH',
    'ga',
    'gl',
    'gu',
    'he',
    'hi',
    'hr',
    'hu',
    'hy',
    'id',
    'is',
    'it',
    'it-CH',
    'ja',
    'ka',
    'kk',
    'km',
    'kn',
    'ko',
    'ky',
    'lo',
    'lt',
    'lv',
    'mk',
    'ml',
    'mn',
    'mr',
    'ms',
    'my',
    'nb',
    'ne',
    'nl',
    'nl-BE',
    'or',
    'pa',
    'pl',
    'ps',
    'pt',
    'pt-BR',
    'pt-PT',
    'ro',
    'ru',
    'si',
    'sk',
    'sl',
    'sq',
    'sr',
    'sr-Latn',
    'sv',
    'sw',
    'ta',
    'te',
    'th',
    'tl',
    'tr',
    'uk',
    'ur',
    'uz',
    'vi',
    'zh',
    'zh-CN',
    'zh-HK',
    'zh-TW',
    'zu',
  ];

  static AppLanguage fallback = const AppLanguage(
    locale: Locale('en'),
    label: 'English',
  );

  static AppLanguage match(Locale locale) {
    final exact = languages.where(
      (item) =>
          item.locale.languageCode.toLowerCase() == locale.languageCode.toLowerCase() &&
          item.locale.countryCode?.toLowerCase() == locale.countryCode?.toLowerCase(),
    );
    if (exact.isNotEmpty) {
      return exact.first;
    }

    final byLanguage = languages.where(
      (item) => item.locale.languageCode.toLowerCase() == locale.languageCode.toLowerCase(),
    );
    if (byLanguage.isNotEmpty) {
      return byLanguage.first;
    }

    return fallback;
  }

  static String _labelFor(Locale locale) {
    final names = <String, String>{
      'af': 'Afrikaans',
      'am': 'Amharic',
      'ar': 'Arabic',
      'as': 'Assamese',
      'az': 'Azerbaijani',
      'be': 'Belarusian',
      'bg': 'Bulgarian',
      'bn': 'Bengali',
      'bs': 'Bosnian',
      'ca': 'Catalan',
      'cs': 'Czech',
      'cy': 'Welsh',
      'da': 'Danish',
      'de': 'German',
      'el': 'Greek',
      'en': 'English',
      'es': 'Spanish',
      'et': 'Estonian',
      'eu': 'Basque',
      'fa': 'Persian',
      'fi': 'Finnish',
      'fil': 'Filipino',
      'fr': 'French',
      'ga': 'Irish',
      'gl': 'Galician',
      'gu': 'Gujarati',
      'he': 'Hebrew',
      'hi': 'Hindi',
      'hr': 'Croatian',
      'hu': 'Hungarian',
      'hy': 'Armenian',
      'id': 'Indonesian',
      'is': 'Icelandic',
      'it': 'Italian',
      'ja': 'Japanese',
      'ka': 'Georgian',
      'kk': 'Kazakh',
      'km': 'Khmer',
      'kn': 'Kannada',
      'ko': 'Korean',
      'ky': 'Kyrgyz',
      'lo': 'Lao',
      'lt': 'Lithuanian',
      'lv': 'Latvian',
      'mk': 'Macedonian',
      'ml': 'Malayalam',
      'mn': 'Mongolian',
      'mr': 'Marathi',
      'ms': 'Malay',
      'my': 'Burmese',
      'nb': 'Norwegian Bokmal',
      'ne': 'Nepali',
      'nl': 'Dutch',
      'no': 'Norwegian',
      'or': 'Odia',
      'pa': 'Punjabi',
      'pl': 'Polish',
      'ps': 'Pashto',
      'pt': 'Portuguese',
      'ro': 'Romanian',
      'ru': 'Russian',
      'si': 'Sinhala',
      'sk': 'Slovak',
      'sl': 'Slovenian',
      'sq': 'Albanian',
      'sr': 'Serbian',
      'sv': 'Swedish',
      'sw': 'Swahili',
      'ta': 'Tamil',
      'te': 'Telugu',
      'th': 'Thai',
      'tl': 'Tagalog',
      'tr': 'Turkish',
      'uk': 'Ukrainian',
      'ur': 'Urdu',
      'uz': 'Uzbek',
      'vi': 'Vietnamese',
      'zh': 'Chinese',
      'zu': 'Zulu',
    };

    final language = names[locale.languageCode.toLowerCase()] ?? locale.languageCode;
    final country = locale.countryCode;
    if (country == null || country.isEmpty) {
      return language;
    }
    return '$language (${country.toUpperCase()})';
  }

  static Locale _parseLocaleTag(String tag) {
    final parts = tag.split('-');
    if (parts.length == 1) {
      return Locale(parts[0]);
    }
    if (parts.length == 2) {
      final second = parts[1];
      if (second.length == 2 || second.length == 3 || second == '419') {
        return Locale(parts[0], second);
      }
      return Locale.fromSubtags(
        languageCode: parts[0],
        scriptCode: second,
      );
    }
    return Locale.fromSubtags(
      languageCode: parts[0],
      scriptCode: parts[1],
      countryCode: parts[2],
    );
  }
}
