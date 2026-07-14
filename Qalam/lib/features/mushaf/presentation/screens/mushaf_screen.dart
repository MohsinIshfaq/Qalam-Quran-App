import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';

import '../../../../app/routes/app_routes.dart';
import '../../domain/entities/mushaf_source.dart';
import '../controllers/mushaf_pdf_controller.dart';
import '../controllers/mushaf_reader_controller.dart';
import '../controllers/mushaf_selection_controller.dart';
import '../services/mushaf_pdf_cache.dart';

String _paraArabicName(int number) {
  return switch (number) {
    1 => 'الم',
    2 => 'سيقول',
    3 => 'تلك الرسل',
    4 => 'لن تنالوا',
    5 => 'والمحصنات',
    6 => 'لا يحب الله',
    7 => 'وإذا سمعوا',
    8 => 'ولو أننا',
    9 => 'قال الملأ',
    10 => 'واعلموا',
    11 => 'يعتذرون',
    12 => 'وما من دابة',
    13 => 'وما أبرئ',
    14 => 'ربما',
    15 => 'سبحان الذي',
    16 => 'قال ألم',
    17 => 'اقترب للناس',
    18 => 'قد أفلح',
    19 => 'وقال الذين',
    20 => 'أمن خلق',
    21 => 'اتل ما أوحي',
    22 => 'ومن يقنت',
    23 => 'وما لي',
    24 => 'فمن أظلم',
    25 => 'إليه يرد',
    26 => 'حم',
    27 => 'قال فما خطبكم',
    28 => 'قد سمع الله',
    29 => 'تبارك الذي',
    30 => 'عم يتساءلون',
    _ => 'Para $number',
  };
}

String _paraEnglishName(int number) {
  return switch (number) {
    1 => 'Alif Lam Meem',
    2 => 'Sayaqool',
    3 => 'Tilka Rusul',
    4 => 'Lan Tanaaloo',
    5 => 'Wal Mohsanat',
    6 => 'La Yuhibbullah',
    7 => 'Wa Iza Samiu',
    8 => 'Wa Lau Annana',
    9 => 'Qalal Mala',
    10 => 'Wa Alamu',
    11 => 'Yatazeroon',
    12 => 'Wa Ma Min Daabbah',
    13 => 'Wa Ma Ubarriu',
    14 => 'Rubama',
    15 => 'Subhanallazi',
    16 => 'Qal Alam',
    17 => 'Iqtaraba Linnaas',
    18 => 'Qad Aflaha',
    19 => 'Wa Qalallazina',
    20 => 'Aman Khalaq',
    21 => 'Utlu Ma Oohi',
    22 => 'Wa Manyaqnut',
    23 => 'Wa Mali',
    24 => 'Faman Azlam',
    25 => 'Ilaihi Yuraddu',
    26 => 'Ha Meem',
    27 => 'Qala Fama Khatbukum',
    28 => 'Qad Sami Allah',
    29 => 'Tabarakallazi',
    30 => 'Amma Yatasaaloon',
    _ => 'Para $number',
  };
}

String _displayPageLabel(MushafSource source, int pdfPage) {
  return 'Page ${source.displayPageForPdfPage(pdfPage)}';
}

class MushafLineSelectionScreen extends GetView<MushafSelectionController> {
  const MushafLineSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nightMode =
        Theme.of(context).colorScheme.brightness == Brightness.dark;

