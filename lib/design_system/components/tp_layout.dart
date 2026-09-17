import 'package:flutter/material.dart';

import '../palette.dart';
import '../tokens.dart';

/// Section heading with an optional trailing action.
class TpSectionHeader extends StatelessWidget {
  const TpSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(0, Gap.xxl, 0, Gap.md),
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.texts.titleMedium),
                if (subtitle != null) ...[
                  const VGap(Gap.xxs),
                  Text(subtitle!, style: context.texts.bodySmall),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// A labelled metric used in headers, reviews and analytics.
class TpStatTile extends StatelessWidget {
  const TpStatTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.valueColor,
    this.caption,
    this.compact = false,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;
  final String? caption;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return Semantics(
      label: '$label: $value',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 13, color: c.textTertiary),
                const HGap(Gap.xs),
              ],
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  style: context.texts.labelSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const VGap(Gap.xs),
          Text(
            value,
            style:
                (compact
                        ? context.texts.titleMedium
                        : context.texts.headlineSmall)
                    ?.copyWith(color: valueColor),
          ),
          if (caption != null) ...[
            const VGap(Gap.xxs),
            Text(caption!, style: context.texts.bodySmall),
          ],
        ],
      ),
    );
  }
}

/// Key/value row used in reviews and journal detail.
class TpDetailRow extends StatelessWidget {
  const TpDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.icon,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Gap.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: Sizes.iconSm, color: c.textTertiary),
            const HGap(Gap.sm),
          ],
          Expanded(child: Text(label, style: context.texts.bodyMedium)),
          const HGap(Gap.md),
          Text(
            value,
            style: context.texts.titleSmall?.copyWith(color: valueColor),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

/// Constrains page content on wide screens while staying edge-to-edge on
/// phones, which are the primary target.
class TpPageBody extends StatelessWidget {
  const TpPageBody({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: Gap.lg),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Sizes.maxContentWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// An informational callout. Used for the educational disclaimer and for
/// risk guardrail warnings.
class TpCallout extends StatelessWidget {
  const TpCallout({
    super.key,
    required this.message,
    this.title,
    this.icon = Icons.info_outline_rounded,
    this.tone = TpCalloutTone.info,
  });

  final String message;
  final String? title;
  final IconData icon;
  final TpCalloutTone tone;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final color = switch (tone) {
      TpCalloutTone.info => c.info,
      TpCalloutTone.warning => c.warning,
      TpCalloutTone.success => c.bullish,
      TpCalloutTone.danger => c.danger,
      TpCalloutTone.neutral => c.textTertiary,
    };
    return Container(
      padding: const EdgeInsets.all(Gap.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: Sizes.iconMd, color: color),
          const HGap(Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: context.texts.titleSmall?.copyWith(color: color),
                  ),
                  const VGap(Gap.xs),
                ],
                Text(
                  message,
                  style: context.texts.bodySmall?.copyWith(
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum TpCalloutTone { info, warning, success, danger, neutral }
