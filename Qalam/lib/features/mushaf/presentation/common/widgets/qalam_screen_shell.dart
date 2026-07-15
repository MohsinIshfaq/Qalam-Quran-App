import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QalamScreenShell extends StatelessWidget {
  const QalamScreenShell({
    required this.title,
    required this.subtitle,
    required this.nightMode,
    required this.child,
    this.showBackButton = true,
    this.backgroundColor,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool nightMode;
  final Widget child;
  final bool showBackButton;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        backgroundColor ??
        (nightMode ? const Color(0xFF07100D) : const Color(0xFFFBF7F0));

    return Scaffold(
      backgroundColor: effectiveBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _QalamHeader(
              title: title,
              subtitle: subtitle,
              nightMode: nightMode,
              showBackButton: showBackButton,
              backgroundColor: effectiveBackgroundColor,
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _QalamHeader extends StatelessWidget {
  const _QalamHeader({
    required this.title,
    required this.subtitle,
    required this.nightMode,
    required this.showBackButton,
    required this.backgroundColor,
  });

  final String title;
  final String subtitle;
  final bool nightMode;
  final bool showBackButton;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final titleColor = nightMode
        ? const Color(0xFFEAF5EF)
        : const Color(0xFF0E4B3F);
    final subtitleColor = nightMode
        ? const Color(0xFFB8C9C1)
        : const Color(0xFF625747);
    return DecoratedBox(
      decoration: BoxDecoration(color: backgroundColor),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
        child: Row(
          children: [
            if (showBackButton) ...[
              IconButton(
                tooltip: 'Back',
                onPressed: Get.back<void>,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                style: IconButton.styleFrom(
                  fixedSize: const Size.square(48),
                  iconSize: 23,
                  foregroundColor: titleColor,
                  backgroundColor: nightMode
                      ? Colors.white.withValues(alpha: 0.07)
                      : const Color(0xFFFFFDF8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: nightMode
                          ? Colors.white.withValues(alpha: 0.08)
                          : const Color(0xFFE8DCC0),
                    ),
                  ),
                  shadowColor: Colors.black.withValues(alpha: 0.18),
                  elevation: 5,
                ),
              ),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: titleColor,
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 21,
                      height: 1.05,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: subtitleColor,
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      height: 1.1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
