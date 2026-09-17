import 'package:flutter/material.dart';

import '../palette.dart';
import '../tokens.dart';

enum TpButtonVariant { primary, secondary, ghost, danger, success }

enum TpButtonSize { small, medium, large }

/// The single button component used across TradePath.
class TpButton extends StatelessWidget {
  const TpButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = TpButtonVariant.primary,
    this.size = TpButtonSize.medium,
    this.icon,
    this.expand = false,
    this.busy = false,
    this.semanticLabel,
  });

  const TpButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = TpButtonSize.medium,
    this.icon,
    this.expand = true,
    this.busy = false,
    this.semanticLabel,
  }) : variant = TpButtonVariant.primary;

  const TpButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = TpButtonSize.medium,
    this.icon,
    this.expand = false,
    this.busy = false,
    this.semanticLabel,
  }) : variant = TpButtonVariant.secondary;

  const TpButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.size = TpButtonSize.medium,
    this.icon,
    this.expand = false,
    this.busy = false,
    this.semanticLabel,
  }) : variant = TpButtonVariant.ghost;

  final String label;
  final VoidCallback? onPressed;
  final TpButtonVariant variant;
  final TpButtonSize size;
  final IconData? icon;
  final bool expand;
  final bool busy;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final enabled = onPressed != null && !busy;

    final (Color bg, Color fg, Color? border) = switch (variant) {
      TpButtonVariant.primary => (c.accent, c.onAccent, null),
      TpButtonVariant.secondary => (
        c.surfaceRaised,
        c.textPrimary,
        c.borderStrong,
      ),
      TpButtonVariant.ghost => (Colors.transparent, c.textSecondary, null),
      TpButtonVariant.danger => (c.danger, Colors.white, null),
      TpButtonVariant.success => (c.bullish, Colors.white, null),
    };

    final height = switch (size) {
      TpButtonSize.small => 40.0,
      TpButtonSize.medium => Sizes.minTouch,
      TpButtonSize.large => 56.0,
    };
    final textStyle = switch (size) {
      TpButtonSize.small => context.texts.labelMedium,
      TpButtonSize.medium => context.texts.labelLarge,
      TpButtonSize.large => context.texts.titleMedium,
    };

    final child = busy
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: fg),
          )
        : Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: Sizes.iconMd, color: fg),
                const HGap(Gap.sm),
              ],
              Flexible(
                child: Text(
                  label,
                  style: textStyle?.copyWith(color: fg),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );

    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel ?? label,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: SizedBox(
          height: height,
          width: expand ? double.infinity : null,
          child: Material(
            color: bg,
            borderRadius: BorderRadius.circular(Radii.md),
            child: InkWell(
              onTap: enabled ? onPressed : null,
              borderRadius: BorderRadius.circular(Radii.md),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Radii.md),
                  border: border == null ? null : Border.all(color: border),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: size == TpButtonSize.small ? Gap.md : Gap.xl,
                ),
                alignment: Alignment.center,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A compact circular icon button that still meets the 48dp touch target.
class TpIconButton extends StatelessWidget {
  const TpIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.color,
    this.background,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final Color? color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        enabled: onPressed != null,
        child: SizedBox(
          width: Sizes.minTouch,
          height: Sizes.minTouch,
          child: Material(
            color: background ?? Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: Icon(
                icon,
                size: Sizes.iconLg,
                color: onPressed == null
                    ? c.textTertiary
                    : (color ?? c.textSecondary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
