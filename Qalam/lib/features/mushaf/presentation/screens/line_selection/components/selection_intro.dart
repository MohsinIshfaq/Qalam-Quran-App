import 'package:flutter/material.dart';

import 'line_selection_style.dart';
import 'qalam_ornaments.dart';

class SelectionIntro extends StatelessWidget {
  const SelectionIntro({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          const Positioned(top: 1, child: QalamSeal(size: 30)),
          Positioned(
            top: 34,
            left: 12,
            right: 12,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: LineSelectionStyle.deepGreen,
                fontFamily: LineSelectionStyle.displayFont,
                fontSize: 21,
                height: 1.08,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Positioned(
            top: 60,
            child: GoldOrnamentDivider(width: 218, compact: true),
          ),
          Positioned(
            top: 77,
            left: 16,
            right: 16,
            child: Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: LineSelectionStyle.bodyText,
                fontFamily: LineSelectionStyle.bodyFont,
                fontSize: 12,
                height: 1.25,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
