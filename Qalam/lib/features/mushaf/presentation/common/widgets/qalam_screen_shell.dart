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
    return Scaffold(
      backgroundColor:
          backgroundColor ??
          (nightMode ? const Color(0xFF07100D) : const Color(0xFFF5F1E8)),
      body: SafeArea(
        child: Column(
          children: [
            _QalamHeader(
              title: title,
              subtitle: subtitle,
              nightMode: nightMode,
              showBackButton: showBackButton,
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
  });

  final String title;
  final String subtitle;
  final bool nightMode;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final titleColor = nightMode
        ? const Color(0xFFEAF5EF)
        : const Color(0xFF075E4F);
    final subtitleColor = nightMode
        ? const Color(0xFFB8C9C1)
        : const Color(0xFF625747);
    final borderColor = nightMode
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFD9C8AA).withValues(alpha: 0.72);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: nightMode ? const Color(0xEE0A120F) : const Color(0xEEFFFCF5),
        border: Border(bottom: BorderSide(color: borderColor)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: nightMode ? 0.2 : 0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 7, 12, 7),
        child: Row(
          children: [
            if (showBackButton) ...[
              IconButton(
                tooltip: 'Back',
                onPressed: Get.back<void>,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                style: IconButton.styleFrom(
                  fixedSize: const Size.square(40),
                  foregroundColor: titleColor,
                  backgroundColor: nightMode
                      ? Colors.white.withValues(alpha: 0.07)
                      : Colors.white.withValues(alpha: 0.72),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 10),
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: subtitleColor,
                      fontWeight: FontWeight.w600,
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
