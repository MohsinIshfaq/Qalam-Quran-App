import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import '../../domain/entities/mushaf_source.dart';
import '../../domain/repositories/mushaf_repository.dart';
import '../controllers/mushaf_reader_controller.dart';

class MushafScreen extends StatefulWidget {
  const MushafScreen({
    required this.source,
    required this.repository,
    super.key,
  });

  final MushafSource source;
  final MushafRepository repository;

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

  Future<void> _animateToPage(int page) async {
    final targetPage = widget.source.clampPage(page);
    final controller = _pdfController;

    if (controller == null) {
      return;
    }

    await controller.animateToPage(
      targetPage,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
    await _reader.setPage(targetPage);
  }

  Future<void> _openGoToPanel() async {
    final page = await showModalBottomSheet<int>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.84,
          child: GoToPagePanel(
            source: widget.source,
            currentPage: _reader.currentPage,
          ),
        );
      },
    );

    if (page != null) {
      await _animateToPage(page);
    }
  }

  Future<void> _openBookmarksPanel() async {
    final page = await showModalBottomSheet<int>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
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

    if (page != null) {
      await _animateToPage(page);
    }
  }

  Future<void> _toggleBookmark() async {
    await _reader.toggleCurrentBookmark();

    if (!mounted) {
      return;
    }

    final isBookmarked = _reader.isCurrentPageBookmarked;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isBookmarked ? 'Bookmark added' : 'Bookmark removed'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1200),
      ),
    );
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
        final colorScheme = Theme.of(context).colorScheme;
        final currentJuz = _reader.currentJuz;

        return Scaffold(
          backgroundColor: _reader.nightMode
              ? const Color(0xFF070A09)
              : const Color(0xFFEFE7D4),
          appBar: AppBar(
            backgroundColor: _reader.nightMode ? const Color(0xFF0D1211) : null,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Qalam'),
                Text(
                  '${widget.source.title} - Juz ${currentJuz.number}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Go to page, Juz, or Surah',
                onPressed: _openGoToPanel,
                icon: const Icon(Icons.manage_search),
              ),
              IconButton(
                tooltip: 'Bookmarks',
                onPressed: _openBookmarksPanel,
                icon: const Icon(Icons.bookmarks_outlined),
              ),
              IconButton(
                tooltip: _reader.nightMode ? 'Light mode' : 'Night mode',
                isSelected: _reader.nightMode,
                selectedIcon: const Icon(Icons.light_mode_outlined),
                onPressed: () => unawaited(_reader.toggleNightMode()),
                icon: const Icon(Icons.dark_mode_outlined),
              ),
            ],
          ),
          body: SafeArea(
            child: OrientationBuilder(
              builder: (context, orientation) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isTablet = constraints.maxWidth >= 720;
                    final isLandscape = orientation == Orientation.landscape;
                    final horizontalPadding = isTablet ? 56.0 : 8.0;
                    final verticalPadding = isLandscape ? 8.0 : 14.0;
                    final bottomInset = isLandscape ? 70.0 : 92.0;

                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              horizontalPadding,
                              verticalPadding,
                              horizontalPadding,
                              bottomInset + verticalPadding,
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
                        Positioned(
                          left: 12,
                          right: 12,
                          bottom: 12,
                          child: _ReaderToolbar(
                            source: widget.source,
                            currentPage: _reader.currentPage,
                            currentJuz: currentJuz,
                            isBookmarked: _reader.isCurrentPageBookmarked,
                            canGoPrevious: _reader.canGoPrevious,
                            canGoNext: _reader.canGoNext,
                            nightMode: _reader.nightMode,
                            onPrevious: () => unawaited(
                              _animateToPage(_reader.currentPage - 1),
                            ),
                            onNext: () => unawaited(
                              _animateToPage(_reader.currentPage + 1),
                            ),
                            onBookmark: () => unawaited(_toggleBookmark()),
                            onGoTo: _openGoToPanel,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
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

class GoToPagePanel extends StatefulWidget {
  const GoToPagePanel({
    required this.source,
    required this.currentPage,
    super.key,
  });

  final MushafSource source;
  final int currentPage;

  @override
  State<GoToPagePanel> createState() => _GoToPagePanelState();
}

class _GoToPagePanelState extends State<GoToPagePanel> {
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
    return DefaultTabController(
      length: 3,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: Column(
          children: [
            TabBar(
              tabs: const [
                Tab(text: 'Page'),
                Tab(text: 'Juz'),
                Tab(text: 'Surah'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                children: [
                  _DirectPageTab(
                    controller: _pageController,
                    totalPages: widget.source.totalPages,
                    onSubmit: _submitDirectPage,
                  ),
                  _JuzTab(source: widget.source),
                  _SurahTab(source: widget.source),
                ],
              ),
            ),
          ],
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

class _JuzTab extends StatelessWidget {
  const _JuzTab({required this.source});

  final MushafSource source;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 700 ? 5 : (width >= 460 ? 4 : 3);

        return GridView.builder(
          itemCount: source.juzList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) {
            final juz = source.juzList[index];

            return OutlinedButton(
              onPressed: () => Navigator.of(context).pop(juz.startPage),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Juz ${juz.number}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Page ${juz.startPage}',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SurahTab extends StatelessWidget {
  const _SurahTab({required this.source});

  final MushafSource source;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: source.surahList.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final surah = source.surahList[index];
        final verifiedPage = surah.verifiedStartPage;
        final fallbackPage = source.pageForJuz(surah.startJuz);
        final targetPage = verifiedPage ?? fallbackPage;

        return ListTile(
          onTap: () => Navigator.of(context).pop(targetPage),
          leading: CircleAvatar(
            radius: 18,
            child: Text(surah.number.toString()),
          ),
          title: Text(surah.englishName),
          subtitle: Text(
            verifiedPage == null
                ? 'Juz ${surah.startJuz}'
                : 'Page $verifiedPage',
          ),
          trailing: Text(
            surah.arabicName,
            textDirection: TextDirection.rtl,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
      },
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
          subtitle: Text('Juz ${juz.number}'),
          trailing: const Icon(Icons.chevron_right),
        );
      },
    );
  }
}

class _ReaderToolbar extends StatelessWidget {
  const _ReaderToolbar({
    required this.source,
    required this.currentPage,
    required this.currentJuz,
    required this.isBookmarked,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.nightMode,
    required this.onPrevious,
    required this.onNext,
    required this.onBookmark,
    required this.onGoTo,
  });

  final MushafSource source;
  final int currentPage;
  final JuzInfo currentJuz;
  final bool isBookmarked;
  final bool canGoPrevious;
  final bool canGoNext;
  final bool nightMode;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onBookmark;
  final VoidCallback onGoTo;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = nightMode
        ? const Color(0xEE111816)
        : const Color(0xEEFDF9F0);
    final foregroundColor = nightMode
        ? const Color(0xFFF4EFE4)
        : colorScheme.onSurface;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: nightMode ? 0.32 : 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: IconTheme(
          data: IconThemeData(color: foregroundColor),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: foregroundColor),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Previous page',
                  onPressed: canGoPrevious ? onPrevious : null,
                  icon: const Icon(Icons.chevron_right),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 260;

                      return TextButton.icon(
                        onPressed: onGoTo,
                        icon: const Icon(Icons.menu_book_outlined),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            compact
                                ? '$currentPage/${source.totalPages}'
                                : 'Page $currentPage / ${source.totalPages} - Juz ${currentJuz.number}',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                IconButton(
                  tooltip: isBookmarked
                      ? 'Remove bookmark'
                      : 'Bookmark this page',
                  onPressed: onBookmark,
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  ),
                ),
                IconButton(
                  tooltip: 'Next page',
                  onPressed: canGoNext ? onNext : null,
                  icon: const Icon(Icons.chevron_left),
                ),
              ],
            ),
          ),
        ),
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
