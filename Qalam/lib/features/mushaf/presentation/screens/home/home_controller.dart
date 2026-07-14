import 'package:get/get.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../common/controllers/mushaf_session_controller.dart';

class HomeController extends GetxController {
  HomeController(this.session);

  final MushafSessionController session;

  Future<void> openReader({int? page}) async {
    await (Get.toNamed<dynamic>(AppRoutes.reader, arguments: page) ??
        Future<dynamic>.value());
  }

  Future<void> openJuzIndex() async {
    await _openIndex(AppRoutes.juzIndex);
  }

  Future<void> openSurahIndex() async {
    await _openIndex(AppRoutes.surahIndex);
  }

  Future<void> _openIndex(String route) async {
    final result = await Get.toNamed<dynamic>(route);
    if (result is int) {
      await openReader(page: result);
    }
  }
}
