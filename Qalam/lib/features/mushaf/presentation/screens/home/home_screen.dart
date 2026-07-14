import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/utils/mushaf_labels.dart';
import '../../common/widgets/qalam_bottom_sheet.dart';
import '../../common/widgets/qalam_menu_tile.dart';
import '../../common/widgets/qalam_screen_shell.dart';
import '../../common/widgets/reader_state_views.dart';
import 'components/bookmark_panel.dart';
import 'components/home_primary_button.dart';
import 'components/page_number_panel.dart';
import 'components/reader_settings_panel.dart';
import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  Future<void> _openGoToPanel() async {
    final session = controller.session;
    final pageController = TextEditingController(
      text: session.source
          .displayPageForPdfPage(session.currentPage)
          .toString(),
    );
    int? page;

    try {
      page = await Get.bottomSheet<int>(
        QalamBottomSheet(
          child: PageNumberPanel(
            source: session.source,
            pageController: pageController,
          ),
        ),
        isScrollControlled: true,
        ignoreSafeArea: false,
      );
    } finally {
      pageController.dispose();
    }

    if (page != null) {
      await controller.openReader(page: page);
    }
  }

  Future<void> _openBookmarksPanel() async {
    final session = controller.session;
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
      await controller.openReader(page: page);
    }
  }

  Future<void> _openSettingsPanel() async {
    final session = controller.session;
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

  @override
  Widget build(BuildContext context) {
    final session = controller.session;

    return Obx(() {
      final error = session.loadError;
      if (error != null) {
        return Scaffold(body: ReaderErrorView(message: error.toString()));
      }

      if (!session.isReady) {
        return const Scaffold(body: ReaderLoadingView());
      }

      final source = session.source;
      final nightMode = session.nightMode;

      return QalamScreenShell(
        title: '${source.lineCount}-Line Quran',
        subtitle:
            '${displayPageLabel(source, session.currentPage)} - Para ${session.currentJuz.number}',
        nightMode: nightMode,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isWide ? 40 : 20,
                18,
                isWide ? 40 : 20,
                28,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 860),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomePrimaryButton(
                        title: 'Continue Reading',
                        subtitle:
                            '${displayPageLabel(source, session.currentPage)} - Para ${session.currentJuz.number}',
                        icon: Icons.menu_book_outlined,
                        nightMode: nightMode,
                        onTap: () => unawaited(
                          controller.openReader(page: session.currentPage),
                        ),
                      ),
                      const SizedBox(height: 18),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isWide ? 3 : 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: isWide ? 1.55 : 1.18,
                        children: [
                          QalamMenuTile(
                            title: 'BookMark',
                            subtitle: '${session.bookmarks.length} saved',
                            icon: Icons.bookmark_border,
                            nightMode: nightMode,
                            onTap: () => unawaited(_openBookmarksPanel()),
                          ),
                          QalamMenuTile(
                            title: 'Para Index',
                            subtitle: 'Browse 30 Para',
                            icon: Icons.explore_outlined,
                            nightMode: nightMode,
                            onTap: () => unawaited(controller.openJuzIndex()),
                          ),
                          QalamMenuTile(
                            title: 'Surah Index',
                            subtitle: 'Browse Surahs',
                            icon: Icons.format_list_bulleted,
                            nightMode: nightMode,
                            onTap: () => unawaited(controller.openSurahIndex()),
                          ),
                          QalamMenuTile(
                            title: 'Page #',
                            subtitle: 'Go directly',
                            icon: Icons.numbers_outlined,
                            nightMode: nightMode,
                            onTap: () => unawaited(_openGoToPanel()),
                          ),
                          QalamMenuTile(
                            title: 'Setting',
                            subtitle: nightMode ? 'Night mode' : 'Light mode',
                            icon: Icons.settings_outlined,
                            nightMode: nightMode,
                            onTap: () => unawaited(_openSettingsPanel()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
