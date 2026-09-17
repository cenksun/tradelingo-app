import 'package:flutter/material.dart';

import '../palette.dart';
import '../tokens.dart';
import 'tp_button.dart';

/// Shown when a list has no content yet. Always offers a next action when one
/// exists, so an empty screen is never a dead end.
class TpEmptyState extends StatelessWidget {
  const TpEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Gap.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: c.surfaceSunken,
                shape: BoxShape.circle,
                border: Border.all(color: c.border),
              ),
              child: Icon(icon, size: 32, color: c.textTertiary),
            ),
            const VGap(Gap.lg),
            Text(
              title,
              style: context.texts.titleMedium,
              textAlign: TextAlign.center,
            ),
            const VGap(Gap.sm),
            Text(
              message,
              style: context.texts.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const VGap(Gap.xl),
              TpButton.secondary(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shown when something failed. Presents a readable message plus a retry.
class TpErrorState extends StatelessWidget {
  const TpErrorState({
    super.key,
    required this.message,
    this.hint,
    this.onRetry,
    this.title = 'Something went wrong',
  });

  final String title;
  final String message;
  final String? hint;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Gap.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded, size: 40, color: c.warning),
            const VGap(Gap.lg),
            Text(
              title,
              style: context.texts.titleMedium,
              textAlign: TextAlign.center,
            ),
            const VGap(Gap.sm),
            Text(
              message,
              style: context.texts.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (hint != null) ...[
              const VGap(Gap.sm),
              Text(
                hint!,
                style: context.texts.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const VGap(Gap.xl),
              TpButton.secondary(
                label: 'Try again',
                icon: Icons.refresh_rounded,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Neutral loading state with an accessible label.
class TpLoadingState extends StatelessWidget {
  const TpLoadingState({super.key, this.message = 'Loading…'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: message,
        liveRegion: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.6),
            ),
            const VGap(Gap.lg),
            Text(message, style: context.texts.bodySmall),
          ],
        ),
      ),
    );
  }
}
