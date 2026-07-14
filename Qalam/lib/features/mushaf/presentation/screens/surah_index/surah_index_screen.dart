import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/utils/mushaf_labels.dart';
import '../../common/widgets/qalam_screen_shell.dart';
import 'components/surah_menu_tile.dart';
import 'surah_index_controller.dart';

class SurahIndexScreen extends GetView<SurahIndexController> {
  const SurahIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = controller.session;
    final source = session.source;
    final nightMode = session.nightMode;

    return QalamScreenShell(
      title: 'Surah',
      subtitle: 'Select Surah',
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
                itemCount: source.surahList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final surah = source.surahList[index];
                  final verifiedPage = surah.verifiedStartPage;
                  final fallbackPage = source.pageForJuz(surah.startJuz);
                  final targetPage = verifiedPage ?? fallbackPage;

                  return SurahMenuTile(
                    number: surah.number,
                    englishName: surah.englishName,
                    arabicName: surah.arabicName,
                    subtitle: verifiedPage == null
                        ? 'Para ${surah.startJuz}'
                        : displayPageLabel(source, verifiedPage),
                    nightMode: nightMode,
                    onTap: () => controller.selectPage(targetPage),
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
