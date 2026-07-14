import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;
import 'dart:ui';

import 'package:pdfx/pdfx.dart';

import '../../domain/entities/mushaf_source.dart';

abstract final class MushafPdfCache {
  static const int _maxRenderedPages = 12;

  static final Map<String, Future<PdfDocument>> _documents =
      <String, Future<PdfDocument>>{};
  static final LinkedHashMap<_RenderedPageKey, Future<PdfPageImage?>>
  _renderedPages = LinkedHashMap<_RenderedPageKey, Future<PdfPageImage?>>();

  static Future<PdfDocument> open(MushafSource source) {
    final assetPath = source.assetPath;
    final cachedDocument = _documents[assetPath];

    if (cachedDocument != null) {
      return cachedDocument;
    }

    final document = PdfDocument.openAsset(assetPath);
    _documents[assetPath] = document;

    unawaited(
      document.then<void>(
        (_) {},
        onError: (Object _, StackTrace _) {
          if (identical(_documents[assetPath], document)) {
            _documents.remove(assetPath);
          }
        },
      ),
    );

    return document;
  }

  static void warmUp(MushafSource source) {
    unawaited(
      open(source).then<void>((_) {}, onError: (Object _, StackTrace _) {}),
    );
  }

  static Future<PdfPageImage?> renderPage(
    PdfPage page, {
    required Size viewportSize,
    required double devicePixelRatio,
  }) {
    final fitScale = math.min(
      viewportSize.width / page.width,
      viewportSize.height / page.height,
    );
    final renderScale = (fitScale * devicePixelRatio * 1.18).clamp(1.35, 2.35);
    final pixelWidth = (page.width * renderScale).round();
    final key = _RenderedPageKey(
      documentSource: page.document.sourceName,
      pageNumber: page.pageNumber,
      pixelWidth: pixelWidth,
    );
    final cachedPage = _renderedPages.remove(key);

    if (cachedPage != null) {
      _renderedPages[key] = cachedPage;
      return cachedPage;
    }

    final renderedPage = page.render(
      width: pixelWidth.toDouble(),
      height: page.height * pixelWidth / page.width,
      format: PdfPageImageFormat.jpeg,
      backgroundColor: '#FFFFFF',
      quality: 90,
    );
    _renderedPages[key] = renderedPage;
    _trimRenderedPages();

    unawaited(
      renderedPage.then<void>(
        (_) {},
        onError: (Object _, StackTrace _) {
          if (identical(_renderedPages[key], renderedPage)) {
            _renderedPages.remove(key);
          }
        },
      ),
    );

    return renderedPage;
  }

  static void _trimRenderedPages() {
    while (_renderedPages.length > _maxRenderedPages) {
      _renderedPages.remove(_renderedPages.keys.first);
    }
  }
}

class _RenderedPageKey {
  const _RenderedPageKey({
    required this.documentSource,
    required this.pageNumber,
    required this.pixelWidth,
  });

  final String documentSource;
  final int pageNumber;
  final int pixelWidth;

  @override
  bool operator ==(Object other) {
    return other is _RenderedPageKey &&
        other.documentSource == documentSource &&
        other.pageNumber == pageNumber &&
        other.pixelWidth == pixelWidth;
  }

  @override
  int get hashCode => Object.hash(documentSource, pageNumber, pixelWidth);
}
