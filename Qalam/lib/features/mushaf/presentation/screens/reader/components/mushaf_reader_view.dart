import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';

import '../../../common/utils/mushaf_labels.dart';
import '../../../common/widgets/qalam_screen_shell.dart';
import '../../../common/widgets/reader_state_views.dart';
import '../../../services/mushaf_pdf_cache.dart';
import '../reader_controller.dart';

class MushafReaderView extends StatelessWidget {
  const MushafReaderView({
    required this.controller,
    required this.pdfController,
    super.key,
  });

  final ReaderController controller;
  final PdfController pdfController;

  @override
  Widget build(BuildContext context) {
    final session = controller.session;
    final source = session.source;
    final pdfView = OrientationBuilder(
      builder: (context, orientation) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 720;
            final horizontalPadding = isTablet ? 56.0 : 8.0;
            final verticalPadding = orientation == Orientation.landscape
                ? 4.0
                : 6.0;
            final viewportSize = Size(
              (constraints.maxWidth - horizontalPadding * 2)
                  .clamp(1.0, double.infinity)
                  .toDouble(),
              (constraints.maxHeight - verticalPadding * 2)
                  .clamp(1.0, double.infinity)
                  .toDouble(),
            );
            final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

            return Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                verticalPadding,
                horizontalPadding,
                verticalPadding,
              ),
              child: PdfView(
                controller: pdfController,
                scrollDirection: Axis.horizontal,
                reverse: true,
                pageSnapping: true,
                renderer: (page) => MushafPdfCache.renderPage(
                  page,
                  viewportSize: viewportSize,
                  devicePixelRatio: devicePixelRatio,
                ),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                builders: PdfViewBuilders<DefaultBuilderOptions>(
                  options: const DefaultBuilderOptions(
                    loaderSwitchDuration: Duration(milliseconds: 120),
                  ),
                  pageBuilder: _buildPdfPage,
                  documentLoaderBuilder: (_) => const ReaderLoadingView(),
                  pageLoaderBuilder: (_) => const ReaderLoadingView(),
                ),
                onDocumentLoaded: (document) {
                  if (document.pagesCount != source.totalPages) {
                    debugPrint(
                      'Expected ${source.totalPages} pages, '
                      'loaded ${document.pagesCount}.',
                    );
                  }
                },
                onPageChanged: session.setPage,
                onDocumentError: controller.reportDocumentError,
              ),
            );
          },
        );
      },
    );

    return Obx(() {
      final nightMode = session.nightMode;
      final backgroundColor = nightMode
          ? const Color(0xFF07100D)
          : const Color(0xFFFBF7F0);

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value:
            (nightMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
                .copyWith(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarColor: backgroundColor,
                  systemNavigationBarIconBrightness: nightMode
                      ? Brightness.light
                      : Brightness.dark,
                ),
        child: QalamScreenShell(
          title: displayPageLabel(source, session.currentPage),
          subtitle:
              '${source.lineCount}-Line Quran - Para ${session.currentJuz.number}',
          nightMode: nightMode,
          backgroundColor: backgroundColor,
          child: Stack(
            fit: StackFit.expand,
            children: [
              pdfView,
              if (nightMode)
                const IgnorePointer(
                  child: ColoredBox(color: Color(0x33000000)),
                ),
            ],
          ),
        ),
      );
    });
  }

  static PhotoViewGalleryPageOptions _buildPdfPage(
    BuildContext context,
    Future<PdfPageImage> pageImage,
    int index,
    PdfDocument document,
  ) {
    return PhotoViewGalleryPageOptions(
      imageProvider: PdfPageImageProvider(pageImage, index, document.id),
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.contained * 4.5,
      initialScale: PhotoViewComputedScale.contained,
      heroAttributes: PhotoViewHeroAttributes(tag: '${document.id}-$index'),
    );
  }
}
