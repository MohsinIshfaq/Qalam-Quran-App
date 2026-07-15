import 'package:get/get.dart';

import '../../common/controllers/mushaf_session_controller.dart';
import '../../common/utils/mushaf_labels.dart';

class SurahIndexController extends GetxController {
  SurahIndexController(this.session);

  final MushafSessionController session;

  String get title => 'Surah';

  String get subtitle => 'Select Surah';

  late final List<SurahIndexItem> items = List<SurahIndexItem>.unmodifiable(
    session.source.surahList.map((surah) {
      final verifiedPage = surah.verifiedStartPage;
      final targetPage =
          verifiedPage ?? session.source.pageForJuz(surah.startJuz);

      return SurahIndexItem(
        number: surah.number,
        englishName: surah.englishName,
        arabicName: surah.arabicName,
        pageLabel: verifiedPage == null
            ? 'Para ${surah.startJuz}'
            : displayPageLabel(session.source, verifiedPage),
        targetPage: targetPage,
      );
    }),
  );

  void selectSurah(SurahIndexItem item) {
    Get.back<int>(result: item.targetPage);
  }
}

class SurahIndexItem {
  const SurahIndexItem({
    required this.number,
    required this.englishName,
    required this.arabicName,
    required this.pageLabel,
    required this.targetPage,
  });

  final int number;
  final String englishName;
  final String arabicName;
  final String pageLabel;
  final int targetPage;
}
