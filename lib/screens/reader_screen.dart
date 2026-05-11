import 'dart:async';

import 'package:flutter/material.dart';

import '../data/language_catalog.dart';
import '../data/old_bibles_data.dart';
import '../services/app_localizer.dart';
import '../services/voice_reader.dart';
import '../widgets/reader/slider_row.dart';
import '../widgets/reader/translation_dropdown.dart';
import '../widgets/reader/verses_panel.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final AppLocalizer _localizer = AppLocalizer();
  final VoiceReader _voiceReader = VoiceReader();

  late OldBibleTranslation _selectedTranslation;
  late AppLanguage _selectedLanguage;
  String? _selectedBook;
  int? _selectedChapter;
  List<VoiceOption> _allVoices = const [];
  List<VoiceOption> _voices = const [];
  VoiceOption? _selectedVoice;
  StreamSubscription<bool>? _speakingSubscription;
  Map<AppText, String> _labels = AppLocalizer.fallbackStrings;

  bool _speaking = false;
  bool _loadingLabels = false;
  bool _loadingVoices = false;
  double _fontSize = 18;
  double _speechRate = 0.45;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = AppLanguageCatalog.match(
      WidgetsBinding.instance.platformDispatcher.locale,
    );
    _selectedTranslation = OldBiblesData.translations.first;
    _selectedBook = _booksFor(_selectedTranslation).firstOrNull;
    _selectedChapter = _chaptersFor(_selectedTranslation, _selectedBook).firstOrNull;

    _speakingSubscription = _voiceReader.speakingState.listen((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        _speaking = value;
      });
    });

    _loadLabels();
    _loadVoices();
  }

  @override
  void dispose() {
    _speakingSubscription?.cancel();
    _voiceReader.dispose();
    super.dispose();
  }

  List<String> _booksFor(OldBibleTranslation translation) {
    return translation.verses.map((v) => v.book).toSet().toList()..sort();
  }

  List<int> _chaptersFor(OldBibleTranslation translation, String? book) {
    if (book == null) {
      return const [];
    }

    return translation.verses
        .where((v) => v.book == book)
        .map((v) => v.chapter)
        .toSet()
        .toList()
      ..sort();
  }

  List<OldBibleVerse> _versesForSelection() {
    if (_selectedBook == null || _selectedChapter == null) {
      return const [];
    }

    return _selectedTranslation.verses
        .where((v) => v.book == _selectedBook && v.chapter == _selectedChapter)
        .toList()
      ..sort((a, b) => a.verse.compareTo(b.verse));
  }

  String _label(AppText key) =>
      _labels[key] ?? AppLocalizer.fallbackStrings[key] ?? '';

  String _normalizedLanguageCode(String value) {
    final sanitized = value.replaceAll('_', '-').toLowerCase();
    return sanitized.split('-').first;
  }

  void _applyVoiceFilter() {
    final selectedCode = _selectedLanguage.languageCode;
    final matches = _allVoices
        .where((voice) => _normalizedLanguageCode(voice.locale) == selectedCode)
        .toList()
      ..sort((a, b) => a.displayName.compareTo(b.displayName));

    setState(() {
      _voices = matches;
      _selectedVoice = matches.firstOrNull;
    });
  }

  Future<void> _loadLabels() async {
    setState(() {
      _loadingLabels = true;
    });

    final labels = await _localizer.load(_selectedLanguage.languageCode);
    if (!mounted) {
      return;
    }

    setState(() {
      _labels = labels;
      _loadingLabels = false;
    });
  }

  Future<void> _loadVoices() async {
    setState(() {
      _loadingVoices = true;
    });

    final voices = await _voiceReader.getVoices();
    if (!mounted) {
      return;
    }

    setState(() {
      _allVoices = voices;
      _loadingVoices = false;
    });
    _applyVoiceFilter();
  }

  Future<void> _readChapter() async {
    final verses = _versesForSelection();
    if (verses.isEmpty) {
      return;
    }

    final text = verses.map((v) => 'Verse ${v.verse}. ${v.text}').join(' ');
    await _voiceReader.speak(
      text: text,
      rate: _speechRate,
      voice: _selectedVoice,
      languageCode: _selectedLanguage.locale.toLanguageTag(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final books = _booksFor(_selectedTranslation);
    final chapters = _chaptersFor(_selectedTranslation, _selectedBook);
    final verses = _versesForSelection();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
          DropdownButtonFormField<AppLanguage>(
            initialValue: _selectedLanguage,
            decoration: InputDecoration(
              labelText: _label(AppText.language),
              border: const OutlineInputBorder(),
            ),
            items: AppLanguageCatalog.languages
                .map(
                  (language) => DropdownMenuItem<AppLanguage>(
                    value: language,
                    child: Text(language.label),
                  ),
                )
                .toList(),
            onChanged: (language) {
              if (language == null) {
                return;
              }
              setState(() {
                _selectedLanguage = language;
              });
              _applyVoiceFilter();
              _loadLabels();
            },
          ),
          const SizedBox(height: 12),
          TranslationDropdown(
            label: _label(AppText.translation),
            value: _selectedTranslation,
            options: OldBiblesData.translations,
            onChanged: (translation) {
              setState(() {
                _selectedTranslation = translation;
                _selectedBook = _booksFor(translation).firstOrNull;
                _selectedChapter =
                    _chaptersFor(translation, _selectedBook).firstOrNull;
              });
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedBook,
                  decoration: InputDecoration(
                    labelText: _label(AppText.book),
                    border: const OutlineInputBorder(),
                  ),
                  items: books
                      .map(
                        (book) => DropdownMenuItem<String>(
                          value: book,
                          child: Text(book),
                        ),
                      )
                      .toList(),
                  onChanged: (book) {
                    setState(() {
                      _selectedBook = book;
                      _selectedChapter = _chaptersFor(
                        _selectedTranslation,
                        book,
                      ).firstOrNull;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: _selectedChapter,
                  decoration: InputDecoration(
                    labelText: _label(AppText.chapter),
                    border: const OutlineInputBorder(),
                  ),
                  items: chapters
                      .map(
                        (chapter) => DropdownMenuItem<int>(
                          value: chapter,
                          child: Text('$chapter'),
                        ),
                      )
                      .toList(),
                  onChanged: (chapter) {
                    setState(() {
                      _selectedChapter = chapter;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<VoiceOption>(
            initialValue: _selectedVoice,
            decoration: InputDecoration(
              labelText:
                  '${_label(AppText.voice)} (${_selectedLanguage.label})',
              border: const OutlineInputBorder(),
            ),
            items: _voices
                .map(
                  (voice) => DropdownMenuItem<VoiceOption>(
                    value: voice,
                    child: Text('${voice.displayName} - ${voice.styleHint}'),
                  ),
                )
                .toList(),
            onChanged: _loadingVoices || _voices.isEmpty
                ? null
                : (voice) {
                    setState(() {
                      _selectedVoice = voice;
                    });
                  },
          ),
          if (_loadingLabels || _loadingVoices)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: LinearProgressIndicator(),
            )
          else if (_voices.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_label(AppText.noVoices)} ${_label(AppText.voiceHint)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _readChapter,
                  icon: const Icon(Icons.volume_up),
                  label: Text(_label(AppText.readChapter)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _speaking ? _voiceReader.stop : null,
                  icon: const Icon(Icons.stop_circle_outlined),
                  label: Text(_label(AppText.stop)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderRow(
            label: _label(AppText.textSize),
            value: _fontSize,
            min: 14,
            max: 28,
            onChanged: (value) {
              setState(() {
                _fontSize = value;
              });
            },
          ),
          SliderRow(
            label: _label(AppText.readSpeed),
            value: _speechRate,
            min: 0.2,
            max: 0.6,
            onChanged: (value) {
              setState(() {
                _speechRate = value;
              });
            },
          ),
          const SizedBox(height: 12),
          VersesPanel(
            verses: verses,
            fontSize: _fontSize,
            noVersesLabel: _label(AppText.noVerses),
          ),
        ],
      ),
      ),
    );
  }
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
