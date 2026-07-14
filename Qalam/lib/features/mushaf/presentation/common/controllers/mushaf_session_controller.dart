import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../domain/entities/mushaf_source.dart';
import '../../../domain/repositories/mushaf_repository.dart';
import '../../services/mushaf_pdf_cache.dart';

class MushafSessionController extends GetxController {
  MushafSessionController(this._source, this._repository);

  static const Duration _lastPageSaveDelay = Duration(milliseconds: 400);

  final MushafSource _source;
  final MushafRepository _repository;

  final RxBool _isReady = false.obs;
  final Rxn<Object> _loadError = Rxn<Object>();
  final RxBool _nightMode = false.obs;
  final RxInt _currentPage = 1.obs;
  final Rx<Set<int>> _bookmarks = Rx<Set<int>>(<int>{});
  Timer? _lastPageSaveTimer;
  int? _pendingLastPage;
  Future<void> _lastPageSaveQueue = Future<void>.value();
  Future<void>? _loadOperation;

  MushafSource get source => _source;

  bool get isReady => _isReady.value;

  Object? get loadError => _loadError.value;

  bool get nightMode => _nightMode.value;

  int get currentPage => _currentPage.value;

  List<int> get bookmarks {
    final values = _bookmarks.value.toList()..sort();
    return values;
  }

  bool get isCurrentPageBookmarked => _bookmarks.value.contains(currentPage);

  JuzInfo get currentJuz => _source.juzForPage(currentPage);

  @override
  void onInit() {
    super.onInit();
    unawaited(load());
  }

  @override
  void onReady() {
    super.onReady();
    MushafPdfCache.warmUp(_source);
  }

  Future<void> load() => _loadOperation ??= _load();

  Future<void> _load() async {
    try {
      final values = await Future.wait<Object?>(<Future<Object?>>[
        _repository.getLastReadPage(_source.id),
        _repository.getBookmarkedPages(_source.id),
        _repository.getNightMode(_source.id),
      ]);
      final lastPage = values[0] as int?;
      final bookmarks = values[1] as Set<int>;
      final nightMode = values[2] as bool;

      _currentPage.value = _source.clampReadablePage(
        lastPage ?? _source.firstReadablePage,
      );
      _bookmarks.value = bookmarks;
      _nightMode.value = nightMode;
      _isReady.value = true;
    } catch (error) {
      _loadError.value = error;
      debugPrint('Unable to load Quran reader state: $error');
    }
  }

  void setPage(int page) {
    final safePage = _source.clampPage(page);

    if (currentPage == safePage) {
      return;
    }

    _currentPage.value = safePage;
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
    final updatedBookmarks = Set<int>.of(_bookmarks.value);

    if (updatedBookmarks.contains(currentPage)) {
      updatedBookmarks.remove(currentPage);
    } else {
      updatedBookmarks.add(currentPage);
    }

    _bookmarks.value = updatedBookmarks;
    await _repository.saveBookmarkedPages(_source.id, updatedBookmarks);
  }

  Future<void> toggleNightMode() async {
    _nightMode.toggle();
    await _repository.saveNightMode(_source.id, nightMode);
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
  void onClose() {
    unawaited(flushPendingPageSave());
    super.onClose();
  }
}
