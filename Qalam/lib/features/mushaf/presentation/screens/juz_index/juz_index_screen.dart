import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../common/widgets/qalam_footer_ornament.dart';
import '../../common/widgets/qalam_screen_shell.dart';
import 'components/para_menu_tile.dart';
import 'juz_index_controller.dart';

class JuzIndexScreen extends GetView<JuzIndexController> {
  const JuzIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = controller.session;
    final nightMode = session.nightMode;
    final backgroundColor = nightMode
        ? const Color(0xFF07100D)
        : const Color(0xFFFBF7F0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          (nightMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
              .copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: backgroundColor,
                systemNavigationBarIconBrightness: nightMode
                    ? Brightness.light
                    : Brightness.dark,
              ),
      child: QalamScreenShell(
        title: controller.title,
        subtitle: controller.subtitle,
        nightMode: nightMode,
        backgroundColor: backgroundColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;
            final horizontalPadding = isWide
                ? 40.0
                : constraints.maxWidth < 360
                ? 12.0
                : 14.0;
            final tileHeight = ((constraints.maxHeight - 116) / 7).clamp(
              88.0,
              98.0,
            );

            return Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 820),
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        8,
                        horizontalPadding,
                        62,
                      ),
                      itemCount: controller.items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = controller.items[index];

                        return ParaMenuTile(
                          number: item.number,
                          englishName: item.englishName,
                          arabicName: item.arabicName,
                          subtitle: item.pageLabel,
                          height: tileHeight,
                          nightMode: nightMode,
                          onTap: () => controller.selectPara(item),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            backgroundColor.withValues(alpha: 0),
                            backgroundColor.withValues(alpha: 0.94),
                            backgroundColor,
                          ],
                        ),
                      ),
                      child: QalamFooterOrnament(
                        nightMode: nightMode,
                        padding: EdgeInsets.fromLTRB(
                          isWide ? 190 : 86,
                          20,
                          isWide ? 190 : 86,
                          7,
                        ),
                        iconSize: 24,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
