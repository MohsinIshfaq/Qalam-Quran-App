import 'package:get/get.dart';

import '../../domain/entities/mushaf_source.dart';
import '../../domain/repositories/mushaf_repository.dart';
import '../controllers/mushaf_pdf_controller.dart';
import '../controllers/mushaf_reader_controller.dart';
import '../controllers/mushaf_selection_controller.dart';

class MushafSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MushafSelectionController>(MushafSelectionController.new);
  }
}

class MushafBinding extends Bindings {
  @override
  void dependencies() {
    final source = Get.arguments;
    if (source is! MushafSource) {
      throw StateError('A MushafSource is required to open the Quran menu.');
    }

    Get.lazyPut<MushafReaderController>(
      () => MushafReaderController(source, Get.find<MushafRepository>()),
    );
  }
}

class MushafPdfBinding extends Bindings {
  @override
  void dependencies() {
    final initialPage = Get.arguments;
    Get.lazyPut<MushafPdfController>(
      () => MushafPdfController(
        Get.find<MushafReaderController>(),
        initialPage is int ? initialPage : null,
      ),
    );
  }
}