    return _QalamScreenShell(
      title: 'Qalam',
      subtitle: 'Select Quran line format',
      nightMode: nightMode,
      showBackButton: false,
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
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isWide ? 3 : 1,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: isWide ? 1.45 : 2.45,
                  children: controller.sources
                      .map((source) {
                        return _MenuTile(
                          title: '${source.lineCount}-Line',
                          subtitle: 'Open Quran',
                          icon: Icons.auto_stories_outlined,
                          nightMode: nightMode,
                          onTap: () => unawaited(controller.openSource(source)),
                        );
                      })
                      .toList(growable: false),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MushafHomeScreen extends GetView<MushafReaderController> {
  const MushafHomeScreen({super.key});

  Future<void> _openReader({int? page}) async {
    await (Get.toNamed<dynamic>(AppRoutes.reader, arguments: page) ??
        Future<dynamic>.value());
  }

  Future<void> _openGoToPanel() async {
    final pageController = TextEditingController(
      text: controller.source
          .displayPageForPdfPage(controller.currentPage)
          .toString(),
    );
    int? page;
    try {
      page = await Get.bottomSheet<int>(
        _QalamBottomSheet(
          child: _PageNumberPanel(
            source: controller.source,
            pageController: pageController,
          ),
        ),
        isScrollControlled: true,
        ignoreSafeArea: false,
      );
    } finally {
      pageController.dispose();
    }

    if (page == null) {
      return;
    }

    await _openReader(page: page);
  }

  Future<void> _openJuzIndexScreen() async {
    final result = await Get.toNamed<dynamic>(AppRoutes.juzIndex);
    final page = result is int ? result : null;

    if (page == null) {
      return;
    }

    await _openReader(page: page);
  }

  Future<void> _openSurahIndexScreen() async {
    final result = await Get.toNamed<dynamic>(AppRoutes.surahIndex);
    final page = result is int ? result : null;

    if (page == null) {
      return;
    }

    await _openReader(page: page);
  }

  Future<void> _openBookmarksPanel() async {
    final page = await Get.bottomSheet<int>(
      _QalamBottomSheet(
        child: Obx(
          () => BookmarkPanel(
            source: controller.source,
            bookmarks: controller.bookmarks,
          ),
        ),
      ),
      ignoreSafeArea: false,
    );

    if (page == null) {
      return;
    }

    await _openReader(page: page);
  }

  Future<void> _openSettingsPanel() async {
    await Get.bottomSheet<void>(
      _QalamBottomSheet(
        child: Obx(
          () => _ReaderSettingsPanel(
            source: controller.source,
            currentPage: controller.currentPage,
            currentJuz: controller.currentJuz,
            nightMode: controller.nightMode,
            isBookmarked: controller.isCurrentPageBookmarked,
            onToggleNightMode: () => unawaited(controller.toggleNightMode()),
            onToggleBookmark: () =>
                unawaited(controller.toggleCurrentBookmark()),
          ),
        ),
      ),
      ignoreSafeArea: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final error = controller.loadError;
      if (error != null) {
        return Scaffold(body: _ReaderErrorView(message: error.toString()));
      }

      if (!controller.isReady) {
        return const Scaffold(body: _ReaderLoadingView());
      }

      final source = controller.source;
      final nightMode = controller.nightMode;
      return _QalamScreenShell(
        title: '${source.lineCount}-Line Quran',
        subtitle:
            '${_displayPageLabel(source, controller.currentPage)} - Para ${controller.currentJuz.number}',
        nightMode: nightMode,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;
            final gridColumns = isWide ? 3 : 2;

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
                      _MenuPrimaryButton(
                        title: 'Continue Reading',
                        subtitle:
                            '${_displayPageLabel(source, controller.currentPage)} - Para ${controller.currentJuz.number}',
                        icon: Icons.menu_book_outlined,
                        nightMode: nightMode,
                        onTap: () => unawaited(
                          _openReader(page: controller.currentPage),
                        ),
                      ),
                      const SizedBox(height: 18),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: gridColumns,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: isWide ? 1.55 : 1.18,
                        children: [
                          _MenuTile(
                            title: 'BookMark',
                            subtitle: '${controller.bookmarks.length} saved',
                            icon: Icons.bookmark_border,
                            nightMode: nightMode,
                            onTap: () => unawaited(_openBookmarksPanel()),
                          ),
                          _MenuTile(
                            title: 'Para Index',
                            subtitle: 'Browse 30 Para',
                            icon: Icons.explore_outlined,
                            nightMode: nightMode,
                            onTap: () => unawaited(_openJuzIndexScreen()),
                          ),
                          _MenuTile(
                            title: 'Surah Index',
                            subtitle: 'Browse Surahs',
                            icon: Icons.format_list_bulleted,
                            nightMode: nightMode,
                            onTap: () => unawaited(_openSurahIndexScreen()),
                          ),
                          _MenuTile(
                            title: 'Page #',
                            subtitle: 'Go directly',
                            icon: Icons.numbers_outlined,
                            nightMode: nightMode,
                            onTap: () => unawaited(_openGoToPanel()),
                          ),
                          _MenuTile(
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

class _MenuPrimaryButton extends StatelessWidget {
  const _MenuPrimaryButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.nightMode,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool nightMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: nightMode
                ? const [Color(0xFF0B5B4C), Color(0xFF073B33)]
                : const [Color(0xFF096E5C), Color(0xFF064C40)],
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF075E4F).withValues(alpha: 0.24),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFFFFF7E8), size: 34),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(0xFFFFF7E8),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFE4D6BA),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFFFFF7E8),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.nightMode,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool nightMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final baseColor = nightMode
        ? const Color(0xFF121B17)
        : const Color(0xFFFFFCF5);
    final borderColor = nightMode
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFD9C8AA).withValues(alpha: 0.72);
    final titleColor = nightMode
        ? const Color(0xFFEAF5EF)
        : const Color(0xFF21312B);
    final subtitleColor = nightMode
        ? const Color(0xFFAABBB3)
        : const Color(0xFF6F6250);
    final accentColor = nightMode
        ? const Color(0xFF72D4BF)
        : const Color(0xFF075E4F);
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: nightMode ? 0.18 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: accentColor, size: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: titleColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: subtitleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MushafScreen extends GetView<MushafPdfController> {
  const MushafScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final error = controller.loadError;
      if (error != null) {
        return Scaffold(body: _ReaderErrorView(message: error.toString()));
      }

      final pdfController = controller.pdfController;
      if (!controller.isReady || pdfController == null) {
        return const Scaffold(body: _ReaderLoadingView());
      }

      return _MushafReaderView(
        controller: controller,
        pdfController: pdfController,
      );
    });
  }

