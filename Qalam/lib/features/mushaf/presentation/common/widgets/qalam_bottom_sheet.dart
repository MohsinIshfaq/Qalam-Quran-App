import 'package:flutter/material.dart';

class QalamBottomSheet extends StatelessWidget {
  const QalamBottomSheet({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final maxSheetHeight =
        (mediaQuery.size.height - mediaQuery.padding.top) * 0.92;

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        clipBehavior: Clip.antiAlias,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        child: SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxSheetHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
