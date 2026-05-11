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
  });

  final String id;
  final String name;
  final int year;
  final List<OldBibleVerse> verses;
}

class OldBiblesData {
  static const List<OldBibleTranslation> translations = [
    OldBibleTranslation(
      id: 'kjv_1611',
      name: 'King James Version',
      year: 1611,
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
      name: 'Geneva Bible',
      year: 1560,
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
  ];
}
