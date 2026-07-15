import 'package:get/get.dart';

import '../../common/controllers/mushaf_session_controller.dart';
import '../../common/utils/mushaf_labels.dart';

class JuzIndexController extends GetxController {
  JuzIndexController(this.session);

  final MushafSessionController session;

  String get title => 'Para';

  String get subtitle => 'Select Para';

  late final List<ParaIndexItem> items = List<ParaIndexItem>.unmodifiable(
    session.source.juzList.map(
      (juz) => ParaIndexItem(
        number: juz.number,
        englishName: paraEnglishName(juz.number),
        arabicName: paraArabicName(juz.number),
        pageLabel: displayPageLabel(session.source, juz.startPage),
        targetPage: juz.startPage,
      ),
    ),
  );

  void selectPara(ParaIndexItem item) {
    Get.back<int>(result: item.targetPage);
  }
}

class ParaIndexItem {
  const ParaIndexItem({
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
