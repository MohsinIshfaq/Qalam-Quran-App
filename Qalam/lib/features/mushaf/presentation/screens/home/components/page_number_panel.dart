import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/mushaf_source.dart';

class PageNumberPanel extends StatelessWidget {
  const PageNumberPanel({
    required this.source,
    required this.pageController,
    super.key,
  });

  final MushafSource source;
  final TextEditingController pageController;

  void _submitDirectPage() {
    final page = int.tryParse(pageController.text);
    if (page != null) {
      Get.back<int>(result: source.pdfPageForDisplayPage(page));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        18,
        0,
        18,
        18 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Page #', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _DirectPageInput(
            controller: pageController,
            firstPage: source.firstDisplayPage,
            lastPage: source.lastDisplayPage,
            onSubmit: _submitDirectPage,
          ),
        ],
      ),
    );
  }
}

class _DirectPageInput extends StatelessWidget {
  const _DirectPageInput({
    required this.controller,
    required this.firstPage,
    required this.lastPage,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final int firstPage;
  final int lastPage;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                labelText: 'Page number',
                suffixText: '$firstPage-$lastPage',
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => onSubmit(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onSubmit,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Go'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
