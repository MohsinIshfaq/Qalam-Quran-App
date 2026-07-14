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

    expect(MushafCatalog.sixteenLine.totalPages, 559);
    expect(MushafCatalog.sixteenLine.firstReadablePage, 3);
    expect(MushafCatalog.sixteenLine.lastReadablePage, 550);
    expect(MushafCatalog.sixteenLine.firstDisplayPage, 2);
    expect(MushafCatalog.sixteenLine.lastDisplayPage, 549);
    expect(MushafCatalog.sixteenLine.juzList, hasLength(30));
    expect(MushafCatalog.sixteenLine.surahList.first.verifiedStartPage, 3);
    expect(MushafCatalog.sixteenLine.pageForSurah(3), 40);
    expect(MushafCatalog.sixteenLine.pageForSurah(57), 486);
    expect(MushafCatalog.sixteenLine.pageForSurah(114), 550);
    expect(MushafCatalog.sixteenLine.pdfPageForDisplayPage(39), 40);
  });
}
