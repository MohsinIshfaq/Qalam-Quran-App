import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:qalam/features/mushaf/data/models/mushaf_catalog.dart';
import 'package:qalam/features/mushaf/domain/repositories/mushaf_repository.dart';
import 'package:qalam/features/mushaf/presentation/controllers/mushaf_reader_controller.dart';

void main() {
  test('reader loads local state concurrently', () async {
    final repository = _ControlledLoadRepository();
    final controller = MushafReaderController(
      MushafCatalog.sixteenLine,
      repository,
    );

    final load = controller.load();
    await Future<void>.delayed(Duration.zero);

    expect(repository.startedReads, 3);

    repository.lastPage.complete(120);
    repository.bookmarks.complete(<int>{120, 140});
    repository.nightMode.complete(true);
    await load;

    expect(controller.currentPage, 120);
    expect(controller.bookmarks, <int>[120, 140]);
    expect(controller.nightMode, isTrue);
    controller.dispose();
  });

  test('rapid page changes persist only the latest page', () async {
    final repository = _RecordingRepository();
    final controller = MushafReaderController(
      MushafCatalog.sixteenLine,
      repository,
    );

    controller.setPage(120);
    controller.setPage(121);
    controller.setPage(122);

    expect(repository.savedPages, isEmpty);

    await Future<void>.delayed(const Duration(milliseconds: 450));

    expect(repository.savedPages, <int>[122]);
    controller.dispose();
  });

  test('disposing the reader flushes its pending page', () async {
    final repository = _RecordingRepository();
    final controller = MushafReaderController(
      MushafCatalog.sixteenLine,
      repository,
    );

    controller.setPage(240);
    controller.dispose();
    await Future<void>.delayed(Duration.zero);

    expect(repository.savedPages, <int>[240]);
  });
}

class _ControlledLoadRepository implements MushafRepository {
  final Completer<int?> lastPage = Completer<int?>();
  final Completer<Set<int>> bookmarks = Completer<Set<int>>();
  final Completer<bool> nightMode = Completer<bool>();

  int startedReads = 0;

  @override
  Future<Set<int>> getBookmarkedPages(String mushafId) {
    startedReads += 1;
    return bookmarks.future;
  }

  @override
  Future<int?> getLastReadPage(String mushafId) {
    startedReads += 1;
    return lastPage.future;
  }

  @override
  Future<bool> getNightMode(String mushafId) {
    startedReads += 1;
    return nightMode.future;
  }

  @override
  Future<void> saveBookmarkedPages(String mushafId, Set<int> pages) async {}

  @override
  Future<void> saveLastReadPage(String mushafId, int page) async {}

  @override
  Future<void> saveNightMode(String mushafId, bool enabled) async {}
}

class _RecordingRepository implements MushafRepository {
  final List<int> savedPages = <int>[];

  @override
  Future<Set<int>> getBookmarkedPages(String mushafId) async => <int>{};

  @override
  Future<int?> getLastReadPage(String mushafId) async => null;

  @override
  Future<bool> getNightMode(String mushafId) async => false;

  @override
  Future<void> saveBookmarkedPages(String mushafId, Set<int> pages) async {}

  @override
  Future<void> saveLastReadPage(String mushafId, int page) async {
    savedPages.add(page);
  }

  @override
  Future<void> saveNightMode(String mushafId, bool enabled) async {}
}
