import 'package:flutter/material.dart';

import '../../../../domain/entities/mushaf_source.dart';
import '../../../common/utils/mushaf_labels.dart';

class ReaderSettingsPanel extends StatelessWidget {
  const ReaderSettingsPanel({
    required this.source,
    required this.currentPage,
    required this.currentJuz,
    required this.nightMode,
    required this.isBookmarked,
    required this.onToggleNightMode,
    required this.onToggleBookmark,
    super.key,
  });

  final MushafSource source;
  final int currentPage;
  final JuzInfo currentJuz;
  final bool nightMode;
  final bool isBookmarked;
  final VoidCallback onToggleNightMode;
  final VoidCallback onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Setting', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.menu_book_outlined, color: colorScheme.primary),
            title: Text(displayPageLabel(source, currentPage)),
            subtitle: Text('Para ${currentJuz.number}'),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Night mode'),
            value: nightMode,
            onChanged: (_) => onToggleNightMode(),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? colorScheme.primary : null,
            ),
            title: Text(isBookmarked ? 'Remove bookmark' : 'Bookmark page'),
            onTap: onToggleBookmark,
          ),
        ],
      ),
    );
  }
}
