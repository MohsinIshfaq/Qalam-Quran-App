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
    expect(totalJuzPages, source.totalPages);
    expect(source.firstReadablePage, 2);
    expect(source.juzList, hasLength(30));
    expect(source.surahList, hasLength(114));
    expect(source.pageForJuz(2), 29);
    expect(source.juzForPage(848).number, 30);
  });
}
