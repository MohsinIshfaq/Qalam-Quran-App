import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import '../../domain/entities/mushaf_source.dart';
import '../../domain/repositories/mushaf_repository.dart';
import '../controllers/mushaf_reader_controller.dart';

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

class MushafLineSelectionScreen extends StatelessWidget {
  const MushafLineSelectionScreen({
    required this.sources,
    required this.repository,
    super.key,
  });

  final List<MushafSource> sources;
  final MushafRepository repository;

  void _openSource(BuildContext context, MushafSource source) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) {
          return MushafHomeScreen(source: source, repository: repository);
        },
      ),
    );
  }

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
                  children: sources
                      .map((source) {
                        return _MenuTile(
                          title: '${source.lineCount}-Line',
                          subtitle: 'Open Quran',
                          icon: Icons.auto_stories_outlined,
                          nightMode: nightMode,
                          onTap: () => _openSource(context, source),
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

class MushafHomeScreen extends StatefulWidget {
  const MushafHomeScreen({
    required this.source,
    required this.repository,
    super.key,
  });

  final MushafSource source;
  final MushafRepository repository;

  @override
  State<MushafHomeScreen> createState() => _MushafHomeScreenState();
}

class _MushafHomeScreenState extends State<MushafHomeScreen> {
  late final MushafReaderController _reader;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    _reader = MushafReaderController(widget.source, widget.repository);
    unawaited(_loadReader());
  }

  Future<void> _loadReader() async {
    try {
      await _reader.load();

      if (!mounted) {
        return;
      }

      setState(() {});
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loadError = error;
      });
    }
  }

  @override
  void dispose() {
    _reader.dispose();
    super.dispose();
  }

  Future<void> _openReader({int? page}) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) {
          return MushafScreen(
            source: widget.source,
            repository: widget.repository,
            initialPage: page,
          );
        },
      ),
    );

    if (mounted) {
      unawaited(_loadReader());
    }
  }

  Future<void> _openGoToPanel() async {
    final page = await showModalBottomSheet<int>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (context) {
        return _PageNumberPanel(
          source: widget.source,
          currentPage: _reader.currentPage,
        );
      },
    );

    if (!mounted || page == null) {
      return;
    }

    await _openReader(page: page);
  }

  Future<void> _openJuzIndexScreen() async {
    final page = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (context) => JuzIndexScreen(source: widget.source),
      ),
    );

    if (!mounted || page == null) {
      return;
    }

    await _openReader(page: page);
  }

  Future<void> _openSurahIndexScreen() async {
    final page = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (context) => SurahIndexScreen(source: widget.source),
      ),
    );

    if (!mounted || page == null) {
      return;
    }

    await _openReader(page: page);
  }

  Future<void> _openBookmarksPanel() async {
    final page = await showModalBottomSheet<int>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (context) {
        return AnimatedBuilder(
          animation: _reader,
          builder: (context, _) {
            return BookmarkPanel(
              source: widget.source,
              bookmarks: _reader.bookmarks,
            );
          },
        );
      },
    );

    if (!mounted || page == null) {
      return;
    }

    await _openReader(page: page);
  }

  Future<void> _openSettingsPanel() async {
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (context) {
        return AnimatedBuilder(
          animation: _reader,
          builder: (context, _) {
            return _ReaderSettingsPanel(
              currentPage: _reader.currentPage,
              currentJuz: _reader.currentJuz,
              nightMode: _reader.nightMode,
              isBookmarked: _reader.isCurrentPageBookmarked,
              onToggleNightMode: () => unawaited(_reader.toggleNightMode()),
              onToggleBookmark: () =>
                  unawaited(_reader.toggleCurrentBookmark()),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final error = _loadError;

    if (error != null) {
      return Scaffold(body: _ReaderErrorView(message: error.toString()));
    }

    if (!_reader.isReady) {
      return const Scaffold(body: _ReaderLoadingView());
    }

    return AnimatedBuilder(
      animation: _reader,
      builder: (context, _) {
        final nightMode = _reader.nightMode;
        return _QalamScreenShell(
          title: '${widget.source.lineCount}-Line Quran',
          subtitle:
              'Page ${_reader.currentPage} - Para ${_reader.currentJuz.number}',
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
                              'Page ${_reader.currentPage} - Para ${_reader.currentJuz.number}',
                          icon: Icons.menu_book_outlined,
                          nightMode: nightMode,
                          onTap: () =>
                              unawaited(_openReader(page: _reader.currentPage)),
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
                              subtitle: '${_reader.bookmarks.length} saved',
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
      },
    );
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

class MushafScreen extends StatefulWidget {
  const MushafScreen({
    required this.source,
    required this.repository,
    this.initialPage,
    super.key,
  });

  final MushafSource source;
  final MushafRepository repository;
  final int? initialPage;

  @override
  State<MushafScreen> createState() => _MushafScreenState();
}

class _MushafScreenState extends State<MushafScreen> {
  late final MushafReaderController _reader;
  PdfController? _pdfController;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    _reader = MushafReaderController(widget.source, widget.repository);
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    try {
      await _reader.load();
      final initialPage = widget.initialPage;

      if (initialPage != null) {
        await _reader.setPage(initialPage);
      }

      final controller = PdfController(
        document: PdfDocument.openAsset(widget.source.assetPath),
        initialPage: _reader.currentPage,
        viewportFraction: 1,
      );

      if (!mounted) {
        controller.dispose();
        return;
      }

      setState(() {
        _pdfController = controller;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loadError = error;
      });
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    _reader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = _loadError;

    if (error != null) {
      return Scaffold(body: _ReaderErrorView(message: error.toString()));
    }

    if (!_reader.isReady || _pdfController == null) {
      return const Scaffold(body: _ReaderLoadingView());
    }

    return AnimatedBuilder(
      animation: _reader,
      builder: (context, _) {
        return _QalamScreenShell(
          title: 'Page ${_reader.currentPage}',
          subtitle:
              '${widget.source.lineCount}-Line Quran - Para ${_reader.currentJuz.number}',
          nightMode: _reader.nightMode,
          backgroundColor: _reader.nightMode
              ? const Color(0xFF07100D)
              : const Color(0xFFF2EADA),
          child: OrientationBuilder(
            builder: (context, orientation) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final isTablet = constraints.maxWidth >= 720;
                  final horizontalPadding = isTablet ? 56.0 : 8.0;
                  final verticalPadding = orientation == Orientation.landscape
                      ? 4.0
                      : 6.0;

                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding,
                            verticalPadding,
                            horizontalPadding,
                            verticalPadding,
                          ),
                          child: PdfView(
                            controller: _pdfController!,
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            pageSnapping: true,
                            renderer: _renderMushafPage,
                            backgroundDecoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            builders: PdfViewBuilders<DefaultBuilderOptions>(
                              options: const DefaultBuilderOptions(),
                              pageBuilder: _buildPdfPage,
                              documentLoaderBuilder: (_) =>
                                  const _ReaderLoadingView(),
                              pageLoaderBuilder: (_) =>
                                  const _ReaderLoadingView(),
                            ),
                            onDocumentLoaded: (document) {
                              if (document.pagesCount !=
                                  widget.source.totalPages) {
                                debugPrint(
                                  'Expected ${widget.source.totalPages} pages, '
                                  'loaded ${document.pagesCount}.',
                                );
                              }
                            },
                            onPageChanged: (page) {
                              unawaited(_reader.setPage(page));
                            },
                            onDocumentError: (error) {
                              if (!mounted) {
                                return;
                              }

                              setState(() {
                                _loadError = error;
                              });
                            },
                          ),
                        ),
                      ),
                      if (_reader.nightMode)
                        const Positioned.fill(
                          child: IgnorePointer(
                            child: ColoredBox(color: Color(0x33000000)),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  static Future<PdfPageImage?> _renderMushafPage(PdfPage page) {
    const scale = 3.0;

    return page.render(
      width: page.width * scale,
      height: page.height * scale,
      format: PdfPageImageFormat.jpeg,
      backgroundColor: '#FFFFFF',
      quality: 100,
      forPrint: true,
    );
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

class _PageNumberPanel extends StatefulWidget {
  const _PageNumberPanel({required this.source, required this.currentPage});

  final MushafSource source;
  final int currentPage;

  @override
  State<_PageNumberPanel> createState() => _PageNumberPanelState();
}

class _PageNumberPanelState extends State<_PageNumberPanel> {
  late final TextEditingController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = TextEditingController(
      text: widget.currentPage.toString(),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _submitDirectPage() {
    final page = int.tryParse(_pageController.text);

    if (page == null) {
      return;
    }

    Navigator.of(context).pop(widget.source.clampPage(page));
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
            controller: _pageController,
            totalPages: widget.source.totalPages,
            onSubmit: _submitDirectPage,
          ),
        ],
      ),
    );
  }
}

class JuzIndexScreen extends StatelessWidget {
  const JuzIndexScreen({required this.source, super.key});

  final MushafSource source;

  @override
  Widget build(BuildContext context) {
    final nightMode =
        Theme.of(context).colorScheme.brightness == Brightness.dark;

    return _QalamScreenShell(
      title: 'Para',
      subtitle: 'Select Para',
      nightMode: nightMode,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 720;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              isWide ? 40 : 18,
              18,
              isWide ? 40 : 18,
              24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                      subtitle: 'Page ${juz.startPage}',
                      nightMode: nightMode,
                      onTap: () => Navigator.of(context).pop(juz.startPage),
                    );
                  },
                ),
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

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: nightMode
                ? const Color(0xEE0A120F)
                : const Color(0xEEFFFCF5),
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
                    onPressed: () => Navigator.of(context).maybePop(),
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
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
        ),
      ),
    );
  }
}

class SurahIndexScreen extends StatelessWidget {
  const SurahIndexScreen({required this.source, super.key});

  final MushafSource source;

  @override
  Widget build(BuildContext context) {
    final nightMode =
        Theme.of(context).colorScheme.brightness == Brightness.dark;

    return _QalamScreenShell(
      title: 'Surah',
      subtitle: 'Select Surah',
      nightMode: nightMode,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 720;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              isWide ? 40 : 18,
              18,
              isWide ? 40 : 18,
              24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                          : 'Page $verifiedPage',
                      nightMode: nightMode,
                      onTap: () => Navigator.of(context).pop(targetPage),
                    );
                  },
                ),
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
    required this.totalPages,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final int totalPages;
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
                suffixText: '1-$totalPages',
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
          onTap: () => Navigator.of(context).pop(page),
          leading: const Icon(Icons.bookmark),
          title: Text('Page $page'),
          subtitle: Text('Para ${juz.number}'),
          trailing: const Icon(Icons.chevron_right),
        );
      },
    );
  }
}

class _ReaderSettingsPanel extends StatelessWidget {
  const _ReaderSettingsPanel({
    required this.currentPage,
    required this.currentJuz,
    required this.nightMode,
    required this.isBookmarked,
    required this.onToggleNightMode,
    required this.onToggleBookmark,
  });

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
            title: Text('Page $currentPage'),
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
