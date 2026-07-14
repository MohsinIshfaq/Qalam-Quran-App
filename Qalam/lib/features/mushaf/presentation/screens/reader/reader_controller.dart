import 'dart:async';

import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';

import '../../common/controllers/mushaf_session_controller.dart';
import '../../services/mushaf_pdf_cache.dart';

class ReaderController extends GetxController {
  ReaderController(this.session, this.initialPage);

  final MushafSessionController session;
  final int? initialPage;

  final Rxn<PdfController> _pdfController = Rxn<PdfController>();
  final Rxn<Object> _loadError = Rxn<Object>();

  PdfController? get pdfController => _pdfController.value;

  Object? get loadError => _loadError.value ?? session.loadError;

  bool get isReady => session.isReady && pdfController != null;

  @override
  void onInit() {
    super.onInit();
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    await session.load();

    if (session.loadError != null || isClosed) {
      return;
    }

    final requestedPage = initialPage;
    if (requestedPage != null) {
      session.setPage(requestedPage);
    }

    final controller = PdfController(
      document: MushafPdfCache.open(session.source),
      initialPage: session.currentPage,
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
