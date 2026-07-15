import 'package:get/get.dart';

import '../../../../../app/routes/app_routes.dart';
import '../../../data/models/mushaf_catalog.dart';
import '../../../domain/entities/mushaf_source.dart';

class LineSelectionController extends GetxController {
  static const String brandName = 'Qalam';
  static const String tagline = 'Your Quran. Your Connection.';
  static const String logoAssetPath =
      'assets/images/line_selection/qalam_logo.png';
  static const String heroAssetPath =
      'assets/images/line_selection/hero_quran_book.png';
  static const String backgroundArchAssetPath =
      'assets/images/line_selection/background_arch.png';
  static const String cardPatternAssetPath =
      'assets/images/line_selection/card_pattern.png';
  static const String sectionTitle = 'Select Mushaf Layout';
  static const String sectionSubtitle =
      'Choose your preferred Quran line format.';

  final RxnString _openingSourceId = RxnString();

  late final List<MushafLayoutOption> layouts =
      List<MushafLayoutOption>.unmodifiable(
        MushafCatalog.sources.map(
          (source) => MushafLayoutOption(
            source: source,
            description: switch (source.lineCount) {
              13 => 'Traditional Indo-Pak\nMushaf Layout',
              15 => 'Standard Mushaf\nLayout',
              16 => 'Large Script\nMushaf Layout',
              _ => 'Quran Mushaf Layout',
            },
            artworkAssetPath: switch (source.lineCount) {
              13 => 'assets/images/line_selection/layout_13.png',
              15 => 'assets/images/line_selection/layout_15.png',
              16 => 'assets/images/line_selection/layout_16.png',
              _ => 'assets/images/line_selection/layout_13.png',
            },
          ),
        ),
      );

  bool isOpening(MushafLayoutOption layout) {
    return _openingSourceId.value == layout.source.id;
  }

  Future<void> selectLayout(MushafLayoutOption layout) async {
    if (_openingSourceId.value != null) {
      return;
    }

    _openingSourceId.value = layout.source.id;

    try {
      await (Get.toNamed<dynamic>(
            AppRoutes.mushafHome,
            arguments: layout.source,
          ) ??
          Future<dynamic>.value());
    } finally {
      _openingSourceId.value = null;
    }
  }
}

class MushafLayoutOption {
  const MushafLayoutOption({
    required this.source,
    required this.description,
    required this.artworkAssetPath,
  });

  final MushafSource source;
  final String description;
  final String artworkAssetPath;

  String get title => '${source.lineCount}-Line';
}
