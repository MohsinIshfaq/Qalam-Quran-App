import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/mushaf_source.dart';

class PageNumberPanel extends StatefulWidget {
  const PageNumberPanel({
    required this.source,
    required this.initialPage,
    super.key,
  });

  final MushafSource source;
  final int initialPage;

  @override
  State<PageNumberPanel> createState() => _PageNumberPanelState();
}

class _PageNumberPanelState extends State<PageNumberPanel> {
  late final TextEditingController _pageController;
  late final FocusNode _pageFocusNode;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _pageController = TextEditingController(
      text: widget.initialPage.toString(),
    );
    _pageFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _pageFocusNode.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _submitDirectPage() {
    if (_isClosing) {
      return;
    }

    final page = int.tryParse(_pageController.text);
    if (page != null && mounted) {
      _isClosing = true;
      _pageFocusNode.unfocus();
      Get.back<int>(result: widget.source.pdfPageForDisplayPage(page));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Page #', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _DirectPageInput(
            controller: _pageController,
            focusNode: _pageFocusNode,
            firstPage: widget.source.firstDisplayPage,
            lastPage: widget.source.lastDisplayPage,
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
    required this.focusNode,
    required this.firstPage,
    required this.lastPage,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
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
              focusNode: focusNode,
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
