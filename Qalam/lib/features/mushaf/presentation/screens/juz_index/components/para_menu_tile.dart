import 'package:flutter/material.dart';

class ParaMenuTile extends StatelessWidget {
  const ParaMenuTile({
    required this.number,
    required this.englishName,
    required this.arabicName,
    required this.subtitle,
    required this.nightMode,
    required this.onTap,
    super.key,
  });

  final int number;
  final String englishName;
  final String arabicName;
  final String subtitle;
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
    final accentColor = nightMode
        ? const Color(0xFF72D4BF)
        : const Color(0xFF075E4F);
    final titleColor = nightMode
        ? const Color(0xFFEAF5EF)
        : const Color(0xFF21312B);
    final subtitleColor = nightMode
        ? const Color(0xFFAABBB3)
        : const Color(0xFF6F6250);

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: nightMode ? 0.16 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 21,
                  backgroundColor: accentColor.withValues(alpha: 0.12),
                  child: Text(
                    number.toString(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Para $number',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        englishName,
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: subtitleColor,
                          fontWeight: FontWeight.w600,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 3),
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
                ),
                const SizedBox(width: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 132),
                  child: Text(
                    arabicName,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.end,
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
