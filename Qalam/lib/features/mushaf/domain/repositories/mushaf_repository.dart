abstract class MushafRepository {
  Future<int?> getLastReadPage(String mushafId);

  Future<void> saveLastReadPage(String mushafId, int page);

  Future<Set<int>> getBookmarkedPages(String mushafId);

  Future<void> saveBookmarkedPages(String mushafId, Set<int> pages);

  Future<bool> getNightMode(String mushafId);

  Future<void> saveNightMode(String mushafId, bool enabled);
}
