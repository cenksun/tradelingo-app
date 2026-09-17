import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatters.dart';
import '../../data/scenarios/scenario_generator.dart';
import '../../design_system/components.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/market.dart';
import '../../domain/models/scenario.dart';
import '../../domain/services/recommendation_engine.dart';
import '../learn/learner_controller.dart';

/// Filters chosen in the custom simulation sheet, passed to the run screen.
class SimulatorLaunchOptions {
  const SimulatorLaunchOptions({
    this.assetClass,
    this.assetSymbol,
    this.timeframe,
    this.difficulty,
    this.marketCondition,
    this.feature,
  });

  final AssetClass? assetClass;
  final String? assetSymbol;
  final Timeframe? timeframe;
  final Difficulty? difficulty;
  final MarketCondition? marketCondition;
  final ScenarioFeature? feature;

  ScenarioQuery toQuery() => ScenarioQuery(
    assetClass: assetClass,
    assetSymbol: assetSymbol,
    timeframe: timeframe,
    difficulty: difficulty,
    marketCondition: marketCondition,
    requiredFeatures: feature == null ? const {} : {feature!},
  );

  Map<String, String> toQueryParameters() => {
    'class': ?assetClass?.name,
    'asset': ?assetSymbol,
    'tf': ?timeframe?.name,
    'difficulty': ?difficulty?.name,
    'condition': ?marketCondition?.name,
    'feature': ?feature?.name,
  };

  static SimulatorLaunchOptions fromQueryParameters(Map<String, String> p) {
    AssetClass? assetClass;
    if (p['class'] != null) {
      assetClass = AssetClass.values
          .where((a) => a.name == p['class'])
          .firstOrNull;
    }
    Timeframe? timeframe;
    if (p['tf'] != null) {
      timeframe = Timeframe.values.where((t) => t.name == p['tf']).firstOrNull;
    }
    Difficulty? difficulty;
    if (p['difficulty'] != null) {
      difficulty = Difficulty.values
          .where((d) => d.name == p['difficulty'])
          .firstOrNull;
    }
    MarketCondition? condition;
    if (p['condition'] != null) {
      condition = MarketCondition.values
          .where((m) => m.name == p['condition'])
          .firstOrNull;
    }
    ScenarioFeature? feature;
    if (p['feature'] != null) {
      feature = ScenarioFeature.fromName(p['feature']!);
    }
    return SimulatorLaunchOptions(
      assetClass: assetClass,
      assetSymbol: p['asset'],
      timeframe: timeframe,
      difficulty: difficulty,
      marketCondition: condition,
      feature: feature,
    );
  }
}

