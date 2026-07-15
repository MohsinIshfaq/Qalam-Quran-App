import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'line_selection_style.dart';

class QalamSeal extends StatelessWidget {
  const QalamSeal({this.size = 56, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: const _SealPainter(),
        child: Icon(
          Icons.menu_book_rounded,
          color: LineSelectionStyle.lightGold,
          size: size * 0.46,
        ),
      ),
    );
  }
}

class GoldOrnamentDivider extends StatelessWidget {
  const GoldOrnamentDivider({
    this.width = 230,
    this.compact = false,
    super.key,
  });

  final double width;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final iconSize = compact ? 14.0 : 18.0;
    final gap = compact ? 7.0 : 10.0;

    return SizedBox(
      width: width,
      child: Row(
        children: [
          const Expanded(child: Divider(color: LineSelectionStyle.gold)),
          SizedBox(width: gap),
          Icon(
            Icons.filter_vintage_rounded,
            color: LineSelectionStyle.gold,
            size: iconSize,
          ),
          SizedBox(width: gap),
          const Expanded(child: Divider(color: LineSelectionStyle.gold)),
        ],
      ),
    );
  }
}

class _SealPainter extends CustomPainter {
  const _SealPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.shortestSide * 0.49;
    final innerRadius = outerRadius * 0.86;
    final path = Path();

    for (var index = 0; index < 24; index++) {
      final radius = index.isEven ? outerRadius : innerRadius;
      final angle = -math.pi / 2 + (math.pi * 2 * index / 24);
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.22), 5, true);
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [LineSelectionStyle.deepGreen, LineSelectionStyle.darkGreen],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = LineSelectionStyle.gold,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
