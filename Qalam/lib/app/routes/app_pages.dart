import 'package:get/get.dart';

import '../../features/mushaf/presentation/bindings/mushaf_bindings.dart';
import '../../features/mushaf/presentation/screens/mushaf_screen.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.lineSelection,
      page: MushafLineSelectionScreen.new,
      binding: MushafSelectionBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.mushafHome,
      page: MushafHomeScreen.new,
      binding: MushafBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.reader,
      page: MushafScreen.new,
      binding: MushafPdfBinding(),
    ),
    GetPage<dynamic>(name: AppRoutes.juzIndex, page: JuzIndexScreen.new),
    GetPage<dynamic>(name: AppRoutes.surahIndex, page: SurahIndexScreen.new),
  ];
}
