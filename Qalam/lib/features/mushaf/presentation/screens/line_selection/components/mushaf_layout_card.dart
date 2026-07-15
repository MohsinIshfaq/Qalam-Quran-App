import 'package:flutter/material.dart';

import 'line_selection_style.dart';
import 'qalam_ornaments.dart';

class MushafLayoutCard extends StatelessWidget {
  const MushafLayoutCard({
    required this.title,
    required this.description,
    required this.artworkAsset,
    required this.patternAsset,
    required this.isLoading,
    required this.onTap,
    super.key,
  });

  final String title;
  final String description;
  final String artworkAsset;
  final String patternAsset;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 330;
        final artworkWidth = compact ? 96.0 : 108.0;

        return Semantics(
          button: true,
          label: '$title, $description',
          child: Material(
            color: Colors.transparent,
            child: Ink(
              height: 126,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDF8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: LineSelectionStyle.cardBorder),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: InkWell(
                onTap: isLoading ? null : onTap,
                borderRadius: BorderRadius.circular(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        left: artworkWidth + 70,
                        child: Opacity(
                          opacity: 0.18,
                          child: Image.asset(
                            patternAsset,
                            fit: BoxFit.cover,
                            alignment: Alignment.centerRight,
                            excludeFromSemantics: true,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: artworkWidth,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  LineSelectionStyle.deepGreen,
                                  LineSelectionStyle.darkGreen,
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                compact ? 3 : 5,
                                3,
                                compact ? 3 : 5,
                                0,
                              ),
                              child: Image.asset(
                                artworkAsset,
                                fit: BoxFit.contain,
                                alignment: Alignment.bottomCenter,
                                excludeFromSemantics: true,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                compact ? 13 : 18,
                                9,
                                compact ? 11 : 15,
                                9,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: LineSelectionStyle.deepGreen,
                                            fontFamily:
                                                LineSelectionStyle.displayFont,
                                            fontSize: 22,
                                            height: 1.05,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const GoldOrnamentDivider(
                                          width: 100,
                                          compact: true,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: LineSelectionStyle.black,
                                            fontFamily:
                                                LineSelectionStyle.bodyFont,
                                            fontSize: 12,
                                            height: 1.35,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _CardActionButton(isLoading: isLoading),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CardActionButton extends StatelessWidget {
  const _CardActionButton({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [LineSelectionStyle.richGreen, LineSelectionStyle.darkGreen],
        ),
        border: Border.all(color: LineSelectionStyle.gold),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.all(11),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: LineSelectionStyle.lightGold,
              ),
            )
          : const Icon(
              Icons.chevron_right_rounded,
              color: LineSelectionStyle.lightGold,
              size: 27,
            ),
    );
  }
}
