import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/mushaf_source.dart';
import '../../../common/utils/mushaf_labels.dart';

class BookmarkPanel extends StatelessWidget {
  const BookmarkPanel({
    required this.source,
    required this.bookmarks,
    super.key,
  });

  final MushafSource source;
  final List<int> bookmarks;

  @override
  Widget build(BuildContext context) {
    if (bookmarks.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text('No bookmarks yet')),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: bookmarks.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final page = bookmarks[index];
        final juz = source.juzForPage(page);

        return ListTile(
          onTap: () => Get.back<int>(result: page),
          leading: const Icon(Icons.bookmark),
          title: Text(displayPageLabel(source, page)),
          subtitle: Text('Para ${juz.number}'),
          trailing: const Icon(Icons.chevron_right),
        );
      },
    );
  }
}
