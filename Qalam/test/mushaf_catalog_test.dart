import 'package:flutter_test/flutter_test.dart';
import 'package:qalam/features/mushaf/data/models/mushaf_catalog.dart';

void main() {
  test('13-line Mushaf metadata matches the bundled PDF', () {
    final source = MushafCatalog.thirteenLine;
    final totalJuzPages = source.juzList.fold<int>(
      0,
      (total, juz) => total + juz.pageCount,
    );

    expect(source.totalPages, 848);
    expect(
      totalJuzPages,
      source.lastReadablePage - source.firstReadablePage + 1,
    );
    expect(source.firstReadablePage, 2);
    expect(source.lastReadablePage, 848);
    expect(source.juzList, hasLength(30));
    expect(source.surahList, hasLength(114));
    expect(source.pageForJuz(1), 2);
    expect(source.pageForJuz(2), 29);
    expect(source.juzForPage(848).number, 30);
    expect(
      source.surahList.every((surah) => surah.verifiedStartPage != null),
      isTrue,
    );
    expect(source.pageForSurah(1), 2);
    expect(source.pageForSurah(3), 68);
    expect(source.pageForSurah(5), 147);
    expect(source.pageForSurah(41), 659);
    expect(source.pageForSurah(94), 838);
    expect(source.pageForSurah(95), 839);
    expect(source.pageForSurah(114), 848);
  });

  test('catalog exposes 15-line and 16-line Mushaf sources', () {
    expect(MushafCatalog.sources, hasLength(3));

    expect(MushafCatalog.fifteenLine.totalPages, 619);
    expect(MushafCatalog.fifteenLine.firstReadablePage, 3);
    expect(MushafCatalog.fifteenLine.lastReadablePage, 612);
    expect(MushafCatalog.fifteenLine.firstDisplayPage, 2);
    expect(MushafCatalog.fifteenLine.lastDisplayPage, 611);
    expect(MushafCatalog.fifteenLine.juzList, hasLength(30));
    expect(MushafCatalog.fifteenLine.juzList.map((juz) => juz.startPage), <int>[
      3,
      24,
      44,
      64,
      84,
      104,
      124,
      144,
      164,
      184,
      204,
      224,
      244,
      264,
      284,
      307,
      324,
      344,
      364,
      384,
      404,
      424,
      444,
      464,
      484,
      504,
      524,
      544,
      564,
      588,
    ]);
    expect(
      MushafCatalog.fifteenLine.juzList.fold<int>(
        0,
        (total, juz) => total + juz.pageCount,
      ),
      610,
    );
    for (final juz in MushafCatalog.fifteenLine.juzList.skip(1)) {
      expect(
        MushafCatalog.fifteenLine.juzForPage(juz.startPage - 1).number,
        juz.number - 1,
      );
      expect(
        MushafCatalog.fifteenLine.juzForPage(juz.startPage).number,
        juz.number,
      );
    }
    expect(MushafCatalog.fifteenLine.pageForJuz(2), 24);
    expect(MushafCatalog.fifteenLine.displayPageForPdfPage(24), 23);
    expect(MushafCatalog.fifteenLine.pageForJuz(3), 44);
    expect(MushafCatalog.fifteenLine.pageForJuz(16), 307);
    expect(MushafCatalog.fifteenLine.pageForJuz(25), 484);
    expect(MushafCatalog.fifteenLine.pageForJuz(30), 588);
    expect(MushafCatalog.fifteenLine.surahList.first.verifiedStartPage, 3);
    expect(MushafCatalog.fifteenLine.pageForSurah(3), 52);
    expect(MushafCatalog.fifteenLine.pageForSurah(4), 79);
    expect(MushafCatalog.fifteenLine.pdfPageForDisplayPage(78), 79);

    final sixteenLine = MushafCatalog.sixteenLine;
    const expectedJuzStartPages = <int>[
      3,
      22,
      40,
      58,
      76,
      94,
      112,
      130,
      148,
      166,
      184,
      202,
      220,
      237,
      256,
      274,
      292,
      310,
      328,
      346,
      364,
      382,
      400,
      418,
      436,
      454,
      472,
      490,
      510,
      530,
    ];

    expect(sixteenLine.totalPages, 559);
    expect(sixteenLine.firstReadablePage, 3);
    expect(sixteenLine.lastReadablePage, 550);
    expect(sixteenLine.firstDisplayPage, 2);
    expect(sixteenLine.lastDisplayPage, 549);
    expect(sixteenLine.juzList, hasLength(30));
    expect(
      sixteenLine.juzList.map((juz) => juz.startPage),
      expectedJuzStartPages,
    );
    expect(
      sixteenLine.juzList.fold<int>(0, (total, juz) => total + juz.pageCount),
      548,
    );
    for (var index = 0; index < expectedJuzStartPages.length; index += 1) {
      final juzNumber = index + 1;
      final pdfPage = expectedJuzStartPages[index];

      expect(sixteenLine.pageForJuz(juzNumber), pdfPage);
      expect(sixteenLine.displayPageForPdfPage(pdfPage), pdfPage - 1);
    }
    for (final juz in sixteenLine.juzList.skip(1)) {
      expect(sixteenLine.juzForPage(juz.startPage - 1).number, juz.number - 1);
      expect(sixteenLine.juzForPage(juz.startPage).number, juz.number);
    }
    expect(sixteenLine.juzForPage(550).number, 30);
    expect(sixteenLine.surahList.first.verifiedStartPage, 3);
    expect(sixteenLine.pageForSurah(3), 47);
    expect(sixteenLine.pageForSurah(57), 486);
    expect(sixteenLine.pageForSurah(114), 550);
    expect(sixteenLine.pdfPageForDisplayPage(39), 40);
  });

  test('16-line Surah index matches the scanned title pages', () {
    final source = MushafCatalog.sixteenLine;
    const expectedDisplayPages = <int>[
      2,
      3,
      46,
      70,
      97,
      116,
      137,
      160,
      169,
      188,
      200,
      213,
      225,
      231,
      236,
      241,
      255,
      265,
      276,
      282,
      291,
      300,
      309,
      316,
      325,
      331,
      340,
      348,
      358,
      365,
      371,
      374,
      377,
      386,
      392,
      397,
      402,
      409,
      413,
      421,
      430,
      435,
      441,
      447,
      449,
      453,
      457,
      461,
      464,
      467,
      469,
      472,
      474,
      476,
      479,
      482,
      485,
      489,
      492,
      496,
      498,
      500,
      501,
      503,
      505,
      507,
      509,
      511,
      513,
      515,
      517,
      519,
      521,
      522,
      524,
      525,
      527,
      529,
      530,
      531,
      533,
      533,
      534,
      535,
      536,
      537,
      538,
      538,
      539,
      540,
      541,
      541,
      542,
      542,
      543,
      543,
      544,
      544,
      545,
      545,
      545,
      546,
      546,
      546,
      547,
      547,
      547,
      547,
      548,
      548,
      548,
      548,
      549,
      549,
    ];

    expect(source.surahList, hasLength(expectedDisplayPages.length));
    for (var index = 0; index < expectedDisplayPages.length; index += 1) {
      final surahNumber = index + 1;
      final displayPage = expectedDisplayPages[index];
      final pdfPage = displayPage + 1;
      final surah = source.surahList[index];

      expect(surah.number, surahNumber);
      expect(
        surah.verifiedStartPage,
        pdfPage,
        reason: 'Surah $surahNumber must open on PDF page $pdfPage.',
      );
      expect(source.pageForSurah(surahNumber), pdfPage);
      expect(source.displayPageForPdfPage(pdfPage), displayPage);
    }
  });
}
