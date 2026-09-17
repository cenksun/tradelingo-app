import 'package:flutter/material.dart';

import '../palette.dart';
import '../tokens.dart';

/// Small pill used for counters, tags and statuses.
class TpBadge extends StatelessWidget {
  const TpBadge({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.background,
    this.dense = false,
    this.semanticLabel,
  });

  final String label;
  final IconData? icon;
  final Color? color;
  final Color? background;
  final bool dense;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final fg = color ?? c.textSecondary;
    return Semantics(
      label: semanticLabel ?? label,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? Gap.sm : Gap.md,
          vertical: dense ? Gap.xxs : Gap.xs,
        ),
        decoration: BoxDecoration(
          color: background ?? fg.withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(Radii.pill),
          border: Border.all(color: fg.withValues(alpha: 0.28)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: dense ? 12 : Sizes.iconSm, color: fg),
              const HGap(Gap.xs),
            ],
            Text(
              label,
              style:
                  (dense ? context.texts.labelSmall : context.texts.labelMedium)
                      ?.copyWith(color: fg),
            ),
          ],
        ),
      ),
    );
  }
}

/// Selectable chip used for filters.
class TpFilterChip extends StatelessWidget {
  const TpFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? c.accentSoft : c.surface,
        borderRadius: BorderRadius.circular(Radii.pill),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Radii.pill),
          child: Container(
            constraints: const BoxConstraints(minHeight: 38),
            padding: const EdgeInsets.symmetric(
              horizontal: Gap.lg,
              vertical: Gap.sm,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Radii.pill),
              border: Border.all(
                color: selected ? c.accent : c.border,
                width: selected ? 1.6 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  Icon(Icons.check_rounded, size: 15, color: c.accent),
                  const HGap(Gap.xs),
                ] else if (icon != null) ...[
                  Icon(icon, size: 15, color: c.textTertiary),
                  const HGap(Gap.xs),
                ],
                Text(
                  label,
                  style: context.texts.labelMedium?.copyWith(
                    color: selected ? c.accent : c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
