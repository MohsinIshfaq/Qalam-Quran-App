import 'dart:async';

import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';

import '../services/mushaf_pdf_cache.dart';
import 'mushaf_reader_controller.dart';

class MushafPdfController extends GetxController {
  MushafPdfController(this.reader, this.initialPage);

  final MushafReaderController reader;
  final int? initialPage;

  final Rxn<PdfController> _pdfController = Rxn<PdfController>();
  final Rxn<Object> _loadError = Rxn<Object>();

  PdfController? get pdfController => _pdfController.value;

  Object? get loadError => _loadError.value ?? reader.loadError;

  bool get isReady => reader.isReady && pdfController != null;

  @override
  void onInit() {
    super.onInit();
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    await reader.load();

    if (reader.loadError != null || isClosed) {
      return;
    }

    final requestedPage = initialPage;
    if (requestedPage != null) {
      reader.setPage(requestedPage);
    }

    final controller = PdfController(
      document: MushafPdfCache.open(reader.source),
      initialPage: reader.currentPage,
      viewportFraction: 1,
    );

    if (isClosed) {
      controller.dispose();
      return;
    }

    _pdfController.value = controller;
  }

  void reportDocumentError(Object error) {
    _loadError.value = error;
  }

  @override
  void onClose() {
    _pdfController.value?.dispose();
    super.onClose();
  }
}
