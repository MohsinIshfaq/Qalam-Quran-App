import 'dart:async';

import 'package:get/get.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../common/controllers/mushaf_session_controller.dart';
import '../../common/utils/mushaf_labels.dart';
import '../../common/widgets/qalam_bottom_sheet.dart';
import 'components/bookmark_panel.dart';
import 'components/page_number_panel.dart';
import 'components/reader_settings_panel.dart';

class HomeController extends GetxController {
  HomeController(this.session);

  final MushafSessionController session;
  bool _isPagePickerOpen = false;

  String get title => '${session.source.lineCount}-Line Quran';

  String get currentLocation =>
      '${displayPageLabel(session.source, session.currentPage)} - '
      'Para ${session.currentJuz.number}';

  String get settingsMode => session.nightMode ? 'Night mode' : 'Light mode';

  double get readingProgress {
    final source = session.source;
    final readablePages = source.lastReadablePage - source.firstReadablePage;
    if (readablePages <= 0) {
      return 0;
    }

    return (session.currentPage - source.firstReadablePage) / readablePages;
  }

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

  Future<void> openPagePicker() async {
    if (_isPagePickerOpen) {
      return;
    }

    _isPagePickerOpen = true;
    final source = session.source;
    int? page;

    try {
      page = await Get.bottomSheet<int>(
        QalamBottomSheet(
          child: PageNumberPanel(
            source: source,
            initialPage: source.displayPageForPdfPage(session.currentPage),
          ),
        ),
        isScrollControlled: true,
        ignoreSafeArea: false,
      );
    } finally {
      _isPagePickerOpen = false;
    }

    if (page != null && !isClosed) {
      await openReader(page: page);
    }
  }

  Future<void> openBookmarks() async {
    final page = await Get.bottomSheet<int>(
      QalamBottomSheet(
        child: Obx(
          () => BookmarkPanel(
            source: session.source,
            bookmarks: session.bookmarks,
          ),
        ),
      ),
      ignoreSafeArea: false,
    );

    if (page != null) {
      await openReader(page: page);
    }
  }

  Future<void> openSettings() async {
    await Get.bottomSheet<void>(
      QalamBottomSheet(
        child: Obx(
          () => ReaderSettingsPanel(
            source: session.source,
            currentPage: session.currentPage,
            currentJuz: session.currentJuz,
            nightMode: session.nightMode,
            isBookmarked: session.isCurrentPageBookmarked,
            onToggleNightMode: () => unawaited(session.toggleNightMode()),
            onToggleBookmark: () => unawaited(session.toggleCurrentBookmark()),
          ),
        ),
      ),
      ignoreSafeArea: false,
    );
  }

  Future<void> _openIndex(String route) async {
    final result = await Get.toNamed<dynamic>(route);
    if (result is int) {
      await openReader(page: result);
    }
  }
}
