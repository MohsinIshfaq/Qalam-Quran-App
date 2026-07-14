import 'package:get/get.dart';

import '../../domain/entities/mushaf_source.dart';
import '../../domain/repositories/mushaf_repository.dart';
import '../common/controllers/mushaf_session_controller.dart';
import '../screens/home/home_controller.dart';
import '../screens/juz_index/juz_index_controller.dart';
import '../screens/line_selection/line_selection_controller.dart';
import '../screens/reader/reader_controller.dart';
import '../screens/surah_index/surah_index_controller.dart';

class LineSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LineSelectionController>(LineSelectionController.new);
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    final source = Get.arguments;
    if (source is! MushafSource) {
      throw StateError('A MushafSource is required to open the Quran menu.');
    }

    Get.lazyPut<MushafSessionController>(
      () => MushafSessionController(source, Get.find<MushafRepository>()),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<MushafSessionController>()),
    );
  }
}

class ReaderBinding extends Bindings {
  @override
  void dependencies() {
    final initialPage = Get.arguments;
    Get.lazyPut<ReaderController>(
      () => ReaderController(
        Get.find<MushafSessionController>(),
        initialPage is int ? initialPage : null,
      ),
    );
  }
}

class JuzIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JuzIndexController>(
      () => JuzIndexController(Get.find<MushafSessionController>()),
    );
  }
}

class SurahIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SurahIndexController>(
      () => SurahIndexController(Get.find<MushafSessionController>()),
    );
  }
}
