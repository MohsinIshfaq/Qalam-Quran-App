import 'package:flutter/material.dart';

import '../../../common/widgets/qalam_index_tile.dart';

class ParaMenuTile extends StatelessWidget {
  const ParaMenuTile({
    required this.number,
    required this.englishName,
    required this.arabicName,
    required this.subtitle,
    required this.height,
    required this.nightMode,
    required this.onTap,
    super.key,
  });

  final int number;
  final String englishName;
  final String arabicName;
  final String subtitle;
  final double height;
  final bool nightMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return QalamIndexTile(
      number: number,
      title: 'Para $number',
      englishName: englishName,
      arabicName: arabicName,
      subtitle: subtitle,
      height: height,
      nightMode: nightMode,
      onTap: onTap,
    );
  }
}
