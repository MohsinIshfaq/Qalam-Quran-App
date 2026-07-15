import 'package:flutter/material.dart';

class QalamIndexTile extends StatelessWidget {
  const QalamIndexTile({
    required this.number,
    required this.title,
    required this.englishName,
    required this.arabicName,
    required this.subtitle,
    required this.height,
    required this.nightMode,
    required this.onTap,
    super.key,
  });

  final int number;
  final String title;
  final String englishName;
  final String arabicName;
  final String subtitle;
  final double height;
  final bool nightMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final baseColor = nightMode
        ? const Color(0xFF121B17)
        : const Color(0xFFFFFDF8);
    final borderColor = nightMode
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFE8DCC0);
    final accentColor = nightMode
        ? const Color(0xFF72D4BF)
        : const Color(0xFF0E4B3F);
    final titleColor = nightMode
        ? const Color(0xFFEAF5EF)
        : const Color(0xFF0E4B3F);
    final subtitleColor = nightMode
        ? const Color(0xFFAABBB3)
        : const Color(0xFF6C6253);

    return Semantics(
      button: true,
      label: '$title, $englishName, $subtitle',
      child: Material(
        color: Colors.transparent,
        child: Ink(
          height: height,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: nightMode ? 0.16 : 0.07),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(11),
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 340;

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        width: compact ? 104 : 130,
                        child: Opacity(
                          opacity: nightMode ? 0.08 : 0.2,
                          child: Image.asset(
                            'assets/images/line_selection/card_pattern.png',
                            fit: BoxFit.cover,
                            alignment: Alignment.topRight,
                            excludeFromSemantics: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: compact ? 11 : 14,
                        ),
                        child: Row(
                          children: [
                            _IndexNumberBadge(
                              number: number,
                              compact: compact,
                              nightMode: nightMode,
                            ),
                            SizedBox(width: compact ? 10 : 16),
                            Expanded(
                              child: _IndexDetails(
                                title: title,
                                englishName: englishName,
                                subtitle: subtitle,
                                compact: compact,
                                titleColor: titleColor,
                                subtitleColor: subtitleColor,
                              ),
                            ),
                            SizedBox(width: compact ? 4 : 8),
                            SizedBox(
                              width: compact ? 84 : 124,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  arabicName,
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: titleColor,
                                    fontSize: compact ? 23 : 29,
                                    height: 1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: compact ? 2 : 6),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: accentColor,
                              size: compact ? 24 : 28,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IndexNumberBadge extends StatelessWidget {
  const _IndexNumberBadge({
    required this.number,
    required this.compact,
    required this.nightMode,
  });

  final int number;
  final bool compact;
  final bool nightMode;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 41.0 : 44.0;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.35, -0.4),
          radius: 0.9,
          colors: nightMode
              ? const [Color(0x3329A383), Color(0x2240B493)]
              : const [Color(0xFFF5F8F3), Color(0xFFDDEBE2)],
        ),
      ),
      child: Text(
        number.toString(),
        style: TextStyle(
          color: nightMode ? const Color(0xFF72D4BF) : const Color(0xFF0E4B3F),
          fontFamily: 'PlayfairDisplay',
          fontSize: compact ? 18 : 20,
          height: 1,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _IndexDetails extends StatelessWidget {
  const _IndexDetails({
    required this.title,
    required this.englishName,
    required this.subtitle,
    required this.compact,
    required this.titleColor,
    required this.subtitleColor,
  });

  final String title;
  final String englishName;
  final String subtitle;
  final bool compact;
  final Color titleColor;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: titleColor,
            fontFamily: 'PlayfairDisplay',
            fontSize: compact ? 17 : 19,
            height: 1.05,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          englishName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: subtitleColor,
            fontFamily: 'PlayfairDisplay',
            fontSize: compact ? 12 : 13.5,
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
            fontSize: compact ? 10.5 : 11.5,
            height: 1,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
