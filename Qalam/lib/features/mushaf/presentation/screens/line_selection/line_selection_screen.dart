import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/qalam_menu_tile.dart';
import '../../common/widgets/qalam_screen_shell.dart';
import 'line_selection_controller.dart';

class LineSelectionScreen extends GetView<LineSelectionController> {
  const LineSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nightMode =
        Theme.of(context).colorScheme.brightness == Brightness.dark;

    return QalamScreenShell(
      title: 'Qalam',
      subtitle: 'Select Quran line format',
      nightMode: nightMode,
      showBackButton: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 720;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              isWide ? 40 : 20,
              18,
              isWide ? 40 : 20,
              28,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isWide ? 3 : 1,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: isWide ? 1.45 : 2.45,
                  children: controller.sources
                      .map(
                        (source) => QalamMenuTile(
                          title: '${source.lineCount}-Line',
                          subtitle: 'Open Quran',
                          icon: Icons.auto_stories_outlined,
                          nightMode: nightMode,
                          onTap: () => unawaited(controller.openSource(source)),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
