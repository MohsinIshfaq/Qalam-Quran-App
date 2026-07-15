import 'package:flutter/material.dart';

import 'home_icon_badge.dart';
import 'home_style.dart';

class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 330;

        return Semantics(
          button: true,
          label: '$title, $subtitle',
          child: Material(
            color: Colors.transparent,
            child: Ink(
              height: compact ? 174 : 188,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [HomeStyle.deepGreen, HomeStyle.darkGreen],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: HomeStyle.gold),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x24000000),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const CustomPaint(painter: _BannerDecorationPainter()),
                      Positioned(
                        right: compact ? -34 : -30,
                        bottom: compact ? -5 : -7,
                        width: compact ? 178 : 190,
                        child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Color(0x77103F35),
                            BlendMode.multiply,
                          ),
                          child: Image.asset(
                            HomeStyle.heroBookAsset,
                            fit: BoxFit.contain,
                            excludeFromSemantics: true,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                      Positioned(
                        left: compact ? 12 : 12,
                        top: compact ? 57 : 64,
                        child: HomeIconBadge(
                          icon: Icons.menu_book_rounded,
                          size: compact ? 46 : 52,
                          iconSize: compact ? 25 : 29,
                        ),
                      ),
                      Positioned(
                        left: compact ? 68 : 72,
                        top: compact ? 58 : 65,
                        right: compact ? 90 : 105,
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFFFFFBF2),
                            fontFamily: HomeStyle.displayFont,
                            fontSize: compact ? 18 : 19,
                            height: 1.1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Positioned(
                        left: compact ? 68 : 72,
                        top: compact ? 88 : 99,
                        right: compact ? 88 : 104,
                        child: Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: HomeStyle.lightGold,
                            fontFamily: HomeStyle.bodyFont,
                            fontSize: compact ? 13 : 15,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Positioned(
                        left: compact ? 68 : 72,
                        top: compact ? 119 : 134,
                        width: compact ? 112 : 128,
                        child: _ReadingProgress(value: progress),
                      ),
                      Positioned(
                        right: 15,
                        bottom: 15,
                        child: HomeArrowButton(filled: true, size: 40),
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

class _ReadingProgress extends StatelessWidget {
  const _ReadingProgress({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 4,
        child: LinearProgressIndicator(
          value: value.clamp(0, 1),
          backgroundColor: HomeStyle.richGreen,
          color: const Color(0xFFF5D681),
        ),
      ),
    );
  }
}

class _BannerDecorationPainter extends CustomPainter {
  const _BannerDecorationPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final fineGold = Paint()
      ..color = HomeStyle.gold.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final curveGold = Paint()
      ..color = HomeStyle.gold.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    for (var index = 0; index < 6; index++) {
      final inset = 10.0 + index * 9;
      canvas.drawArc(
        Rect.fromCircle(center: const Offset(0, 0), radius: inset + 24),
        0,
        1.55,
        false,
        fineGold,
      );
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width, size.height),
          radius: inset + 28,
        ),
        3.15,
        1.55,
        false,
        fineGold,
      );
    }

    final sweep = Path()
      ..moveTo(0, size.height * 0.27)
      ..quadraticBezierTo(
        size.width * 0.08,
        size.height * 0.42,
        size.width * 0.12,
        size.height,
      );
    canvas.drawPath(sweep, curveGold);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