  static PhotoViewGalleryPageOptions buildPdfPage(
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

class _MushafReaderView extends StatelessWidget {
  const _MushafReaderView({
    required this.controller,
    required this.pdfController,
  });

  final MushafPdfController controller;
  final PdfController pdfController;

  @override
  Widget build(BuildContext context) {
    final reader = controller.reader;
    final source = reader.source;
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
                  pageBuilder: MushafScreen.buildPdfPage,
                  documentLoaderBuilder: (_) => const _ReaderLoadingView(),
                  pageLoaderBuilder: (_) => const _ReaderLoadingView(),
                ),
                onDocumentLoaded: (document) {
                  if (document.pagesCount != source.totalPages) {
                    debugPrint(
                      'Expected ${source.totalPages} pages, '
                      'loaded ${document.pagesCount}.',
                    );
                  }
                },
                onPageChanged: reader.setPage,
                onDocumentError: controller.reportDocumentError,
              ),
            );
          },
        );
      },
    );

    return Obx(() {
      return _QalamScreenShell(
        title: _displayPageLabel(source, reader.currentPage),
        subtitle:
            '${source.lineCount}-Line Quran - Para ${reader.currentJuz.number}',
        nightMode: reader.nightMode,
        backgroundColor: reader.nightMode
            ? const Color(0xFF07100D)
            : const Color(0xFFF2EADA),
        child: Stack(
          fit: StackFit.expand,
          children: [
            pdfView,
            if (reader.nightMode)
              const IgnorePointer(child: ColoredBox(color: Color(0x33000000))),
          ],
        ),
      );
    });
  }
}

class _QalamBottomSheet extends StatelessWidget {
  const _QalamBottomSheet({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _PageNumberPanel extends StatelessWidget {
  const _PageNumberPanel({required this.source, required this.pageController});

  final MushafSource source;
  final TextEditingController pageController;

  void _submitDirectPage() {
    final page = int.tryParse(pageController.text);

    if (page == null) {
      return;
    }

    Get.back<int>(result: source.pdfPageForDisplayPage(page));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        18,
        0,
        18,
        18 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Page #', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _DirectPageTab(
            controller: pageController,
            firstPage: source.firstDisplayPage,
            lastPage: source.lastDisplayPage,
            onSubmit: _submitDirectPage,
          ),
        ],
      ),
    );
  }
}

class JuzIndexScreen extends GetView<MushafReaderController> {
  const JuzIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final source = controller.source;
    final nightMode = controller.nightMode;

