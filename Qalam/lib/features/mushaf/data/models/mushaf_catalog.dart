import '../../domain/entities/mushaf_source.dart';

class MushafCatalog {
  MushafCatalog._();

  static final MushafSource thirteenLine = MushafSource(
    id: 'quran_13_line',
    title: '13-Line Quran',
    lineCount: 13,
    assetPath: 'assets/mushaf/13_line/complete_quran_13_line.pdf',
    totalPages: 848,
    firstReadablePage: 2,
    juzList: _juzList(const <int>[
      28,
      28,
      28,
      28,
      28,
      28,
      28,
      28,
      28,
      28,
      28,
      28,
      28,
      28,
      28,
      28,
      28,
      28,
      28,
      26,
      28,
      26,
      28,
      26,
      30,
      30,
      30,
      30,
      32,
      30,
    ]),
    surahList: _surahListFor(fatihahPage: 2, baqarahPage: 3),
  );

  static final MushafSource fifteenLine = MushafSource(
    id: 'quran_15_line',
    title: '15-Line Quran',
    lineCount: 15,
    assetPath: 'assets/mushaf/15_line/complete_quran_15_line.pdf',
    totalPages: 619,
    firstReadablePage: 3,
    juzList: _distributedJuzList(firstPage: 3, contentPageCount: 610),
    surahList: _surahListFor(fatihahPage: 3, baqarahPage: 4),
  );

  static final MushafSource sixteenLine = MushafSource(
    id: 'quran_16_line',
    title: '16-Line Quran',
    lineCount: 16,
    assetPath: 'assets/mushaf/16_line/complete_quran_16_line.pdf',
    totalPages: 559,
    firstReadablePage: 3,
    juzList: _distributedJuzList(firstPage: 3, contentPageCount: 548),
    surahList: _surahListFor(fatihahPage: 3, baqarahPage: 4),
  );

  static final List<MushafSource> sources = List.unmodifiable([
    thirteenLine,
    fifteenLine,
    sixteenLine,
  ]);

  static List<JuzInfo> _juzList(List<int> pageCounts) {
    var startPage = 1;
    final result = <JuzInfo>[];

    for (var index = 0; index < pageCounts.length; index += 1) {
      final number = index + 1;
      final count = pageCounts[index];

      result.add(
        JuzInfo(
          number: number,
          startPage: startPage,
          pageCount: count,
          sourceAssetPath:
              'assets/mushaf/13_line/juz/juz${number.toString().padLeft(2, '0')}.pdf',
        ),
      );

      startPage += count;
    }

    return List.unmodifiable(result);
  }

  static List<JuzInfo> _distributedJuzList({
    required int firstPage,
    required int contentPageCount,
  }) {
    final result = <JuzInfo>[];

    for (var index = 0; index < 30; index += 1) {
      final relativeStart = (index * contentPageCount) ~/ 30;
      final relativeEnd = ((index + 1) * contentPageCount) ~/ 30;

      result.add(
        JuzInfo(
          number: index + 1,
          startPage: firstPage + relativeStart,
          pageCount: relativeEnd - relativeStart,
        ),
      );
    }

    return List.unmodifiable(result);
  }

  static List<SurahInfo> _surahListFor({
    required int fatihahPage,
    required int baqarahPage,
  }) {
    return List.unmodifiable(
      _surahList.map((surah) {
        if (surah.number == 1) {
          return SurahInfo(
            number: surah.number,
            englishName: surah.englishName,
            arabicName: surah.arabicName,
            startJuz: surah.startJuz,
            verifiedStartPage: fatihahPage,
          );
        }

        if (surah.number == 2) {
          return SurahInfo(
            number: surah.number,
            englishName: surah.englishName,
            arabicName: surah.arabicName,
            startJuz: surah.startJuz,
            verifiedStartPage: baqarahPage,
          );
        }

        return surah;
      }),
    );
  }

