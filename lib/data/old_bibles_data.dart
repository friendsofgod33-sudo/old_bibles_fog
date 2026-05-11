class OldBibleVerse {
  const OldBibleVerse({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  final String book;
  final int chapter;
  final int verse;
  final String text;
}

class OldBibleTranslation {
  const OldBibleTranslation({
    required this.id,
    required this.name,
    required this.year,
    required this.verses,
    this.displayTitle,
  });

  final String id;
  final String name;
  final int year;
  final List<OldBibleVerse> verses;
  final String? displayTitle;
}

class OldBiblesData {
  static const List<OldBibleVerse> _sampleVerses = [
    OldBibleVerse(
      book: 'Sample',
      chapter: 1,
      verse: 1,
      text:
          'Sample entry loaded. Add full source text for this work in a future update.',
    ),
    OldBibleVerse(
      book: 'Sample',
      chapter: 1,
      verse: 2,
      text: 'This placeholder keeps the reader and voice tools active.',
    ),
  ];

  static const List<OldBibleTranslation> translations = [
    OldBibleTranslation(
      id: 'kjv_1611',
      name: 'The Authorized King James Bible',
      year: 1611,
      displayTitle: '1611 The Authorized King James Bible',
      verses: [
        OldBibleVerse(
          book: 'Genesis',
          chapter: 1,
          verse: 1,
          text: 'In the beginning God created the heaven and the earth.',
        ),
        OldBibleVerse(
          book: 'Genesis',
          chapter: 1,
          verse: 2,
          text:
              'And the earth was without forme, and voyd, and darkenesse was vpon the face of the deepe.',
        ),
        OldBibleVerse(
          book: 'Genesis',
          chapter: 1,
          verse: 3,
          text: 'And God said, Let there be light: and there was light.',
        ),
        OldBibleVerse(
          book: 'John',
          chapter: 1,
          verse: 1,
          text:
              'In the beginning was the Word, and the Word was with God, and the Word was God.',
        ),
        OldBibleVerse(
          book: 'John',
          chapter: 1,
          verse: 2,
          text: 'The same was in the beginning with God.',
        ),
        OldBibleVerse(
          book: 'John',
          chapter: 1,
          verse: 3,
          text:
              'All things were made by him; and without him was not any thing made that was made.',
        ),
      ],
    ),
    OldBibleTranslation(
      id: 'geneva_1560',
      name: 'The Geneva Bible',
      year: 1560,
      displayTitle: '1560 The Geneva Bible',
      verses: [
        OldBibleVerse(
          book: 'Genesis',
          chapter: 1,
          verse: 1,
          text: 'In the beginning God created ye heauen and the earth.',
        ),
        OldBibleVerse(
          book: 'Genesis',
          chapter: 1,
          verse: 2,
          text:
              'And the earth was without forme and voide, and darkenes was vpon the deepe.',
        ),
        OldBibleVerse(
          book: 'Genesis',
          chapter: 1,
          verse: 3,
          text: 'Then God said, Let there be light: and there was light.',
        ),
        OldBibleVerse(
          book: 'John',
          chapter: 1,
          verse: 1,
          text:
              'In the beginning was that Word, and that Word was with God, and that Word was God.',
        ),
        OldBibleVerse(
          book: 'John',
          chapter: 1,
          verse: 2,
          text: 'This same was in the beginning with God.',
        ),
        OldBibleVerse(
          book: 'John',
          chapter: 1,
          verse: 3,
          text:
              'All things were made by it, and without it was made nothing that was made.',
        ),
      ],
    ),
    OldBibleTranslation(
      id: 'tyndale_1526',
      name: 'Tyndale New Testament',
      year: 1526,
      displayTitle: 'Tyndale New Testament 1526',
      verses: [
        OldBibleVerse(
          book: 'John',
          chapter: 1,
          verse: 1,
          text:
              'In the begynnynge was that worde, and that worde was with god: and god was that worde.',
        ),
        OldBibleVerse(
          book: 'John',
          chapter: 1,
          verse: 2,
          text: 'The same was in the begynnynge with god.',
        ),
        OldBibleVerse(
          book: 'John',
          chapter: 1,
          verse: 3,
          text:
              'All thinges were made by it, and with out it was made nothynge that was made.',
        ),
      ],
    ),
    OldBibleTranslation(
      id: 'great_bible_1540',
      name: 'The Great Bible',
      year: 1540,
      displayTitle: '1540 The Great Bible',
      verses: _sampleVerses,
    ),
    OldBibleTranslation(
      id: 'book_of_enoch',
      name: 'The Book of Enoch',
      year: 0,
      displayTitle: 'The Book of Enoch',
      verses: _sampleVerses,
    ),
    OldBibleTranslation(
      id: 'dictionary_bible_v1_1863',
      name: 'A Dictionary of the Bible (Volume 1)',
      year: 1863,
      displayTitle: '1863 A Dictionary of the Bible (Volume 1)',
      verses: _sampleVerses,
    ),
    OldBibleTranslation(
      id: 'dictionary_bible_v2_1863',
      name: 'A Dictionary of the Bible (Volume 2)',
      year: 1863,
      displayTitle: '1863 A Dictionary of the Bible (Volume 2)',
      verses: _sampleVerses,
    ),
    OldBibleTranslation(
      id: 'dictionary_bible_v3_1863',
      name: 'A Dictionary of the Bible (Volume 3)',
      year: 1863,
      displayTitle: '1863 A Dictionary of the Bible (Volume 3)',
      verses: _sampleVerses,
    ),
    OldBibleTranslation(
      id: 'strongs_exhaustive_concordance',
      name: "Strong's Exhaustive Concordance",
      year: 0,
      displayTitle: "Strong's Exhaustive Concordance",
      verses: _sampleVerses,
    ),
    OldBibleTranslation(
      id: 'codex_sinaiticus',
      name: 'Codex Sinaiticus',
      year: 0,
      displayTitle: 'Codex Sinaiticus',
      verses: _sampleVerses,
    ),
    OldBibleTranslation(
      id: 'didache',
      name: 'The Didache',
      year: 0,
      displayTitle: 'The Didache',
      verses: _sampleVerses,
    ),
    OldBibleTranslation(
      id: 'shepherd_of_hermas',
      name: 'The Shepherd of Hermas',
      year: 0,
      displayTitle: 'The Shepherd of Hermas',
      verses: _sampleVerses,
    ),
    OldBibleTranslation(
      id: 'epistle_of_clement',
      name: 'The Epistle of Clement',
      year: 0,
      displayTitle: 'The Epistle of Clement',
      verses: _sampleVerses,
    ),
    OldBibleTranslation(
      id: 'pilgrims_progress',
      name: "The Pilgrim's Progress",
      year: 0,
      displayTitle: "The Pilgrim's Progress",
      verses: _sampleVerses,
    ),
    OldBibleTranslation(
      id: 'imitation_of_christ',
      name: 'The Imitation of Christ',
      year: 0,
      displayTitle: 'The Imitation of Christ',
      verses: _sampleVerses,
    ),
    OldBibleTranslation(
      id: 'practice_presence_of_god',
      name: 'The Practice of the Presence of God',
      year: 0,
      displayTitle: 'The Practice of the Presence of God',
      verses: _sampleVerses,
    ),
    OldBibleTranslation(
      id: 'morning_evening_devotional',
      name: 'Morning and Evening Daily Devotional',
      year: 0,
      displayTitle: 'Morning and Evening Daily Devotional',
      verses: _sampleVerses,
    ),
  ];
}
