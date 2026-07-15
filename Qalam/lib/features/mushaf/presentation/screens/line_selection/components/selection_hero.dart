import 'package:flutter/material.dart';

import 'line_selection_style.dart';

class SelectionHero extends StatelessWidget {
  const SelectionHero({
    required this.logoAsset,
    required this.bookAsset,
    required this.archAsset,
    required this.brandName,
    required this.tagline,
    super.key,
  });

  final String logoAsset;
  final String bookAsset;
  final String archAsset;
  final String brandName;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;

        return Semantics(
          label: '$brandName. $tagline',
          image: true,
          child: Container(
            height: compact ? 164 : 174,
            decoration: const BoxDecoration(
              color: LineSelectionStyle.ivory,
              border: Border(bottom: BorderSide(color: Color(0x55D4AF37))),
            ),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  top: compact ? -10 : -8,
                  right: compact ? -16 : -10,
                  width: compact ? 144 : 164,
                  child: Opacity(
                    opacity: 0.72,
                    child: Image.asset(
                      archAsset,
                      fit: BoxFit.contain,
                      excludeFromSemantics: true,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
                Positioned(
                  right: compact ? 2 : 10,
                  bottom: compact ? -2 : -4,
                  width: compact ? 178 : 190,
                  child: Image.asset(
                    bookAsset,
                    fit: BoxFit.contain,
                    excludeFromSemantics: true,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                Positioned(
                  left: compact ? 15 : 20,
                  top: compact ? 16 : 14,
                  width: compact ? 122 : 140,
                  child: Image.asset(
                    logoAsset,
                    fit: BoxFit.contain,
                    excludeFromSemantics: true,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                Positioned(
                  left: compact ? 18 : 24,
                  bottom: compact ? 21 : 25,
                  width: compact ? 148 : 170,
                  child: Text(
                    tagline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF8A6C3E),
                      fontFamily: LineSelectionStyle.bodyFont,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
