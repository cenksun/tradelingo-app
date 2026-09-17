import 'package:flutter/material.dart';

import '../palette.dart';
import '../tokens.dart';

/// The primary content container. Everything that sits on the background uses
/// a [TpCard] so elevation, radius and border stay consistent.
class TpCard extends StatelessWidget {
  const TpCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Gap.lg),
    this.onTap,
    this.accent,
    this.raised = false,
    this.borderColor,
    this.semanticLabel,
    this.margin = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;

  /// Optional left accent stripe used to categorise cards (e.g. by world).
  final Color? accent;
  final bool raised;
  final Color? borderColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final content = Padding(
      padding: accent == null
          ? padding
          : padding.add(const EdgeInsets.only(left: 4)),
      child: child,
    );

    // The card's background is a Material rather than a DecoratedBox so that
    // ink effects from any child — list tiles, switches, buttons — paint on top
    // of it instead of being hidden behind it.
    //
    // The accent is a stripe stacked over the card rather than a stretched Row
    // child: a stretched Row needs a known height, which it does not have
    // inside a scrollable, and a non-uniform border cannot be combined with a
    // border radius.
    Widget body = Material(
      color: raised ? c.surfaceRaised : c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: Radii.cardRadius,
        side: BorderSide(color: borderColor ?? c.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: accent == null
          ? content
          : Stack(
              children: [
                content,
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 4,
                  child: ColoredBox(color: accent!),
                ),
              ],
            ),
    );

    if (onTap != null) {
      body = Material(
        color: raised ? c.surfaceRaised : c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.cardRadius,
          side: BorderSide(color: borderColor ?? c.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: accent == null
              ? content
              : Stack(
                  children: [
                    content,
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: 4,
                      child: ColoredBox(color: accent!),
                    ),
                  ],
                ),
        ),
      );
    }

    if (semanticLabel != null) {
      body = Semantics(
        label: semanticLabel,
        button: onTap != null,
        container: true,
        child: body,
      );
    }

    return Padding(padding: margin, child: body);
  }
}