  static const List<SurahInfo> _surahList = <SurahInfo>[
    SurahInfo(
      number: 1,
      englishName: 'Al-Fatihah',
      arabicName: 'الفاتحة',
      startJuz: 1,
      verifiedStartPage: 2,
    ),
    SurahInfo(
      number: 2,
      englishName: 'Al-Baqarah',
      arabicName: 'البقرة',
      startJuz: 1,
      verifiedStartPage: 3,
    ),
    SurahInfo(
      number: 3,
      englishName: 'Ali Imran',
      arabicName: 'آل عمران',
      startJuz: 3,
    ),
    SurahInfo(
      number: 4,
      englishName: 'An-Nisa',
      arabicName: 'النساء',
      startJuz: 4,
    ),
    SurahInfo(
      number: 5,
      englishName: "Al-Ma'idah",
      arabicName: 'المائدة',
      startJuz: 6,
    ),
    SurahInfo(
      number: 6,
      englishName: "Al-An'am",
      arabicName: 'الأنعام',
      startJuz: 7,
    ),
    SurahInfo(
      number: 7,
      englishName: "Al-A'raf",
      arabicName: 'الأعراف',
      startJuz: 8,
    ),
    SurahInfo(
      number: 8,
      englishName: 'Al-Anfal',
      arabicName: 'الأنفال',
      startJuz: 9,
    ),
    SurahInfo(
      number: 9,
      englishName: 'At-Tawbah',
      arabicName: 'التوبة',
      startJuz: 10,
    ),
    SurahInfo(
      number: 10,
      englishName: 'Yunus',
      arabicName: 'يونس',
      startJuz: 11,
    ),
    SurahInfo(number: 11, englishName: 'Hud', arabicName: 'هود', startJuz: 11),
    SurahInfo(
      number: 12,
      englishName: 'Yusuf',
      arabicName: 'يوسف',
      startJuz: 12,
    ),
    SurahInfo(
      number: 13,
      englishName: "Ar-Ra'd",
      arabicName: 'الرعد',
      startJuz: 13,
    ),
    SurahInfo(
      number: 14,
      englishName: 'Ibrahim',
      arabicName: 'إبراهيم',
      startJuz: 13,
    ),
    SurahInfo(
      number: 15,
      englishName: 'Al-Hijr',
      arabicName: 'الحجر',
      startJuz: 14,
    ),
    SurahInfo(
      number: 16,
      englishName: 'An-Nahl',
      arabicName: 'النحل',
      startJuz: 14,
    ),
    SurahInfo(
      number: 17,
      englishName: 'Al-Isra',
      arabicName: 'الإسراء',
      startJuz: 15,
    ),
    SurahInfo(
      number: 18,
      englishName: 'Al-Kahf',
      arabicName: 'الكهف',
      startJuz: 15,
    ),
    SurahInfo(
      number: 19,
      englishName: 'Maryam',
      arabicName: 'مريم',
      startJuz: 16,
    ),
    SurahInfo(number: 20, englishName: 'Taha', arabicName: 'طه', startJuz: 16),
    SurahInfo(
      number: 21,
      englishName: 'Al-Anbiya',
      arabicName: 'الأنبياء',
      startJuz: 17,
    ),
    SurahInfo(
      number: 22,
      englishName: 'Al-Hajj',
      arabicName: 'الحج',
      startJuz: 17,
    ),
    SurahInfo(
      number: 23,
      englishName: "Al-Mu'minun",
      arabicName: 'المؤمنون',
      startJuz: 18,
    ),
    SurahInfo(
      number: 24,
      englishName: 'An-Nur',
      arabicName: 'النور',
      startJuz: 18,
    ),
    SurahInfo(
      number: 25,
      englishName: 'Al-Furqan',
      arabicName: 'الفرقان',
      startJuz: 18,
    ),
    SurahInfo(
      number: 26,
      englishName: "Ash-Shu'ara",
      arabicName: 'الشعراء',
      startJuz: 19,
    ),
    SurahInfo(
      number: 27,
      englishName: 'An-Naml',
      arabicName: 'النمل',
      startJuz: 19,
    ),
    SurahInfo(
      number: 28,
      englishName: 'Al-Qasas',
      arabicName: 'القصص',
      startJuz: 20,
    ),
    SurahInfo(
      number: 29,
      englishName: 'Al-Ankabut',
      arabicName: 'العنكبوت',
      startJuz: 20,
    ),
    SurahInfo(
      number: 30,
      englishName: 'Ar-Rum',
      arabicName: 'الروم',
      startJuz: 21,
    ),
    SurahInfo(
      number: 31,
      englishName: 'Luqman',
      arabicName: 'لقمان',
      startJuz: 21,
    ),
    SurahInfo(
      number: 32,
      englishName: 'As-Sajdah',
      arabicName: 'السجدة',
      startJuz: 21,
    ),
    SurahInfo(
      number: 33,
      englishName: 'Al-Ahzab',
      arabicName: 'الأحزاب',
      startJuz: 21,
    ),
    SurahInfo(number: 34, englishName: 'Saba', arabicName: 'سبأ', startJuz: 22),
    SurahInfo(
      number: 35,
      englishName: 'Fatir',
      arabicName: 'فاطر',
      startJuz: 22,
    ),
    SurahInfo(
      number: 36,
      englishName: 'Ya-Sin',
      arabicName: 'يس',
      startJuz: 22,
    ),
    SurahInfo(
      number: 37,
      englishName: 'As-Saffat',
      arabicName: 'الصافات',
      startJuz: 23,
    ),
    SurahInfo(number: 38, englishName: 'Sad', arabicName: 'ص', startJuz: 23),
    SurahInfo(
      number: 39,
      englishName: 'Az-Zumar',
      arabicName: 'الزمر',
      startJuz: 23,
    ),
    SurahInfo(
      number: 40,
      englishName: 'Ghafir',
      arabicName: 'غافر',
      startJuz: 24,
    ),
    SurahInfo(
      number: 41,
      englishName: 'Fussilat',
      arabicName: 'فصلت',
      startJuz: 24,
    ),
    SurahInfo(
      number: 42,
      englishName: 'Ash-Shuraa',
      arabicName: 'الشورى',
      startJuz: 25,
    ),
    SurahInfo(
      number: 43,
      englishName: 'Az-Zukhruf',
      arabicName: 'الزخرف',
      startJuz: 25,
    ),
    SurahInfo(
      number: 44,
      englishName: 'Ad-Dukhan',
      arabicName: 'الدخان',
      startJuz: 25,
    ),
    SurahInfo(
      number: 45,
      englishName: 'Al-Jathiyah',
      arabicName: 'الجاثية',
      startJuz: 25,
    ),
    SurahInfo(
      number: 46,
      englishName: 'Al-Ahqaf',
      arabicName: 'الأحقاف',
      startJuz: 26,
    ),
    SurahInfo(
      number: 47,
      englishName: 'Muhammad',
      arabicName: 'محمد',
      startJuz: 26,
    ),
    SurahInfo(
      number: 48,
      englishName: 'Al-Fath',
      arabicName: 'الفتح',
      startJuz: 26,
    ),
    SurahInfo(
      number: 49,
      englishName: 'Al-Hujurat',
      arabicName: 'الحجرات',
      startJuz: 26,
    ),
    SurahInfo(number: 50, englishName: 'Qaf', arabicName: 'ق', startJuz: 26),
    SurahInfo(
      number: 51,
      englishName: 'Adh-Dhariyat',
      arabicName: 'الذاريات',
      startJuz: 26,
    ),
    SurahInfo(
      number: 52,
      englishName: 'At-Tur',
      arabicName: 'الطور',
      startJuz: 27,
    ),
    SurahInfo(
      number: 53,
      englishName: 'An-Najm',
      arabicName: 'النجم',
      startJuz: 27,
    ),
    SurahInfo(
      number: 54,
      englishName: 'Al-Qamar',
      arabicName: 'القمر',
      startJuz: 27,
    ),
    SurahInfo(
      number: 55,
      englishName: 'Ar-Rahman',
      arabicName: 'الرحمن',
      startJuz: 27,
    ),
    SurahInfo(
      number: 56,
      englishName: "Al-Waqi'ah",
      arabicName: 'الواقعة',
      startJuz: 27,
    ),
    SurahInfo(
      number: 57,
      englishName: 'Al-Hadid',
      arabicName: 'الحديد',
      startJuz: 27,
    ),
    SurahInfo(
      number: 58,
      englishName: 'Al-Mujadilah',
      arabicName: 'المجادلة',
      startJuz: 28,
    ),
    SurahInfo(
      number: 59,
      englishName: 'Al-Hashr',
      arabicName: 'الحشر',
      startJuz: 28,
    ),
    SurahInfo(
      number: 60,
      englishName: 'Al-Mumtahanah',
      arabicName: 'الممتحنة',
      startJuz: 28,
    ),
    SurahInfo(
      number: 61,
      englishName: 'As-Saff',
      arabicName: 'الصف',
      startJuz: 28,
    ),
    SurahInfo(
      number: 62,
      englishName: "Al-Jumu'ah",
      arabicName: 'الجمعة',
      startJuz: 28,
    ),
    SurahInfo(
      number: 63,
      englishName: 'Al-Munafiqun',
      arabicName: 'المنافقون',
      startJuz: 28,
    ),
    SurahInfo(
      number: 64,
      englishName: 'At-Taghabun',
      arabicName: 'التغابن',
      startJuz: 28,
    ),
    SurahInfo(
      number: 65,
      englishName: 'At-Talaq',
      arabicName: 'الطلاق',
      startJuz: 28,
    ),
    SurahInfo(
      number: 66,
      englishName: 'At-Tahrim',
      arabicName: 'التحريم',
      startJuz: 28,
    ),
    SurahInfo(
      number: 67,
      englishName: 'Al-Mulk',
      arabicName: 'الملك',
      startJuz: 29,
    ),
    SurahInfo(
      number: 68,
      englishName: 'Al-Qalam',
      arabicName: 'القلم',
      startJuz: 29,
    ),
    SurahInfo(
      number: 69,
      englishName: 'Al-Haqqah',
      arabicName: 'الحاقة',
      startJuz: 29,
    ),
    SurahInfo(
      number: 70,
      englishName: "Al-Ma'arij",
      arabicName: 'المعارج',
      startJuz: 29,
    ),
    SurahInfo(number: 71, englishName: 'Nuh', arabicName: 'نوح', startJuz: 29),
    SurahInfo(
      number: 72,
      englishName: 'Al-Jinn',
      arabicName: 'الجن',
      startJuz: 29,
    ),
    SurahInfo(
      number: 73,
      englishName: 'Al-Muzzammil',
      arabicName: 'المزمل',
      startJuz: 29,
    ),
    SurahInfo(
      number: 74,
      englishName: 'Al-Muddaththir',
      arabicName: 'المدثر',
      startJuz: 29,
    ),
    SurahInfo(
      number: 75,
      englishName: 'Al-Qiyamah',
      arabicName: 'القيامة',
      startJuz: 29,
    ),
    SurahInfo(
      number: 76,
      englishName: 'Al-Insan',
      arabicName: 'الإنسان',
      startJuz: 29,
    ),
    SurahInfo(
      number: 77,
      englishName: 'Al-Mursalat',
      arabicName: 'المرسلات',
      startJuz: 29,
    ),
    SurahInfo(
      number: 78,
      englishName: 'An-Naba',
      arabicName: 'النبأ',
      startJuz: 30,
    ),
    SurahInfo(
      number: 79,
      englishName: "An-Nazi'at",
      arabicName: 'النازعات',
      startJuz: 30,
    ),
    SurahInfo(
      number: 80,
      englishName: 'Abasa',
      arabicName: 'عبس',
      startJuz: 30,
    ),
    SurahInfo(
      number: 81,
      englishName: 'At-Takwir',
      arabicName: 'التكوير',
      startJuz: 30,
    ),
    SurahInfo(
      number: 82,
      englishName: 'Al-Infitar',
      arabicName: 'الإنفطار',
      startJuz: 30,
    ),
    SurahInfo(
      number: 83,
      englishName: 'Al-Mutaffifin',
      arabicName: 'المطففين',
      startJuz: 30,
    ),
    SurahInfo(
      number: 84,
      englishName: 'Al-Inshiqaq',
      arabicName: 'الإنشقاق',
      startJuz: 30,
    ),
    SurahInfo(
      number: 85,
      englishName: 'Al-Buruj',
      arabicName: 'البروج',
      startJuz: 30,
    ),
    SurahInfo(
      number: 86,
      englishName: 'At-Tariq',
      arabicName: 'الطارق',
      startJuz: 30,
    ),
    SurahInfo(
      number: 87,
      englishName: "Al-A'la",
      arabicName: 'الأعلى',
      startJuz: 30,
    ),
    SurahInfo(
      number: 88,
      englishName: 'Al-Ghashiyah',
      arabicName: 'الغاشية',
      startJuz: 30,
    ),
    SurahInfo(
      number: 89,
      englishName: 'Al-Fajr',
      arabicName: 'الفجر',
      startJuz: 30,
    ),
    SurahInfo(
      number: 90,
      englishName: 'Al-Balad',
      arabicName: 'البلد',
      startJuz: 30,
    ),
    SurahInfo(
      number: 91,
      englishName: 'Ash-Shams',
      arabicName: 'الشمس',
      startJuz: 30,
    ),
    SurahInfo(
      number: 92,
      englishName: 'Al-Layl',
      arabicName: 'الليل',
      startJuz: 30,
    ),
    SurahInfo(
      number: 93,
      englishName: 'Ad-Duha',
      arabicName: 'الضحى',
      startJuz: 30,
    ),
    SurahInfo(
      number: 94,
      englishName: 'Ash-Sharh',
      arabicName: 'الشرح',
      startJuz: 30,
    ),
    SurahInfo(
      number: 95,
      englishName: 'At-Tin',
      arabicName: 'التين',
      startJuz: 30,
    ),
    SurahInfo(
      number: 96,
      englishName: 'Al-Alaq',
      arabicName: 'العلق',
      startJuz: 30,
    ),
    SurahInfo(
      number: 97,
      englishName: 'Al-Qadr',
      arabicName: 'القدر',
      startJuz: 30,
    ),
    SurahInfo(
      number: 98,
      englishName: 'Al-Bayyinah',
      arabicName: 'البينة',
      startJuz: 30,
    ),
    SurahInfo(
      number: 99,
      englishName: 'Az-Zalzalah',
      arabicName: 'الزلزلة',
      startJuz: 30,
    ),
    SurahInfo(
      number: 100,
      englishName: 'Al-Adiyat',
      arabicName: 'العاديات',
      startJuz: 30,
    ),
    SurahInfo(
      number: 101,
      englishName: "Al-Qari'ah",
      arabicName: 'القارعة',
      startJuz: 30,
    ),
    SurahInfo(
      number: 102,
      englishName: 'At-Takathur',
      arabicName: 'التكاثر',
      startJuz: 30,
    ),
    SurahInfo(
      number: 103,
      englishName: 'Al-Asr',
      arabicName: 'العصر',
      startJuz: 30,
    ),
    SurahInfo(
      number: 104,
      englishName: 'Al-Humazah',
      arabicName: 'الهمزة',
      startJuz: 30,
    ),
    SurahInfo(
      number: 105,
      englishName: 'Al-Fil',
      arabicName: 'الفيل',
      startJuz: 30,
    ),
    SurahInfo(
      number: 106,
      englishName: 'Quraysh',
      arabicName: 'قريش',
      startJuz: 30,
    ),
    SurahInfo(
      number: 107,
      englishName: "Al-Ma'un",
      arabicName: 'الماعون',
      startJuz: 30,
    ),
    SurahInfo(
      number: 108,
      englishName: 'Al-Kawthar',
      arabicName: 'الكوثر',
      startJuz: 30,
    ),
    SurahInfo(
      number: 109,
      englishName: 'Al-Kafirun',
      arabicName: 'الكافرون',
      startJuz: 30,
    ),
    SurahInfo(
      number: 110,
      englishName: 'An-Nasr',
      arabicName: 'النصر',
      startJuz: 30,
    ),
    SurahInfo(
      number: 111,
      englishName: 'Al-Masad',
      arabicName: 'المسد',
      startJuz: 30,
    ),
    SurahInfo(
      number: 112,
      englishName: 'Al-Ikhlas',
      arabicName: 'الإخلاص',
      startJuz: 30,
    ),
    SurahInfo(
      number: 113,
      englishName: 'Al-Falaq',
      arabicName: 'الفلق',
      startJuz: 30,
    ),
    SurahInfo(
      number: 114,
      englishName: 'An-Nas',
      arabicName: 'الناس',
      startJuz: 30,
    ),
  ];
}
