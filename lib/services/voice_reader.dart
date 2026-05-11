import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

class VoiceOption {
  const VoiceOption({
    required this.name,
    required this.locale,
    required this.displayName,
    required this.styleHint,
  });

  final String name;
  final String locale;
  final String displayName;
  final String styleHint;

  @override
  String toString() => '$displayName ($locale)';
}

class VoiceReader {
  VoiceReader() {
    _tts.setCompletionHandler(() {
      _stateController.add(false);
    });

    _tts.setCancelHandler(() {
      _stateController.add(false);
    });

    _tts.setErrorHandler((_) {
      _stateController.add(false);
    });
  }

  final FlutterTts _tts = FlutterTts();
  final StreamController<bool> _stateController = StreamController<bool>.broadcast();

  Stream<bool> get speakingState => _stateController.stream;

  Future<List<VoiceOption>> getVoices() async {
    final dynamic raw = await _tts.getVoices;
    if (raw is! List) {
      return const [];
    }

    final result = <VoiceOption>[];
    for (final dynamic item in raw) {
      if (item is Map) {
        final dynamic name = item['name'];
        final dynamic locale = item['locale'];
        if (name is String && locale is String) {
          final cleanedName = _cleanVoiceName(name);
          result.add(
            VoiceOption(
              name: name,
              locale: locale,
              displayName: cleanedName,
              styleHint: _inferStyleHint(name),
            ),
          );
        }
      }
    }

    result.sort((a, b) {
      final byLocale = a.locale.compareTo(b.locale);
      if (byLocale != 0) {
        return byLocale;
      }
      return a.displayName.compareTo(b.displayName);
    });
    return result;
  }

  String _cleanVoiceName(String rawName) {
    var name = rawName
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\b[a-z]{2}\s?[A-Z]{2}\b'), ' ')
        .replaceAll(RegExp(r'\bx\s[a-z0-9]+\b', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (name.isEmpty) {
      return 'Standard Voice';
    }

    final lower = name.toLowerCase();
    if (lower.contains('news') || lower.contains('narrat')) {
      return 'Narrator';
    }
    if (lower.contains('studio')) {
      return 'Studio';
    }
    if (lower.contains('journey')) {
      return 'Journey';
    }
    if (lower.contains('wavenet') || lower.contains('neural') || lower.contains('enhanced')) {
      return 'Natural';
    }
    if (lower.contains('female') || lower.endsWith('f')) {
      return 'Female Voice';
    }
    if (lower.contains('male') || lower.endsWith('m')) {
      return 'Male Voice';
    }

    if (name.length == 1 && RegExp(r'[a-zA-Z]').hasMatch(name)) {
      return 'Voice ${name.toUpperCase()}';
    }

    return name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}')
        .join(' ');
  }

  String _inferStyleHint(String rawName) {
    final lower = rawName.toLowerCase();
    if (lower.contains('news') || lower.contains('narrat')) {
      return 'Reading voice';
    }
    if (lower.contains('studio')) {
      return 'Dramatic tone';
    }
    if (lower.contains('journey')) {
      return 'Storytelling tone';
    }
    if (lower.contains('wavenet') || lower.contains('neural') || lower.contains('enhanced')) {
      return 'Natural tone';
    }
    return 'Standard tone';
  }

  Future<void> speak({
    required String text,
    required double rate,
    VoiceOption? voice,
    String? languageCode,
  }) async {
    if (voice != null) {
      await _tts.setVoice({'name': voice.name, 'locale': voice.locale});
      await _tts.setLanguage(voice.locale);
    } else if (languageCode != null && languageCode.isNotEmpty) {
      await _tts.setLanguage(languageCode);
    }

    await _tts.setSpeechRate(rate);
    await _tts.setPitch(1.0);
    await _tts.stop();

    _stateController.add(true);
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
    _stateController.add(false);
  }

  Future<void> dispose() async {
    await _tts.stop();
    await _stateController.close();
  }
}
