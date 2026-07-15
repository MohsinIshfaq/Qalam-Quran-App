import 'package:flutter/material.dart';

import 'home_icon_badge.dart';
import 'home_style.dart';

enum HomeMenuDecoration { pattern, arch, mosque }

class HomeMenuCard extends StatelessWidget {
  const HomeMenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.decoration,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final HomeMenuDecoration decoration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$title, $subtitle',
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: HomeStyle.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: HomeStyle.cardBorder),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 18,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _CardDecoration(decoration: decoration),
                  Positioned(
                    top: 18,
                    left: 18,
                    child: HomeIconBadge(icon: icon, size: 49, iconSize: 27),
                  ),
                  Positioned(
                    left: 18,
                    right: 12,
                    bottom: 49,
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: HomeStyle.deepGreen,
                        fontFamily: HomeStyle.displayFont,
                        fontSize: 17,
                        height: 1.1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    right: 48,
                    bottom: 22,
                    child: Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: HomeStyle.bodyText,
                        fontFamily: HomeStyle.bodyFont,
                        fontSize: 11.5,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 14,
                    bottom: 16,
                    child: HomeArrowButton(size: 31),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeSettingsCard extends StatelessWidget {
  const HomeSettingsCard({
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Settings, $subtitle',
      child: Material(
        color: Colors.transparent,
        child: Ink(
          height: 121,
          decoration: BoxDecoration(
            color: HomeStyle.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: HomeStyle.cardBorder),
            boxShadow: const [
              BoxShadow(
                color: Color(0x16000000),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    width: 150,
                    bottom: 0,
                    child: Opacity(
                      opacity: 0.24,
                      child: Image.asset(
                        HomeStyle.patternAsset,
                        fit: BoxFit.cover,
                        alignment: Alignment.centerRight,
                        excludeFromSemantics: true,
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 18,
                    top: 30,
                    child: HomeIconBadge(
                      icon: Icons.settings_outlined,
                      size: 55,
                      iconSize: 31,
                    ),
                  ),
                  const Positioned(
                    left: 91,
                    top: 35,
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        color: HomeStyle.deepGreen,
                        fontFamily: HomeStyle.displayFont,
                        fontSize: 21,
                        height: 1.1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 91,
                    top: 69,
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        color: HomeStyle.bodyText,
                        fontFamily: HomeStyle.bodyFont,
                        fontSize: 13,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 48,
                    top: -12,
                    bottom: -8,
                    width: 62,
                    child: Image.asset(
                      HomeStyle.lanternAsset,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      excludeFromSemantics: true,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  const Positioned(
                    right: 14,
                    top: 45,
                    child: HomeArrowButton(size: 36),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardDecoration extends StatelessWidget {
  const _CardDecoration({required this.decoration});

  final HomeMenuDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return switch (decoration) {
      HomeMenuDecoration.pattern => Positioned(
        top: 0,
        right: 0,
        width: 100,
        height: 100,
        child: Opacity(
          opacity: 0.24,
          child: Image.asset(
            HomeStyle.patternAsset,
            fit: BoxFit.cover,
            alignment: Alignment.topRight,
            excludeFromSemantics: true,
          ),
        ),
      ),
      HomeMenuDecoration.arch => Positioned(
        right: -6,
        bottom: -6,
        width: 88,
        child: Opacity(
          opacity: 0.43,
          child: Image.asset(
            HomeStyle.archAsset,
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
        ),
      ),
      HomeMenuDecoration.mosque => const Positioned(
        right: -4,
        bottom: -7,
        child: Icon(Icons.mosque_rounded, color: Color(0x160E4B3F), size: 96),
      ),
    };
  }
}
