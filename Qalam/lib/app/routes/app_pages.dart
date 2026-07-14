import 'package:get/get.dart';

import '../../features/mushaf/presentation/bindings/mushaf_bindings.dart';
import '../../features/mushaf/presentation/screens/home/home_screen.dart';
import '../../features/mushaf/presentation/screens/juz_index/juz_index_screen.dart';
import '../../features/mushaf/presentation/screens/line_selection/line_selection_screen.dart';
import '../../features/mushaf/presentation/screens/reader/reader_screen.dart';
import '../../features/mushaf/presentation/screens/surah_index/surah_index_screen.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.lineSelection,
      page: LineSelectionScreen.new,
      binding: LineSelectionBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.mushafHome,
      page: HomeScreen.new,
      binding: HomeBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.reader,
      page: ReaderScreen.new,
      binding: ReaderBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.juzIndex,
      page: JuzIndexScreen.new,
      binding: JuzIndexBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.surahIndex,
      page: SurahIndexScreen.new,
      binding: SurahIndexBinding(),
    ),
  ];
}
