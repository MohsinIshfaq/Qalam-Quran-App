import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'components/mushaf_layout_card.dart';
import 'components/line_selection_style.dart';
import 'components/selection_footer.dart';
import 'components/selection_hero.dart';
import 'components/selection_intro.dart';
import 'line_selection_controller.dart';

class LineSelectionScreen extends GetView<LineSelectionController> {
  const LineSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: LineSelectionStyle.deepGreen,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: LineSelectionStyle.ivory,
        body: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  const SliverToBoxAdapter(
                    child: SelectionHero(
                      logoAsset: LineSelectionController.logoAssetPath,
                      bookAsset: LineSelectionController.heroAssetPath,
                      archAsset:
                          LineSelectionController.backgroundArchAssetPath,
                      brandName: LineSelectionController.brandName,
                      tagline: LineSelectionController.tagline,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SelectionIntro(
                      title: LineSelectionController.sectionTitle,
                      subtitle: LineSelectionController.sectionSubtitle,
                    ),
                  ),
                  SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final horizontalPadding =
                          constraints.crossAxisExtent < 360 ? 16.0 : 24.0;

                      return SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          0,
                          horizontalPadding,
                          8,
                        ),
                        sliver: SliverList.separated(
                          itemCount: controller.layouts.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final layout = controller.layouts[index];

                            return Obx(
                              () => MushafLayoutCard(
                                title: layout.title,
                                description: layout.description,
                                artworkAsset: layout.artworkAssetPath,
                                patternAsset: LineSelectionController
                                    .cardPatternAssetPath,
                                isLoading: controller.isOpening(layout),
                                onTap: () =>
                                    unawaited(controller.selectLayout(layout)),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SliverToBoxAdapter(child: SelectionFooter()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
