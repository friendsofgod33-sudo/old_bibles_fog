import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/language_catalog.dart';
import '../data/old_bibles_data.dart';
import '../services/app_localizer.dart';
import '../services/book_service.dart';
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
  final Map<String, List<OldBibleVerse>> _assetVersesByTranslationId = {};
  final Set<String> _availableTextAssetIds = {};
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
    _scanAvailableTextAssets();
    _loadAssetTextForTranslation(_selectedTranslation);

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
    return _effectiveVersesFor(translation).map((v) => v.book).toSet().toList()..sort();
  }

  List<int> _chaptersFor(OldBibleTranslation translation, String? book) {
    if (book == null) {
      return const [];
    }

    return _effectiveVersesFor(translation)
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

    return _effectiveVersesFor(_selectedTranslation)
        .where((v) => v.book == _selectedBook && v.chapter == _selectedChapter)
        .toList()
      ..sort((a, b) => a.verse.compareTo(b.verse));
  }

  List<OldBibleVerse> _effectiveVersesFor(OldBibleTranslation translation) {
    final fromAsset = _assetVersesByTranslationId[translation.id];
    if (fromAsset != null) {
      return fromAsset;
    }
    if (_isSampleOnly(translation.verses)) {
      return const [];
    }
    return translation.verses;
  }

  bool _isSampleOnly(List<OldBibleVerse> verses) {
    return verses.length == 2 && verses.every((v) => v.book == 'Sample');
  }

  bool _isTranslationSelectable(OldBibleTranslation translation) {
    return true;
  }

  List<OldBibleTranslation> _selectableTranslations() {
    return OldBiblesData.translations.where(_isTranslationSelectable).toList();
  }

  Future<void> _scanAvailableTextAssets() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final assetIds = manifest
          .listAssets()
          .where((p) => p.startsWith('assets/texts/') && p.toLowerCase().endsWith('.txt'))
          .map((p) => p.split('/').last)
          .map((f) => f.substring(0, f.length - 4))
          .toSet();
      if (!mounted) {
        return;
      }
      setState(() {
        _availableTextAssetIds
          ..clear()
          ..addAll(assetIds);
      });
      _loadAssetTextForTranslation(_selectedTranslation);
    } catch (_) {
      // Keep defaults if asset manifest probing fails.
    }
  }

  Future<void> _loadAssetTextForTranslation(OldBibleTranslation translation) async {
    if (!_availableTextAssetIds.contains(translation.id)) {
      return;
    }
    if (_assetVersesByTranslationId.containsKey(translation.id)) {
      return;
    }

    final lines = await BookService.getBookLines('${translation.id}.txt');
    if (lines.length == 1 && lines.first == 'Book not found.') {
      return;
    }

    final verses = <OldBibleVerse>[];
    for (var i = 0; i < lines.length; i++) {
      verses.add(
        OldBibleVerse(
          book: translation.displayTitle ?? translation.name,
          chapter: 1,
          verse: i + 1,
          text: lines[i],
        ),
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _assetVersesByTranslationId[translation.id] = verses;
      if (_selectedTranslation.id == translation.id) {
        _selectedBook = _booksFor(_selectedTranslation).firstOrNull;
        _selectedChapter = _chaptersFor(_selectedTranslation, _selectedBook).firstOrNull;
      }
    });
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

  void _openLanguagePicker() {
    String query = '';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) {
          final filtered = query.isEmpty
              ? AppLanguageCatalog.languages
              : AppLanguageCatalog.languages
                  .where((l) =>
                      l.label.toLowerCase().contains(query.toLowerCase()))
                  .toList();
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.75,
            maxChildSize: 0.95,
            minChildSize: 0.4,
            builder: (_, controller) => Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search language…',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (v) => setLocal(() => query = v),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final lang = filtered[i];
                      final selected =
                          lang.languageCode == _selectedLanguage.languageCode;
                      return ListTile(
                        title: Text(lang.label),
                        trailing: selected
                            ? Icon(Icons.check_circle,
                                color: Theme.of(ctx).colorScheme.primary,
                                size: 20)
                            : null,
                        selected: selected,
                        onTap: () {
                          Navigator.pop(ctx);
                          setState(() => _selectedLanguage = lang);
                          _applyVoiceFilter();
                          _loadLabels();
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _toggleSpeaker() async {
    if (_speaking) {
      await _voiceReader.stop();
    } else {
      await _readChapter();
    }
  }


  Future<void> _readChapter() async {
    final verses = _versesForSelection();
    if (verses.isEmpty) {
      return;
    }

    final intro = '${_selectedBook ?? ''}, Chapter ${_selectedChapter ?? ''}. ';
    final body = verses.map((v) => v.text).join(' ');
    final text = intro + body;
    await _voiceReader.speak(
      text: text,
      rate: _speechRate,
      voice: _selectedVoice,
      languageCode: _selectedLanguage.locale.toLanguageTag(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectableTranslations = _selectableTranslations();
    final translationValue = selectableTranslations.any((t) => t.id == _selectedTranslation.id)
        ? _selectedTranslation
        : (selectableTranslations.isNotEmpty ? selectableTranslations.first : _selectedTranslation);
    final books = _booksFor(_selectedTranslation);
    final chapters = _chaptersFor(_selectedTranslation, _selectedBook);
    final verses = _versesForSelection();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          // Language picker
          Material(
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: Theme.of(context).dividerColor),
            ),
            child: InkWell(
              onTap: _openLanguagePicker,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _label(AppText.language),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedLanguage.label,
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TranslationDropdown(
            label: _label(AppText.translation),
            value: translationValue,
            options: selectableTranslations,
            onChanged: (translation) {
              setState(() {
                _selectedTranslation = translation;
                _selectedBook = _booksFor(translation).firstOrNull;
                _selectedChapter =
                    _chaptersFor(translation, _selectedBook).firstOrNull;
              });
              _loadAssetTextForTranslation(translation);
            },
          ),
          if (_effectiveVersesFor(_selectedTranslation).isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Full text not installed yet: assets/texts/${_selectedTranslation.id}.txt',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
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
                  isExpanded: true,
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
            isExpanded: true,
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
          // Speaker toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: _toggleSpeaker,
                icon: Icon(_speaking ? Icons.stop_circle : Icons.volume_up),
                label: Text(
                  _speaking ? _label(AppText.stop) : _label(AppText.readChapter),
                ),
                style: _speaking
                    ? FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                      )
                    : null,
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
