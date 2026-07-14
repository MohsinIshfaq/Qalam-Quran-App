import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:qalam/app/qalam_app.dart';
import 'package:qalam/app/routes/app_routes.dart';
import 'package:qalam/features/mushaf/domain/repositories/mushaf_repository.dart';
import 'package:qalam/features/mushaf/presentation/controllers/mushaf_reader_controller.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put<MushafRepository>(_MemoryMushafRepository(), permanent: true);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('GetX routes open the selected Mushaf and Para index', (
    tester,
  ) async {
    await tester.pumpWidget(const QalamApp());
    await tester.pumpAndSettle();

    expect(Get.currentRoute, AppRoutes.lineSelection);
    expect(find.text('13-Line'), findsOneWidget);
    expect(find.text('15-Line'), findsOneWidget);
    expect(find.text('16-Line'), findsOneWidget);

    await tester.tap(find.text('16-Line'));
    await tester.pumpAndSettle();

    expect(Get.currentRoute, AppRoutes.mushafHome);
    expect(find.text('16-Line Quran'), findsOneWidget);

    await tester.tap(find.text('Para Index'));
    await tester.pumpAndSettle();

    expect(Get.currentRoute, AppRoutes.juzIndex);
    expect(find.text('Para 1'), findsOneWidget);

    Get.back<void>();
    await tester.pumpAndSettle();
    Get.back<void>();
    await tester.pumpAndSettle();

    expect(Get.currentRoute, AppRoutes.lineSelection);
    expect(Get.isRegistered<MushafReaderController>(), isFalse);

    await tester.tap(find.text('13-Line'));
    await tester.pumpAndSettle();

    expect(find.text('13-Line Quran'), findsOneWidget);
    expect(Get.find<MushafReaderController>().source.lineCount, 13);
  });
}

class _MemoryMushafRepository implements MushafRepository {
  @override
  Future<Set<int>> getBookmarkedPages(String mushafId) async => <int>{};

  @override
  Future<int?> getLastReadPage(String mushafId) async => null;

  @override
  Future<bool> getNightMode(String mushafId) async => false;

  @override
  Future<void> saveBookmarkedPages(String mushafId, Set<int> pages) async {}

  @override
  Future<void> saveLastReadPage(String mushafId, int page) async {}

  @override
  Future<void> saveNightMode(String mushafId, bool enabled) async {}
}
