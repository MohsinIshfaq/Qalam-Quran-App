import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../common/widgets/qalam_screen_shell.dart';
import '../../common/widgets/reader_state_views.dart';
import 'components/continue_reading_card.dart';
import 'components/home_footer_ornament.dart';
import 'components/home_menu_card.dart';
import 'components/home_style.dart';
import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = controller.session;

    return Obx(() {
      final error = session.loadError;
      if (error != null) {
        return Scaffold(body: ReaderErrorView(message: error.toString()));
      }

      if (!session.isReady) {
        return const Scaffold(body: ReaderLoadingView());
      }

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: HomeStyle.ivory,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: QalamScreenShell(
          title: controller.title,
          subtitle: controller.currentLocation,
          nightMode: false,
          backgroundColor: HomeStyle.ivory,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth < 360
                  ? 12.0
                  : 14.0;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  8,
                  horizontalPadding,
                  0,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      children: [
                        ContinueReadingCard(
                          title: 'Continue Reading',
                          subtitle: controller.currentLocation,
                          progress: controller.readingProgress,
                          onTap: () => unawaited(
                            controller.openReader(page: session.currentPage),
                          ),
                        ),
                        const SizedBox(height: 14),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                mainAxisExtent: 156,
                              ),
                          itemBuilder: (context, index) => switch (index) {
                            0 => HomeMenuCard(
                              title: 'BookMark',
                              subtitle: '${session.bookmarks.length} saved',
                              icon: Icons.bookmark_border_rounded,
                              decoration: HomeMenuDecoration.pattern,
                              onTap: () =>
                                  unawaited(controller.openBookmarks()),
                            ),
                            1 => HomeMenuCard(
                              title: 'Para Index',
                              subtitle: 'Browse 30 Para',
                              icon: Icons.explore_outlined,
                              decoration: HomeMenuDecoration.arch,
                              onTap: () => unawaited(controller.openJuzIndex()),
                            ),
                            2 => HomeMenuCard(
                              title: 'Surah Index',
                              subtitle: 'Browse Surahs',
                              icon: Icons.format_list_bulleted_rounded,
                              decoration: HomeMenuDecoration.pattern,
                              onTap: () =>
                                  unawaited(controller.openSurahIndex()),
                            ),
                            _ => HomeMenuCard(
                              title: 'Page #',
                              subtitle: 'Go directly',
                              icon: Icons.tag_rounded,
                              decoration: HomeMenuDecoration.mosque,
                              onTap: () =>
                                  unawaited(controller.openPagePicker()),
                            ),
                          },
                        ),
                        const SizedBox(height: 14),
                        HomeSettingsCard(
                          subtitle: controller.settingsMode,
                          onTap: () => unawaited(controller.openSettings()),
                        ),
                        const HomeFooterOrnament(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
