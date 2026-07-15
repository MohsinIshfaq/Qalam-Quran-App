import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/reader_state_views.dart';
import 'components/mushaf_reader_view.dart';
import 'reader_controller.dart';

class ReaderScreen extends GetView<ReaderController> {
  const ReaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final error = controller.loadError;
      if (error != null) {
        return Scaffold(
          backgroundColor: const Color(0xFFFBF7F0),
          body: ReaderErrorView(message: error.toString()),
        );
      }

      final pdfController = controller.pdfController;
      if (!controller.isReady || pdfController == null) {
        return const Scaffold(
          backgroundColor: Color(0xFFFBF7F0),
          body: ReaderLoadingView(),
        );
      }

      return MushafReaderView(
        controller: controller,
        pdfController: pdfController,
      );
    });
  }
}