    return _QalamScreenShell(
      title: 'Para',
      subtitle: 'Select Para',
      nightMode: nightMode,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 720;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  isWide ? 40 : 18,
                  18,
                  isWide ? 40 : 18,
                  24,
                ),
                itemCount: source.juzList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final juz = source.juzList[index];
                  final arabicName = _paraArabicName(juz.number);
                  final englishName = _paraEnglishName(juz.number);

                  return _ParaMenuTile(
                    number: juz.number,
                    englishName: englishName,
                    arabicName: arabicName,
                    subtitle: _displayPageLabel(source, juz.startPage),
                    nightMode: nightMode,
                    onTap: () => Get.back<int>(result: juz.startPage),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QalamScreenShell extends StatelessWidget {
  const _QalamScreenShell({
    required this.title,
    required this.subtitle,
    required this.nightMode,
    required this.child,
    this.showBackButton = true,
    this.backgroundColor,
  });

  final String title;
  final String subtitle;
  final bool nightMode;
  final Widget child;
  final bool showBackButton;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          backgroundColor ??
          (nightMode ? const Color(0xFF07100D) : const Color(0xFFF5F1E8)),
      body: SafeArea(
        child: Column(
          children: [
            _QalamHeader(
              title: title,
              subtitle: subtitle,
              nightMode: nightMode,
              showBackButton: showBackButton,
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _QalamHeader extends StatelessWidget {
  const _QalamHeader({
    required this.title,
    required this.subtitle,
    required this.nightMode,
    this.showBackButton = true,
  });

  final String title;
  final String subtitle;
  final bool nightMode;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final titleColor = nightMode
        ? const Color(0xFFEAF5EF)
        : const Color(0xFF075E4F);
    final subtitleColor = nightMode
        ? const Color(0xFFB8C9C1)
        : const Color(0xFF625747);
    final borderColor = nightMode
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFD9C8AA).withValues(alpha: 0.72);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: nightMode ? const Color(0xEE0A120F) : const Color(0xEEFFFCF5),
        border: Border(bottom: BorderSide(color: borderColor)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: nightMode ? 0.2 : 0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 7, 12, 7),
        child: Row(
          children: [
            if (showBackButton) ...[
              IconButton(
                tooltip: 'Back',
                onPressed: Get.back<void>,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                style: IconButton.styleFrom(
                  fixedSize: const Size.square(40),
                  foregroundColor: titleColor,
                  backgroundColor: nightMode
                      ? Colors.white.withValues(alpha: 0.07)
                      : Colors.white.withValues(alpha: 0.72),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: subtitleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurahIndexScreen extends GetView<MushafReaderController> {
  const SurahIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final source = controller.source;
    final nightMode = controller.nightMode;

    return _QalamScreenShell(
      title: 'Surah',
      subtitle: 'Select Surah',
      nightMode: nightMode,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 720;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  isWide ? 40 : 18,
                  18,
                  isWide ? 40 : 18,
                  24,
                ),
                itemCount: source.surahList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final surah = source.surahList[index];
                  final verifiedPage = surah.verifiedStartPage;
                  final fallbackPage = source.pageForJuz(surah.startJuz);
                  final targetPage = verifiedPage ?? fallbackPage;

                  return _SurahMenuTile(
                    number: surah.number,
                    englishName: surah.englishName,
                    arabicName: surah.arabicName,
                    subtitle: verifiedPage == null
                        ? 'Para ${surah.startJuz}'
                        : _displayPageLabel(source, verifiedPage),
                    nightMode: nightMode,
                    onTap: () => Get.back<int>(result: targetPage),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ParaMenuTile extends StatelessWidget {
  const _ParaMenuTile({
    required this.number,
    required this.englishName,
    required this.arabicName,
    required this.subtitle,
    required this.nightMode,
    required this.onTap,
  });

  final int number;
  final String englishName;
  final String arabicName;
  final String subtitle;
  final bool nightMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final baseColor = nightMode
        ? const Color(0xFF121B17)
        : const Color(0xFFFFFCF5);
    final borderColor = nightMode
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFD9C8AA).withValues(alpha: 0.72);
    final accentColor = nightMode
        ? const Color(0xFF72D4BF)
        : const Color(0xFF075E4F);
    final titleColor = nightMode
        ? const Color(0xFFEAF5EF)
        : const Color(0xFF21312B);
    final subtitleColor = nightMode
        ? const Color(0xFFAABBB3)
        : const Color(0xFF6F6250);

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: nightMode ? 0.16 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 21,
                  backgroundColor: accentColor.withValues(alpha: 0.12),
                  child: Text(
                    number.toString(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Para $number',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        englishName,
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: subtitleColor,
                          fontWeight: FontWeight.w600,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: subtitleColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 132),
                  child: Text(
                    arabicName,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.end,
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SurahMenuTile extends StatelessWidget {
  const _SurahMenuTile({
    required this.number,
    required this.englishName,
    required this.arabicName,
    required this.subtitle,
    required this.nightMode,
    required this.onTap,
  });

  final int number;
  final String englishName;
  final String arabicName;
  final String subtitle;
  final bool nightMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final baseColor = nightMode
        ? const Color(0xFF121B17)
        : const Color(0xFFFFFCF5);
    final borderColor = nightMode
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFD9C8AA).withValues(alpha: 0.72);
    final accentColor = nightMode
        ? const Color(0xFF72D4BF)
        : const Color(0xFF075E4F);
    final titleColor = nightMode
        ? const Color(0xFFEAF5EF)
        : const Color(0xFF21312B);
    final subtitleColor = nightMode
        ? const Color(0xFFAABBB3)
        : const Color(0xFF6F6250);

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: nightMode ? 0.16 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: accentColor.withValues(alpha: 0.12),
                  child: Text(
                    number.toString(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        englishName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: subtitleColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  arabicName,
                  textDirection: TextDirection.rtl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DirectPageTab extends StatelessWidget {
  const _DirectPageTab({
    required this.controller,
    required this.firstPage,
    required this.lastPage,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final int firstPage;
  final int lastPage;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                labelText: 'Page number',
                suffixText: '$firstPage-$lastPage',
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => onSubmit(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onSubmit,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Go'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookmarkPanel extends StatelessWidget {
  const BookmarkPanel({
    required this.source,
    required this.bookmarks,
    super.key,
  });

  final MushafSource source;
  final List<int> bookmarks;

  @override
  Widget build(BuildContext context) {
    if (bookmarks.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text('No bookmarks yet')),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: bookmarks.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final page = bookmarks[index];
        final juz = source.juzForPage(page);

        return ListTile(
          onTap: () => Get.back<int>(result: page),
          leading: const Icon(Icons.bookmark),
          title: Text(_displayPageLabel(source, page)),
          subtitle: Text('Para ${juz.number}'),
          trailing: const Icon(Icons.chevron_right),
        );
      },
    );
  }
}

class _ReaderSettingsPanel extends StatelessWidget {
  const _ReaderSettingsPanel({
    required this.source,
    required this.currentPage,
    required this.currentJuz,
    required this.nightMode,
    required this.isBookmarked,
    required this.onToggleNightMode,
    required this.onToggleBookmark,
  });

  final MushafSource source;
  final int currentPage;
  final JuzInfo currentJuz;
  final bool nightMode;
  final bool isBookmarked;
  final VoidCallback onToggleNightMode;
  final VoidCallback onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Setting', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.menu_book_outlined, color: colorScheme.primary),
            title: Text(_displayPageLabel(source, currentPage)),
            subtitle: Text('Para ${currentJuz.number}'),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Night mode'),
            value: nightMode,
            onChanged: (_) => onToggleNightMode(),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? colorScheme.primary : null,
            ),
            title: Text(isBookmarked ? 'Remove bookmark' : 'Bookmark page'),
            onTap: onToggleBookmark,
          ),
        ],
      ),
    );
  }
}

class _ReaderLoadingView extends StatelessWidget {
  const _ReaderLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox.square(dimension: 36, child: CircularProgressIndicator()),
    );
  }
}

class _ReaderErrorView extends StatelessWidget {
  const _ReaderErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.picture_as_pdf_outlined,
                size: 42,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Unable to load Mushaf PDF',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
