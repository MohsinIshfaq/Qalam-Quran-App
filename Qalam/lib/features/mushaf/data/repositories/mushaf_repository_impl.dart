import '../../domain/repositories/mushaf_repository.dart';
import '../datasources/mushaf_local_storage.dart';

class MushafRepositoryImpl implements MushafRepository {
  const MushafRepositoryImpl(this._localStorage);

  final MushafLocalStorage _localStorage;

  @override
  Future<int?> getLastReadPage(String mushafId) {
    return _localStorage.getInt(_key(mushafId, 'last_page'));
  }

  @override
  Future<void> saveLastReadPage(String mushafId, int page) {
    return _localStorage.setInt(_key(mushafId, 'last_page'), page);
  }

  @override
  Future<Set<int>> getBookmarkedPages(String mushafId) async {
    final values = await _localStorage.getStringList(
      _key(mushafId, 'bookmarks'),
    );

    return values?.map(int.tryParse).whereType<int>().toSet() ?? <int>{};
  }

  @override
  Future<void> saveBookmarkedPages(String mushafId, Set<int> pages) {
    final sortedPages = pages.toList()..sort();
    final values = sortedPages.map((page) => page.toString()).toList();

    return _localStorage.setStringList(_key(mushafId, 'bookmarks'), values);
  }

  @override
  Future<bool> getNightMode(String mushafId) async {
    return await _localStorage.getBool(_key(mushafId, 'night_mode')) ?? false;
  }

  @override
  Future<void> saveNightMode(String mushafId, bool enabled) {
    return _localStorage.setBool(_key(mushafId, 'night_mode'), enabled);
  }

  String _key(String mushafId, String field) => 'mushaf.$mushafId.$field';
}
