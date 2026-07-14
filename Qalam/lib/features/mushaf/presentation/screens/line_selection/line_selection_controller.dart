import 'package:get/get.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../data/models/mushaf_catalog.dart';
import '../../../domain/entities/mushaf_source.dart';

class LineSelectionController extends GetxController {
  List<MushafSource> get sources => MushafCatalog.sources;

  Future<void> openSource(MushafSource source) async {
    await (Get.toNamed<dynamic>(AppRoutes.mushafHome, arguments: source) ??
        Future<dynamic>.value());
  }
}
