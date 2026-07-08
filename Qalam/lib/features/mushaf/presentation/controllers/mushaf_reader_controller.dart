import 'package:flutter/foundation.dart';

import '../../domain/entities/mushaf_source.dart';
import '../../domain/repositories/mushaf_repository.dart';

class MushafReaderController extends ChangeNotifier {
  MushafReaderController(this._source, this._repository);

  final MushafSource _source;
  final MushafRepository _repository;

  bool _isReady = false;
  bool _nightMode = false;
  int _currentPage = 1;
  Set<int> _bookmarks = <int>{};

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
    final lastPage = await _repository.getLastReadPage(_source.id);
    final bookmarks = await _repository.getBookmarkedPages(_source.id);
    final nightMode = await _repository.getNightMode(_source.id);

    _currentPage = _source.clampPage(lastPage ?? _source.firstReadablePage);
    _bookmarks = bookmarks;
    _nightMode = nightMode;
    _isReady = true;
    notifyListeners();
  }

  Future<void> setPage(int page) async {
    final safePage = _source.clampPage(page);

    if (_currentPage == safePage) {
      return;
    }

    _currentPage = safePage;
    notifyListeners();

    await _repository.saveLastReadPage(_source.id, safePage);
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
}
