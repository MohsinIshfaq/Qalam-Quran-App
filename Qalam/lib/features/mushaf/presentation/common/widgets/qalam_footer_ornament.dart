import 'package:flutter/material.dart';

class QalamFooterOrnament extends StatelessWidget {
  const QalamFooterOrnament({
    this.nightMode = false,
    this.padding = const EdgeInsets.fromLTRB(36, 30, 36, 22),
    this.iconSize = 25,
    super.key,
  });

  final bool nightMode;
  final EdgeInsetsGeometry padding;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final gold = nightMode ? const Color(0xFFC7A54A) : const Color(0xFFD4AF37);

    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(child: Divider(color: gold.withValues(alpha: 0.5))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.filter_vintage_rounded,
              color: gold,
              size: iconSize,
            ),
          ),
          Expanded(child: Divider(color: gold.withValues(alpha: 0.5))),
        ],
      ),
    );
  }
}