class SimulatorHubScreen extends ConsumerWidget {
  const SimulatorHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.tp;
    final state = ref.watch(learnerControllerProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulate'),
        actions: [
          TpIconButton(
            icon: Icons.insights_rounded,
            tooltip: 'Analytics',
            onPressed: () => context.push('/analytics'),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Gap.lg, 0, Gap.lg, Gap.huge),
          children: [
            if (state != null) _AccountCard(state: state),
            const VGap(Gap.lg),
            const TpCallout(
              icon: Icons.account_balance_wallet_outlined,
              message:
                  'Every balance here is virtual and every chart is educational data. No real '
                  'orders are placed.',
            ),
            const TpSectionHeader(
              title: 'Start a simulation',
              subtitle: 'An unfamiliar chart with the right-hand side hidden.',
            ),
            _ModeCard(
              icon: Icons.bolt_rounded,
              color: c.accent,
              title: 'Quick simulation',
              body:
                  'A random scenario from the full library — any instrument, any '
                  'timeframe, any condition.',
              onTap: () => context.push('/simulate/run'),
            ),
            const VGap(Gap.md),
            _ModeCard(
              icon: Icons.tune_rounded,
              color: c.info,
              title: 'Custom simulation',
              body: 'Choose the market, timeframe, difficulty and condition.',
              onTap: () => _openCustomSheet(context),
            ),
            const VGap(Gap.md),
            _ModeCard(
              icon: Icons.trending_down_rounded,
              color: c.warning,
              title: 'Weakness practice',
              body: state == null
                  ? 'Targets whatever your journal and skills say needs work.'
                  : _weaknessSubtitle(state),
              onTap: () => context.push('/simulate/run?${_weaknessQuery(ref)}'),
            ),
            const TpSectionHeader(
              title: 'How scoring works',
              subtitle: 'What the simulator is actually measuring.',
            ),
            TpCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ScoreRow(
                    label: 'Risk discipline',
                    weight: '30%',
                    body: 'How much of the virtual account you put at risk.',
                  ),
                  _ScoreRow(
                    label: 'Invalidation logic',
                    weight: '22%',
                    body: 'Whether the stop sits beyond the swing that defines the idea.',
                  ),
                  _ScoreRow(
                    label: 'Reward-to-risk',
                    weight: '20%',
                    body: 'How far the target is relative to the distance risked.',
                  ),
                  _ScoreRow(
                    label: 'Stop vs normal movement',
                    weight: '13%',
                    body: 'Whether the stop sits outside ordinary noise for this chart.',
                  ),
                  _ScoreRow(
                    label: 'Direction reasoning',
                    weight: '15%',
                    body: 'Graded only where the structure is clear enough to have a view.',
                    last: true,
                  ),
                  const VGap(Gap.md),
                  Text(
                    'Simulated profit is reported but is deliberately not part of the score.',
                    style: context.texts.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _weaknessSubtitle(dynamic state) {
    final weakest = RecommendationEngine.weakestSkills(
      state.mastery.values.toList(),
      limit: 1,
    );
    if (weakest.isEmpty) {
      return 'Targets whatever your journal and skills say needs work.';
    }
    return 'Focused on conditions that test your weakest area.';
  }

  static String _weaknessQuery(WidgetRef ref) {
    final state = ref.read(learnerControllerProvider).value;
    if (state == null) return 'difficulty=intermediate';
    final weakest = RecommendationEngine.weakestSkills(
      state.mastery.values.toList(),
      limit: 1,
    );
    if (weakest.isEmpty) return 'difficulty=intermediate';
    // Map the weak skill to a scenario feature that exercises it.
    final feature = switch (weakest.first.skillId) {
      'market_structure' => ScenarioFeature.breakOfStructure,
      'trend_reading' => ScenarioFeature.pullback,
      'support_resistance' => ScenarioFeature.supportTest,
      'liquidity' => ScenarioFeature.liquiditySweep,
      'price_action' => ScenarioFeature.fairValueGap,
      _ => null,
    };
    return feature == null ? 'difficulty=advanced' : 'feature=${feature.name}';
  }

  Future<void> _openCustomSheet(BuildContext context) async {
    final options = await showModalBottomSheet<SimulatorLaunchOptions>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _CustomSimulationSheet(),
    );
    if (options == null || !context.mounted) return;
    final params = options.toQueryParameters();
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    context.push('/simulate/run${query.isEmpty ? '' : '?$query'}');
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.state});
  final dynamic state;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final account = state.account;
    final change = account.balance - account.startingBalance;
    return TpCard(
      raised: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('VIRTUAL ACCOUNT', style: context.texts.labelSmall),
              const Spacer(),
              TpBadge(
                label: '${account.tradeCount} trades',
                dense: true,
                color: c.textTertiary,
              ),
            ],
          ),
          const VGap(Gap.sm),
          Text(Fmt.money(account.balance), style: context.texts.displaySmall),
          const VGap(Gap.xs),
          Row(
            children: [
              Icon(
                change >= 0
                    ? Icons.north_east_rounded
                    : Icons.south_east_rounded,
                size: 14,
                color: change >= 0 ? c.bullish : c.bearish,
              ),
              const HGap(Gap.xs),
              Text(
                '${Fmt.signedMoney(change)} from ${Fmt.money(account.startingBalance)}',
                style: context.texts.bodySmall,
              ),
            ],
          ),
          const VGap(Gap.md),
          Row(
            children: [
              Expanded(
                child: TpStatTile(
                  label: 'Peak',
                  value: Fmt.money(account.peakBalance),
                  compact: true,
                ),
              ),
              Expanded(
                child: TpStatTile(
                  label: 'Drawdown',
                  value: Fmt.percentOfRatio(
                    account.drawdownFraction,
                    decimals: 1,
                  ),
                  compact: true,
                  valueColor: account.drawdownFraction > 0.2 ? c.bearish : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return TpCard(
      onTap: onTap,
      accent: color,
      semanticLabel: title,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const HGap(Gap.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.texts.titleMedium),
                const VGap(Gap.xxs),
                Text(body, style: context.texts.bodySmall),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: c.textTertiary),
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({
    required this.label,
    required this.weight,
    required this.body,
    this.last = false,
  });

  final String label;
  final String weight;
  final String body;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : Gap.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 42,
            child: Text(
              weight,
              style: context.texts.labelMedium?.copyWith(color: c.accent),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.texts.titleSmall),
                Text(body, style: context.texts.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomSimulationSheet extends StatefulWidget {
  const _CustomSimulationSheet();

  @override
  State<_CustomSimulationSheet> createState() => _CustomSimulationSheetState();
}

class _CustomSimulationSheetState extends State<_CustomSimulationSheet> {
  AssetClass? _assetClass;
  String? _asset;
  Timeframe? _timeframe;
  Difficulty? _difficulty;
  MarketCondition? _condition;

  @override
  Widget build(BuildContext context) {
    final assets = _assetClass == null
        ? AssetCatalog.all
        : AssetCatalog.byClass(_assetClass!);

    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(Gap.lg, 0, Gap.lg, Gap.xxl),
        children: [
          Text('Custom simulation', style: context.texts.headlineSmall),
          const VGap(Gap.xs),
          Text(
            'Leave anything unset to let the engine choose.',
            style: context.texts.bodySmall,
          ),
          _FilterGroup(
            title: 'Market',
            children: [
              for (final value in AssetCatalog.classes)
                TpFilterChip(
                  label: value.label,
                  selected: _assetClass == value,
                  onTap: () => setState(() {
                    _assetClass = _assetClass == value ? null : value;
                    _asset = null;
                  }),
                ),
            ],
          ),
          _FilterGroup(
            title: 'Instrument',
            children: [
              for (final asset in assets)
                TpFilterChip(
                  label: asset.symbol,
                  selected: _asset == asset.symbol,
                  onTap: () => setState(
                    () => _asset = _asset == asset.symbol ? null : asset.symbol,
                  ),
                ),
            ],
          ),
          _FilterGroup(
            title: 'Timeframe',
            children: [
              for (final tf in Timeframe.values)
                TpFilterChip(
                  label: tf.label,
                  selected: _timeframe == tf,
                  onTap: () =>
                      setState(() => _timeframe = _timeframe == tf ? null : tf),
                ),
            ],
          ),
          _FilterGroup(
            title: 'Difficulty',
            children: [
              for (final d in Difficulty.values)
                TpFilterChip(
                  label: d.label,
                  selected: _difficulty == d,
                  onTap: () =>
                      setState(() => _difficulty = _difficulty == d ? null : d),
                ),
            ],
          ),
          _FilterGroup(
            title: 'Market condition',
            children: [
              for (final m in MarketCondition.values)
                TpFilterChip(
                  label: m.label,
                  selected: _condition == m,
                  onTap: () =>
                      setState(() => _condition = _condition == m ? null : m),
                ),
            ],
          ),
          const VGap(Gap.xl),
          TpButton.primary(
            label: 'Start simulation',
            size: TpButtonSize.large,
            onPressed: () => Navigator.of(context).pop(
              SimulatorLaunchOptions(
                assetClass: _assetClass,
                assetSymbol: _asset,
                timeframe: _timeframe,
                difficulty: _difficulty,
                marketCondition: _condition,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterGroup extends StatelessWidget {
  const _FilterGroup({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TpSectionHeader(
          title: title,
          padding: const EdgeInsets.fromLTRB(0, Gap.xl, 0, Gap.md),
        ),
        Wrap(spacing: Gap.sm, runSpacing: Gap.sm, children: children),
      ],
    );
  }
}
