import 'package:flutter/material.dart';

import 'home_style.dart';

class HomeIconBadge extends StatelessWidget {
  const HomeIconBadge({
    required this.icon,
    this.size = 52,
    this.iconSize = 29,
    super.key,
  });

  final IconData icon;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [HomeStyle.richGreen, HomeStyle.darkGreen],
        ),
        border: Border.all(color: HomeStyle.gold),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Icon(icon, color: HomeStyle.lightGold, size: iconSize),
    );
  }
}

class HomeArrowButton extends StatelessWidget {
  const HomeArrowButton({this.filled = false, this.size = 36, super.key});

  final bool filled;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: filled ? HomeStyle.deepGreen : HomeStyle.card,
        shape: BoxShape.circle,
        border: Border.all(
          color: filled ? HomeStyle.lightGold : HomeStyle.cardBorder,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 9,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.chevron_right_rounded,
        color: filled ? HomeStyle.lightGold : HomeStyle.deepGreen,
        size: size * 0.64,
      ),
    );
  }
}
