import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/seeded_random.dart';
import '../../../design_system/components.dart';
import '../../../domain/models/activity.dart';
import '../../../domain/models/enums.dart';
import '../../../shared/chart/candle_chart.dart';
import '../../../data/market/synthetic_series_generator.dart';
import 'activity_shell.dart';

/// Signature every activity renderer uses to report the current answer.
/// A `null` response means "not answerable yet".
typedef ResponseChanged = void Function(ActivityResponse? response);

// ---------------------------------------------------------------------------
// 1. Explanation
// ---------------------------------------------------------------------------

class ExplanationView extends StatefulWidget {
  const ExplanationView({
    super.key,
    required this.activity,
    required this.onChanged,
  });

  final ExplanationActivity activity;
  final ResponseChanged onChanged;

  @override
  State<ExplanationView> createState() => _ExplanationViewState();
}

class _ExplanationViewState extends State<ExplanationView> {
  @override
  void initState() {
    super.initState();
    // Explanation cards are always "answered" — the learner just reads on.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.onChanged(const AcknowledgeResponse()),
    );
  }

  @override
  void didUpdateWidget(covariant ExplanationView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.onChanged(const AcknowledgeResponse()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final a = widget.activity;
    final recipe = a.chartRecipe;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.lg, Gap.lg, Gap.xxxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(a.title, style: context.texts.headlineMedium),
          const VGap(Gap.lg),
          Text(a.body, style: context.texts.bodyLarge),
          if (a.bullets.isNotEmpty) ...[
            const VGap(Gap.xl),
            TpCard(
              raised: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final bullet in a.bullets)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Gap.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(
                              top: 7,
                              right: Gap.md,
                            ),
                            decoration: BoxDecoration(
                              color: c.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              bullet,
                              style: context.texts.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
          if (recipe != null) ...[
            const VGap(Gap.xl),
            SizedBox(
              height: 220,
              child: CandleChart(
                candles: SyntheticSeriesGenerator.build(recipe).candles,
                interactive: false,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Multiple choice
// ---------------------------------------------------------------------------

class MultipleChoiceView extends StatefulWidget {
  const MultipleChoiceView({
    super.key,
    required this.activity,
    required this.onChanged,
  });

  final MultipleChoiceActivity activity;
  final ResponseChanged onChanged;

  @override
  State<MultipleChoiceView> createState() => _MultipleChoiceViewState();
}

class _MultipleChoiceViewState extends State<MultipleChoiceView> {
  int? _selected;

  @override
  void didUpdateWidget(covariant MultipleChoiceView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) _selected = null;
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.activity.chartRecipe;
    return ActivityShell(
      activity: widget.activity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (recipe != null) ...[
            SizedBox(
              height: 200,
              child: CandleChart(
                candles: SyntheticSeriesGenerator.build(recipe).candles,
                interactive: false,
              ),
            ),
            const VGap(Gap.xl),
          ],
          for (var i = 0; i < widget.activity.options.length; i++)
            ActivityOption(
              label: widget.activity.options[i],
              selected: _selected == i,
              onTap: () {
                setState(() => _selected = i);
                widget.onChanged(ChoiceResponse(i));
              },
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. True / false
// ---------------------------------------------------------------------------

class TrueFalseView extends StatefulWidget {
  const TrueFalseView({
    super.key,
    required this.activity,
    required this.onChanged,
  });

  final TrueFalseActivity activity;
  final ResponseChanged onChanged;

  @override
  State<TrueFalseView> createState() => _TrueFalseViewState();
}

class _TrueFalseViewState extends State<TrueFalseView> {
  bool? _selected;

  @override
  void didUpdateWidget(covariant TrueFalseView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) _selected = null;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return ActivityShell(
      activity: widget.activity,
      instruction: 'True or false?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ActivityOption(
            label: 'True',
            selected: _selected == true,
            leading: Icon(Icons.check_rounded, color: c.bullish),
            onTap: () {
              setState(() => _selected = true);
              widget.onChanged(const BoolResponse(true));
            },
          ),
          ActivityOption(
            label: 'False',
            selected: _selected == false,
            leading: Icon(Icons.close_rounded, color: c.bearish),
            onTap: () {
              setState(() => _selected = false);
              widget.onChanged(const BoolResponse(false));
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 15. Order type
// ---------------------------------------------------------------------------

class OrderTypeView extends StatefulWidget {
  const OrderTypeView({
    super.key,
    required this.activity,
    required this.onChanged,
  });

  final OrderTypeActivity activity;
  final ResponseChanged onChanged;

  @override
  State<OrderTypeView> createState() => _OrderTypeViewState();
}

class _OrderTypeViewState extends State<OrderTypeView> {
  OrderType? _selected;

  @override
  void didUpdateWidget(covariant OrderTypeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) _selected = null;
  }

  @override
  Widget build(BuildContext context) {
    return ActivityShell(
      activity: widget.activity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.activity.scenario.isNotEmpty) ...[
            TpCard(
              raised: true,
              child: Text(
                widget.activity.scenario,
                style: context.texts.bodyLarge,
              ),
            ),
            const VGap(Gap.xl),
          ],
          for (final type in OrderType.values)
            ActivityOption(
              label: '${type.label} order',
              detail: type.description,
              selected: _selected == type,
              onTap: () {
                setState(() => _selected = type);
                widget.onChanged(OrderTypeResponse(type));
              },
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 17. Spot the mistake
// ---------------------------------------------------------------------------

class SpotMistakeView extends StatefulWidget {
  const SpotMistakeView({
    super.key,
    required this.activity,
    required this.onChanged,
  });

  final SpotMistakeActivity activity;
  final ResponseChanged onChanged;

  @override
  State<SpotMistakeView> createState() => _SpotMistakeViewState();
}

class _SpotMistakeViewState extends State<SpotMistakeView> {
  int? _selected;

  @override
  void didUpdateWidget(covariant SpotMistakeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) _selected = null;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return ActivityShell(
      activity: widget.activity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TpCard(
            raised: true,
            accent: c.warning,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.format_quote_rounded, color: c.textTertiary),
                const HGap(Gap.md),
                Expanded(
                  child: Text(
                    widget.activity.scenario,
                    style: context.texts.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VGap(Gap.xl),
          for (var i = 0; i < widget.activity.options.length; i++)
            ActivityOption(
              label: widget.activity.options[i],
              selected: _selected == i,
              onTap: () {
                setState(() => _selected = i);
                widget.onChanged(ChoiceResponse(i));
              },
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 13 & 14. Numeric answers
// ---------------------------------------------------------------------------

class NumericAnswerView extends StatefulWidget {
  const NumericAnswerView({
    super.key,
    required this.activity,
    required this.onChanged,
    this.suffix,
    this.helper,
  });

  final Activity activity;
  final ResponseChanged onChanged;
  final String? suffix;
  final String? helper;

  @override
  State<NumericAnswerView> createState() => _NumericAnswerViewState();
}

class _NumericAnswerViewState extends State<NumericAnswerView> {
  final _controller = TextEditingController();

  @override
  void didUpdateWidget(covariant NumericAnswerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _emit(String raw) {
    final cleaned = raw.replaceAll(',', '').replaceAll(r'$', '').trim();
    final value = double.tryParse(cleaned);
    widget.onChanged(value == null ? null : NumericResponse(value));
  }

  @override
  Widget build(BuildContext context) {
    return ActivityShell(
      activity: widget.activity,
      instruction: widget.helper,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\-]')),
            ],
            style: context.texts.headlineSmall,
            textAlign: TextAlign.center,
            autofocus: false,
            decoration: InputDecoration(
              hintText: '0.00',
              suffixText: widget.suffix,
            ),
            onChanged: _emit,
          ),
          const VGap(Gap.md),
          Text(
            'Enter a number. Rounding to two decimals is fine.',
            style: context.texts.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 16. Sequence ordering
// ---------------------------------------------------------------------------

class SequenceOrderingView extends StatefulWidget {
  const SequenceOrderingView({
    super.key,
    required this.activity,
    required this.onChanged,
  });

  final SequenceOrderingActivity activity;
  final ResponseChanged onChanged;

  @override
  State<SequenceOrderingView> createState() => _SequenceOrderingViewState();
}

class _SequenceOrderingViewState extends State<SequenceOrderingView> {
  late List<int> _order;

  @override
  void initState() {
    super.initState();
    _shuffle();
  }

  @override
  void didUpdateWidget(covariant SequenceOrderingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) _shuffle();
  }

  void _shuffle() {
    final indices = List.generate(
      widget.activity.stepsInOrder.length,
      (i) => i,
    );
    // Seeded so the same exercise shuffles the same way every time it appears.
    final rnd = SeededRandom.fromString(widget.activity.id, 7);
    _order = rnd.shuffled(indices);
    if (_listEquals(_order, indices) && _order.length > 1) {
      final tmp = _order[0];
      _order[0] = _order[1];
      _order[1] = tmp;
    }
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.onChanged(SequenceResponse(List.of(_order))),
    );
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return ActivityShell(
      activity: widget.activity,
      instruction: 'Drag the steps into the order they should happen.',
      scrollable: false,
      child: Expanded(
        child: ReorderableListView.builder(
          buildDefaultDragHandles: false,
          itemCount: _order.length,
          // onReorderItem already accounts for the removed item, so the
          // index does not need adjusting here.
          onReorderItem: (oldIndex, newIndex) {
            setState(() {
              final item = _order.removeAt(oldIndex);
              _order.insert(newIndex, item);
            });
            widget.onChanged(SequenceResponse(List.of(_order)));
          },
          itemBuilder: (context, index) {
            final stepIndex = _order[index];
            return Padding(
              key: ValueKey('${widget.activity.id}_$stepIndex'),
              padding: const EdgeInsets.only(bottom: Gap.sm),
              child: ReorderableDragStartListener(
                index: index,
                child: TpCard(
                  raised: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Gap.md,
                    vertical: Gap.md,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: c.accentSoft,
                          borderRadius: BorderRadius.circular(Radii.sm),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: context.texts.labelMedium?.copyWith(
                            color: c.accent,
                          ),
                        ),
                      ),
                      const HGap(Gap.md),
                      Expanded(
                        child: Text(
                          widget.activity.stepsInOrder[stepIndex],
                          style: context.texts.bodyMedium?.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                      ),
                      Icon(Icons.drag_handle_rounded, color: c.textTertiary),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 18. Matching
// ---------------------------------------------------------------------------

class MatchingView extends StatefulWidget {
  const MatchingView({
    super.key,
    required this.activity,
    required this.onChanged,
  });

  final MatchingActivity activity;
  final ResponseChanged onChanged;

  @override
  State<MatchingView> createState() => _MatchingViewState();
}

class _MatchingViewState extends State<MatchingView> {
  late List<int> _shuffledDefinitions;
  final Map<int, int> _pairs = {};

  @override
  void initState() {
    super.initState();
    _reset();
  }

  @override
  void didUpdateWidget(covariant MatchingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) _reset();
  }

  void _reset() {
    _pairs.clear();
    final rnd = SeededRandom.fromString(widget.activity.id, 13);
    _shuffledDefinitions = rnd.shuffled(
      List.generate(widget.activity.definitions.length, (i) => i),
    );
  }

  void _emit() {
    if (_pairs.length == widget.activity.terms.length) {
      widget.onChanged(MatchResponse(Map.of(_pairs)));
    } else {
      widget.onChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return ActivityShell(
      activity: widget.activity,
      instruction: 'Pick the definition that belongs to each term.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var t = 0; t < widget.activity.terms.length; t++)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.lg),
              child: TpCard(
                raised: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.activity.terms[t],
                      style: context.texts.titleSmall,
                    ),
                    const VGap(Gap.md),
                    DropdownButtonFormField<int>(
                      initialValue: _pairs[t],
                      isExpanded: true,
                      hint: const Text('Choose a definition'),
                      dropdownColor: c.surfaceRaised,
                      items: [
                        for (final d in _shuffledDefinitions)
                          DropdownMenuItem(
                            value: d,
                            child: Text(
                              widget.activity.definitions[d],
                              style: context.texts.bodySmall,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          // A definition can only be used once, so clear any
                          // other term currently holding it.
                          _pairs.removeWhere((_, v) => v == value);
                          _pairs[t] = value;
                        });
                        _emit();
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
