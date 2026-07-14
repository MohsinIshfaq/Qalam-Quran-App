import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/utils/mushaf_labels.dart';
import '../../common/widgets/qalam_screen_shell.dart';
import 'components/para_menu_tile.dart';
import 'juz_index_controller.dart';

class JuzIndexScreen extends GetView<JuzIndexController> {
  const JuzIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = controller.session;
    final source = session.source;
    final nightMode = session.nightMode;

    return QalamScreenShell(
      title: 'Para',
      subtitle: 'Select Para',
      nightMode: nightMode,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 720;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  isWide ? 40 : 18,
                  18,
                  isWide ? 40 : 18,
                  24,
                ),
                itemCount: source.juzList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final juz = source.juzList[index];

                  return ParaMenuTile(
                    number: juz.number,
                    englishName: paraEnglishName(juz.number),
                    arabicName: paraArabicName(juz.number),
                    subtitle: displayPageLabel(source, juz.startPage),
                    nightMode: nightMode,
                    onTap: () => controller.selectPage(juz.startPage),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
