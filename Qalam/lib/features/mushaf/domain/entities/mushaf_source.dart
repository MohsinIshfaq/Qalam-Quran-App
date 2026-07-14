class MushafSource {
  const MushafSource({
    required this.id,
    required this.title,
    required this.lineCount,
    required this.assetPath,
    required this.totalPages,
    required this.firstReadablePage,
    required this.lastReadablePage,
    required this.juzList,
    required this.surahList,
    this.pageNumberOffset = 0,
  });

  final String id;
  final String title;
  final int lineCount;
  final String assetPath;
  final int totalPages;
  final int firstReadablePage;
  final int lastReadablePage;
  final int pageNumberOffset;
  final List<JuzInfo> juzList;
  final List<SurahInfo> surahList;

  int clampPage(int page) => page.clamp(1, totalPages).toInt();

  int clampReadablePage(int page) {
    return page.clamp(firstReadablePage, lastReadablePage).toInt();
  }

  int get firstDisplayPage => firstReadablePage + pageNumberOffset;

  int get lastDisplayPage => lastReadablePage + pageNumberOffset;

  int displayPageForPdfPage(int page) => clampPage(page) + pageNumberOffset;

  int pdfPageForDisplayPage(int displayPage) {
    final safeDisplayPage = displayPage
        .clamp(firstDisplayPage, lastDisplayPage)
        .toInt();

    return clampReadablePage(safeDisplayPage - pageNumberOffset);
  }

  JuzInfo juzForPage(int page) {
    final safePage = clampPage(page);

    return juzList.lastWhere(
      (juz) => juz.startPage <= safePage,
      orElse: () => juzList.first,
    );
  }

  int pageForJuz(int juzNumber) {
    final juz = juzList.firstWhere(
      (item) => item.number == juzNumber,
      orElse: () => juzList.first,
    );

    return juz.startPage;
  }

  int? pageForSurah(int surahNumber) {
    for (final surah in surahList) {
      if (surah.number == surahNumber) {
        return surah.verifiedStartPage;
      }
    }

    return null;
  }
}

class JuzInfo {
  const JuzInfo({
    required this.number,
    required this.startPage,
    required this.pageCount,
    this.sourceAssetPath,
  });

  final int number;
  final int startPage;
  final int pageCount;
  final String? sourceAssetPath;

  int get endPage => startPage + pageCount - 1;
}

class SurahInfo {
  const SurahInfo({
    required this.number,
    required this.englishName,
    required this.arabicName,
    required this.startJuz,
    this.verifiedStartPage,
  });

  final int number;
  final String englishName;
  final String arabicName;
  final int startJuz;
  final int? verifiedStartPage;
}
