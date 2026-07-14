import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/mushaf_source.dart';
import '../../domain/repositories/mushaf_repository.dart';

class MushafReaderController extends ChangeNotifier {
  MushafReaderController(this._source, this._repository);

  static const Duration _lastPageSaveDelay = Duration(milliseconds: 400);

  final MushafSource _source;
  final MushafRepository _repository;

  bool _isReady = false;
  bool _nightMode = false;
  int _currentPage = 1;
  Set<int> _bookmarks = <int>{};
  Timer? _lastPageSaveTimer;
  int? _pendingLastPage;
  Future<void> _lastPageSaveQueue = Future<void>.value();

  bool get isReady => _isReady;

  bool get nightMode => _nightMode;

  int get currentPage => _currentPage;

  List<int> get bookmarks {
    final values = _bookmarks.toList()..sort();
    return values;
  }

  bool get isCurrentPageBookmarked => _bookmarks.contains(_currentPage);

  JuzInfo get currentJuz => _source.juzForPage(_currentPage);

  bool get canGoPrevious => _currentPage > 1;

  bool get canGoNext => _currentPage < _source.totalPages;

  Future<void> load() async {
    final values = await Future.wait<Object?>(<Future<Object?>>[
      _repository.getLastReadPage(_source.id),
      _repository.getBookmarkedPages(_source.id),
      _repository.getNightMode(_source.id),
    ]);
    final lastPage = values[0] as int?;
    final bookmarks = values[1] as Set<int>;
    final nightMode = values[2] as bool;

    _currentPage = _source.clampReadablePage(
      lastPage ?? _source.firstReadablePage,
    );
    _bookmarks = bookmarks;
    _nightMode = nightMode;
    _isReady = true;
    notifyListeners();
  }

  void setPage(int page) {
    final safePage = _source.clampPage(page);

    if (_currentPage == safePage) {
      return;
    }

    _currentPage = safePage;
    notifyListeners();

    _pendingLastPage = safePage;
    _lastPageSaveTimer?.cancel();
    _lastPageSaveTimer = Timer(_lastPageSaveDelay, _queuePendingPageSave);
  }

  Future<void> flushPendingPageSave() {
    _lastPageSaveTimer?.cancel();
    _queuePendingPageSave();
    return _lastPageSaveQueue;
  }

  Future<void> toggleCurrentBookmark() async {
    final updatedBookmarks = Set<int>.of(_bookmarks);

    if (updatedBookmarks.contains(_currentPage)) {
      updatedBookmarks.remove(_currentPage);
    } else {
      updatedBookmarks.add(_currentPage);
    }

    _bookmarks = updatedBookmarks;
    notifyListeners();

    await _repository.saveBookmarkedPages(_source.id, updatedBookmarks);
  }

  Future<void> toggleNightMode() async {
    _nightMode = !_nightMode;
    notifyListeners();

    await _repository.saveNightMode(_source.id, _nightMode);
  }

  void _queuePendingPageSave() {
    _lastPageSaveTimer = null;
    final page = _pendingLastPage;

    if (page == null) {
      return;
    }

    _pendingLastPage = null;
    _lastPageSaveQueue = _lastPageSaveQueue
        .then((_) => _repository.saveLastReadPage(_source.id, page))
        .catchError((Object error, StackTrace stackTrace) {
          debugPrint('Unable to save the last Quran page: $error');
        });
  }

  @override
  void dispose() {
    unawaited(flushPendingPageSave());
    super.dispose();
  }
}
