import 'package:get/get.dart';

import '../../common/controllers/mushaf_session_controller.dart';

class JuzIndexController extends GetxController {
  JuzIndexController(this.session);

  final MushafSessionController session;

  void selectPage(int page) {
    Get.back<int>(result: page);
  }
}
