import 'package:flutter/material.dart';

class QalamMenuTile extends StatelessWidget {
  const QalamMenuTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.nightMode,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool nightMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final baseColor = nightMode
        ? const Color(0xFF121B17)
        : const Color(0xFFFFFCF5);
    final borderColor = nightMode
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFD9C8AA).withValues(alpha: 0.72);
    final titleColor = nightMode
        ? const Color(0xFFEAF5EF)
        : const Color(0xFF21312B);
    final subtitleColor = nightMode
        ? const Color(0xFFAABBB3)
        : const Color(0xFF6F6250);
    final accentColor = nightMode
        ? const Color(0xFF72D4BF)
        : const Color(0xFF075E4F);

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: nightMode ? 0.18 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: accentColor, size: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: titleColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: subtitleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
