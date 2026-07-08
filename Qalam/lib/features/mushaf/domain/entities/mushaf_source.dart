class MushafSource {
  const MushafSource({
    required this.id,
    required this.title,
    required this.lineCount,
    required this.assetPath,
    required this.totalPages,
    required this.firstReadablePage,
    required this.juzList,
    required this.surahList,
  });

  final String id;
  final String title;
  final int lineCount;
  final String assetPath;
  final int totalPages;
  final int firstReadablePage;
  final List<JuzInfo> juzList;
  final List<SurahInfo> surahList;

  int clampPage(int page) => page.clamp(1, totalPages).toInt();

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
