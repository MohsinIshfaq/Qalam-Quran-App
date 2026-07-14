import '../../../domain/entities/mushaf_source.dart';

String displayPageLabel(MushafSource source, int pdfPage) {
  return 'Page ${source.displayPageForPdfPage(pdfPage)}';
}

String paraArabicName(int number) {
  return switch (number) {
    1 => 'الم',
    2 => 'سيقول',
    3 => 'تلك الرسل',
    4 => 'لن تنالوا',
    5 => 'والمحصنات',
    6 => 'لا يحب الله',
    7 => 'وإذا سمعوا',
    8 => 'ولو أننا',
    9 => 'قال الملأ',
    10 => 'واعلموا',
    11 => 'يعتذرون',
    12 => 'وما من دابة',
    13 => 'وما أبرئ',
    14 => 'ربما',
    15 => 'سبحان الذي',
    16 => 'قال ألم',
    17 => 'اقترب للناس',
    18 => 'قد أفلح',
    19 => 'وقال الذين',
    20 => 'أمن خلق',
    21 => 'اتل ما أوحي',
    22 => 'ومن يقنت',
    23 => 'وما لي',
    24 => 'فمن أظلم',
    25 => 'إليه يرد',
    26 => 'حم',
    27 => 'قال فما خطبكم',
    28 => 'قد سمع الله',
    29 => 'تبارك الذي',
    30 => 'عم يتساءلون',
    _ => 'Para $number',
  };
}

String paraEnglishName(int number) {
  return switch (number) {
    1 => 'Alif Lam Meem',
    2 => 'Sayaqool',
    3 => 'Tilka Rusul',
    4 => 'Lan Tanaaloo',
    5 => 'Wal Mohsanat',
    6 => 'La Yuhibbullah',
    7 => 'Wa Iza Samiu',
    8 => 'Wa Lau Annana',
    9 => 'Qalal Mala',
    10 => 'Wa Alamu',
    11 => 'Yatazeroon',
    12 => 'Wa Ma Min Daabbah',
    13 => 'Wa Ma Ubarriu',
    14 => 'Rubama',
    15 => 'Subhanallazi',
    16 => 'Qal Alam',
    17 => 'Iqtaraba Linnaas',
    18 => 'Qad Aflaha',
    19 => 'Wa Qalallazina',
    20 => 'Aman Khalaq',
    21 => 'Utlu Ma Oohi',
    22 => 'Wa Manyaqnut',
    23 => 'Wa Mali',
    24 => 'Faman Azlam',
    25 => 'Ilaihi Yuraddu',
    26 => 'Ha Meem',
    27 => 'Qala Fama Khatbukum',
    28 => 'Qad Sami Allah',
    29 => 'Tabarakallazi',
    30 => 'Amma Yatasaaloon',
    _ => 'Para $number',
  };
}
