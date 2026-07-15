import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'qalam_footer_ornament.dart';
import 'qalam_screen_shell.dart';

typedef QalamIndexItemBuilder =
    Widget Function(BuildContext context, int index, double tileHeight);

class QalamIndexLayout extends StatelessWidget {
  const QalamIndexLayout({
    required this.title,
    required this.subtitle,
    required this.nightMode,
    required this.itemCount,
    required this.itemBuilder,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool nightMode;
  final int itemCount;
  final QalamIndexItemBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
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
        title: title,
        subtitle: subtitle,
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
                      itemCount: itemCount,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) =>
                          itemBuilder(context, index, tileHeight),
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
