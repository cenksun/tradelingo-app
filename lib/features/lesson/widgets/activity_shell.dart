import 'package:flutter/material.dart';

import '../../../design_system/components.dart';
import '../../../domain/models/activity.dart';

/// Common frame for every activity: the prompt, an optional hint, and the
/// activity's own input below it.
class ActivityShell extends StatefulWidget {
  const ActivityShell({
    super.key,
    required this.activity,
    required this.child,
    this.instruction,
    this.scrollable = true,
  });

  final Activity activity;
  final Widget child;

  /// Extra guidance shown under the prompt, e.g. how to interact with a chart.
  final String? instruction;
  final bool scrollable;

  @override
  State<ActivityShell> createState() => _ActivityShellState();
}

class _ActivityShellState extends State<ActivityShell> {
  bool _hintVisible = false;

  @override
  void didUpdateWidget(covariant ActivityShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) _hintVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final hint = widget.activity.hint;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.activity.displayPrompt,
                style: context.texts.headlineSmall,
              ),
            ),
            if (hint != null) ...[
              const HGap(Gap.sm),
              TpIconButton(
                icon: _hintVisible
                    ? Icons.lightbulb_rounded
                    : Icons.lightbulb_outline_rounded,
                tooltip: 'Hint',
                color: _hintVisible ? c.warning : c.textTertiary,
                onPressed: () => setState(() => _hintVisible = !_hintVisible),
              ),
            ],
          ],
        ),
        if (widget.instruction != null) ...[
          const VGap(Gap.xs),
          Text(widget.instruction!, style: context.texts.bodySmall),
        ],
        if (hint != null && _hintVisible) ...[
          const VGap(Gap.md),
          TpCallout(
            message: hint,
            icon: Icons.lightbulb_outline_rounded,
            tone: TpCalloutTone.warning,
          ),
        ],
        const VGap(Gap.xl),
        widget.child,
      ],
    );

    if (!widget.scrollable) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.lg, Gap.lg, Gap.lg),
        child: content,
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.lg, Gap.lg, Gap.xxxl),
      child: content,
    );
  }
}

/// A selectable option row used by multiple choice, true/false and order type.
class ActivityOption extends StatelessWidget {
  const ActivityOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.detail,
    this.leading,
    this.enabled = true,
  });

  final String label;
  final String? detail;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return Padding(
      padding: const EdgeInsets.only(bottom: Gap.md),
      child: Semantics(
        button: true,
        selected: selected,
        enabled: enabled,
        child: Material(
          color: selected ? c.accentSoft : c.surface,
          borderRadius: BorderRadius.circular(Radii.md),
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(Radii.md),
            child: Container(
              constraints: const BoxConstraints(minHeight: Sizes.minTouch),
              padding: const EdgeInsets.symmetric(
                horizontal: Gap.lg,
                vertical: Gap.md,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Radii.md),
                border: Border.all(
                  color: selected ? c.accent : c.border,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  if (leading != null) ...[leading!, const HGap(Gap.md)],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: context.texts.titleSmall?.copyWith(
                            color: selected ? c.accent : c.textPrimary,
                          ),
                        ),
                        if (detail != null) ...[
                          const VGap(Gap.xxs),
                          Text(detail!, style: context.texts.bodySmall),
                        ],
                      ],
                    ),
                  ),
                  const HGap(Gap.sm),
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    size: 20,
                    color: selected ? c.accent : c.textTertiary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
