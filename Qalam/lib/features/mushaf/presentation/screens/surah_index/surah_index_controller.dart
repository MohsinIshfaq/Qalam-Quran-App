import 'package:get/get.dart';

import '../../common/controllers/mushaf_session_controller.dart';

class SurahIndexController extends GetxController {
  SurahIndexController(this.session);

  final MushafSessionController session;

  void selectPage(int page) {
    Get.back<int>(result: page);
  }
}
