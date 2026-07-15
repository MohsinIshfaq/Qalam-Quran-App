import 'package:flutter/material.dart';

import 'line_selection_style.dart';

class SelectionFooter extends StatelessWidget {
  const SelectionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 126,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: LineSelectionStyle.deepGreen),
          const CustomPaint(painter: _FooterCurvePainter()),
          const Positioned(
            top: 4,
            left: 28,
            right: 28,
            child: Column(
              children: [
                Icon(
                  Icons.filter_vintage_rounded,
                  color: LineSelectionStyle.gold,
                  size: 17,
                ),
                SizedBox(height: 5),
                Text(
                  'One Quran, Three Layouts',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: LineSelectionStyle.deepGreen,
                    fontFamily: LineSelectionStyle.displayFont,
                    fontSize: 17,
                    height: 1.1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Select the Mushaf format that\nbest matches your reading preference.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: LineSelectionStyle.bodyText,
                    fontFamily: LineSelectionStyle.bodyFont,
                    fontSize: 11,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 7,
            left: 0,
            right: 0,
            child: Icon(
              Icons.eco_rounded,
              color: LineSelectionStyle.lightGold,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterCurvePainter extends CustomPainter {
  const _FooterCurvePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, 22)
      ..cubicTo(
        size.width * 0.91,
        60,
        size.width * 0.73,
        68,
        size.width * 0.62,
        86,
      )
      ..cubicTo(
        size.width * 0.55,
        98,
        size.width * 0.52,
        110,
        size.width * 0.5,
        116,
      )
      ..cubicTo(
        size.width * 0.48,
        110,
        size.width * 0.45,
        98,
        size.width * 0.38,
        86,
      )
      ..cubicTo(size.width * 0.27, 68, size.width * 0.09, 52, 0, 22)
      ..close();
    final curve = _buildCurve(size);

    canvas.drawShadow(fill, Colors.black.withValues(alpha: 0.1), 8, false);
    canvas.drawPath(fill, Paint()..color = LineSelectionStyle.ivory);
    canvas.drawPath(
      curve,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = LineSelectionStyle.gold,
    );
  }

  Path _buildCurve(Size size) {
    return Path()
      ..moveTo(size.width, 22)
      ..cubicTo(
        size.width * 0.91,
        60,
        size.width * 0.73,
        68,
        size.width * 0.62,
        86,
      )
      ..cubicTo(
        size.width * 0.55,
        98,
        size.width * 0.52,
        110,
        size.width * 0.5,
        116,
      )
      ..cubicTo(
        size.width * 0.48,
        110,
        size.width * 0.45,
        98,
        size.width * 0.38,
        86,
      )
      ..cubicTo(size.width * 0.27, 68, size.width * 0.09, 52, 0, 22);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
