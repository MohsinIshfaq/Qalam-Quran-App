import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/qalam_index_layout.dart';
import 'components/surah_menu_tile.dart';
import 'surah_index_controller.dart';

class SurahIndexScreen extends GetView<SurahIndexController> {
  const SurahIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nightMode = controller.session.nightMode;

    return QalamIndexLayout(
      title: controller.title,
      subtitle: controller.subtitle,
      nightMode: nightMode,
      itemCount: controller.items.length,
      itemBuilder: (context, index, tileHeight) {
        final item = controller.items[index];

        return SurahMenuTile(
          number: item.number,
          englishName: item.englishName,
          arabicName: item.arabicName,
          subtitle: item.pageLabel,
          height: tileHeight,
          nightMode: nightMode,
          onTap: () => controller.selectSurah(item),
        );
      },
    );
  }
}
