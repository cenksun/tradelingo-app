import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/market/synthetic_series_generator.dart';
import '../../design_system/components.dart';
import '../../domain/models/chart_series.dart';
import '../../domain/models/enums.dart';
import '../../shared/avatars.dart';
import '../../shared/chart/candle_chart.dart';
import '../learn/learner_controller.dart';

/// The educational disclaimer, shown once during onboarding and again in
/// settings. It is deliberately not repeated on every screen.
const String kEducationalDisclaimer =
    'TradePath is an educational simulation product. It does not provide investment advice or '
    'guarantee future results. Historical or simulated performance does not guarantee future '
    'performance. Real trading can result in financial loss.';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  final _nameController = TextEditingController();

  int _page = 0;
  ExperienceLevel? _experience;
  int? _goal;
  String _avatar = 'avatar_01';
  bool _saving = false;

  static const int _pageCount = 6;

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool get _canContinue => switch (_page) {
    3 => _experience != null,
    4 => _goal != null,
    _ => true,
  };

  Future<void> _next() async {
    if (_page < _pageCount - 1) {
      setState(() => _page++);
      await _controller.animateToPage(
        _page,
        duration: Motion.normal,
        curve: Motion.enter,
      );
      return;
    }
    await _finish();
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    await ref
        .read(learnerControllerProvider.notifier)
        .completeOnboarding(
          username: _nameController.text,
          level: _experience ?? ExperienceLevel.beginner,
          dailyGoalMinutes: _goal ?? 10,
          avatarId: _avatar,
        );
    if (!mounted) return;
    setState(() => _saving = false);
    // Straight into the first lesson, not a feature tour.
    context.go('/learn');
  }

  void _back() {
    if (_page == 0) return;
    setState(() => _page--);
    _controller.animateToPage(
      _page,
      duration: Motion.normal,
      curve: Motion.enter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Gap.lg,
                Gap.md,
                Gap.lg,
                Gap.sm,
              ),
              child: Row(
                children: [
                  if (_page > 0)
                    TpIconButton(
                      icon: Icons.arrow_back_rounded,
                      onPressed: _back,
                      tooltip: 'Back',
                    )
                  else
                    const SizedBox(width: Sizes.minTouch),
                  Expanded(
                    child: TpStepBar(total: _pageCount, completed: _page + 1),
                  ),
                  const SizedBox(width: Sizes.minTouch),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _WelcomePage(accent: c.accent),
                  const _HowLessonsWorkPage(),
                  const _SimulationsPage(),
                  _ExperiencePage(
                    selected: _experience,
                    onSelect: (v) => setState(() => _experience = v),
                  ),
                  _GoalPage(
                    selected: _goal,
                    onSelect: (v) => setState(() => _goal = v),
                  ),
                  _IdentityPage(
                    controller: _nameController,
                    avatar: _avatar,
                    onAvatar: (v) => setState(() => _avatar = v),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Gap.lg),
              child: TpButton.primary(
                label: _page == _pageCount - 1 ? 'Start learning' : 'Continue',
                busy: _saving,
                size: TpButtonSize.large,
                onPressed: _canContinue ? _next : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  const _OnboardPage({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: TpPageBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VGap(Gap.lg),
            Text(title, style: context.texts.headlineLarge),
            const VGap(Gap.sm),
            Text(subtitle, style: context.texts.bodyLarge),
            const VGap(Gap.xxl),
            ...children,
            const VGap(Gap.xxl),
          ],
        ),
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.accent});
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final series = SyntheticSeriesGenerator.build(
      const ChartRecipe(
        seed: 20240101,
        pattern: ChartPattern.uptrend,
        difficulty: Difficulty.beginner,
      ),
    );
    return _OnboardPage(
      title: 'TradePath',
      subtitle:
          'Learn to read charts and manage risk, one short lesson at a time — with a simulator '
          'that grades how you decide rather than whether you got lucky.',
      children: [
        SizedBox(
          height: 170,
          child: CandleChart(
            candles: series.candles,
            interactive: false,
            showTimeAxis: false,
            semanticLabel: 'An example candlestick chart in an uptrend.',
          ),
        ),
        const VGap(Gap.xl),
        const _Bullet(
          icon: Icons.school_rounded,
          title: 'Twelve worlds',
          body: 'From what a market is, through structure and risk, to building a process.',
        ),
        const _Bullet(
          icon: Icons.candlestick_chart_rounded,
          title: 'Real chart work',
          body: 'Tap candles, label structure and place stops on charts that change every time.',
        ),
        const _Bullet(
          icon: Icons.shield_rounded,
          title: 'Process over profit',
          body: 'A reckless trade that wins still scores badly. That is the point.',
        ),
        const VGap(Gap.lg),
        const TpCallout(
          title: 'Before you start',
          message: kEducationalDisclaimer,
          icon: Icons.info_outline_rounded,
        ),
      ],
    );
  }
}

class _HowLessonsWorkPage extends StatelessWidget {
  const _HowLessonsWorkPage();

  @override
  Widget build(BuildContext context) {
    return const _OnboardPage(
      title: 'How lessons work',
      subtitle:
          'Each lesson is a short run of explanations and exercises. Finish one and the next '
          'unlocks.',
      children: [
        _Bullet(
          icon: Icons.menu_book_rounded,
          title: 'Explain, then practise',
          body: 'Every idea is introduced and then used straight away on a chart or a question.',
        ),
        _Bullet(
          icon: Icons.favorite_rounded,
          title: 'Hearts',
          body:
              'Wrong answers cost a heart. Run out and you can practise to get them back — you '
              'are never locked out of learning.',
        ),
        _Bullet(
          icon: Icons.bolt_rounded,
          title: 'XP and levels',
          body:
              'XP measures how much you have done. Skill mastery, tracked separately, measures '
              'how well you currently do it.',
        ),
        _Bullet(
          icon: Icons.replay_rounded,
          title: 'Review',
          body: 'Anything you get wrong comes back later, spaced out so it actually sticks.',
        ),
        _Bullet(
          icon: Icons.military_tech_rounded,
          title: 'Boss challenges',
          body: 'Each world ends with a mixed challenge. Pass it to open the next world.',
        ),
      ],
    );
  }
}

class _SimulationsPage extends StatelessWidget {
  const _SimulationsPage();

  @override
  Widget build(BuildContext context) {
    return _OnboardPage(
      title: 'Simulations',
      subtitle:
          'You get an unfamiliar chart with the right-hand side hidden. Decide, then watch it '
          'play out.',
      children: [
        const _Bullet(
          icon: Icons.visibility_off_rounded,
          title: 'No peeking',
          body:
              'Future candles are not in the app\'s memory for that screen until you have '
              'committed a decision. You cannot accidentally see the answer.',
        ),
        const _Bullet(
          icon: Icons.trending_flat_rounded,
          title: 'Long, short or nothing',
          body:
              'Standing aside is a real answer, and on unclear charts it is usually the '
              'strongest one.',
        ),
        const _Bullet(
          icon: Icons.calculate_rounded,
          title: 'Risk first',
          body:
              'Position size is calculated from your risk and your stop distance — never chosen '
              'by feel.',
        ),
        const _Bullet(
          icon: Icons.insights_rounded,
          title: 'Process score',
          body:
              'Risk discipline, invalidation logic and reward-to-risk are graded. The profit is '
              'reported but it is not what scores.',
        ),
        const VGap(Gap.md),
        const TpCallout(
          tone: TpCalloutTone.warning,
          title: 'All money here is virtual',
          message:
              'The simulator uses a virtual balance and educational chart data. No real orders '
              'are placed and no real money is involved.',
          icon: Icons.account_balance_wallet_outlined,
        ),
      ],
    );
  }
}

class _ExperiencePage extends StatelessWidget {
  const _ExperiencePage({required this.selected, required this.onSelect});

  final ExperienceLevel? selected;
  final ValueChanged<ExperienceLevel> onSelect;

  @override
  Widget build(BuildContext context) {
    return _OnboardPage(
      title: 'Where are you starting?',
      subtitle: 'This sets the tone of the early lessons. You can still do all of them.',
      children: [
        for (final level in ExperienceLevel.values) ...[
          _ChoiceCard(
            title: level.label,
            subtitle: level.description,
            selected: selected == level,
            onTap: () => onSelect(level),
          ),
          const VGap(Gap.md),
        ],
      ],
    );
  }
}

class _GoalPage extends StatelessWidget {
  const _GoalPage({required this.selected, required this.onSelect});

  final int? selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    const options = [5, 10, 15, 20];
    return _OnboardPage(
      title: 'Daily goal',
      subtitle: 'A target to aim at, not a rule. Consistency matters more than the number you pick.',
      children: [
        for (final minutes in options) ...[
          _ChoiceCard(
            title: '$minutes minutes a day',
            subtitle: switch (minutes) {
              5 => 'One short lesson. Easy to keep up.',
              10 => 'A lesson and a review. A good default.',
              15 => 'A lesson, a review and a simulation.',
              _ => 'A serious daily session.',
            },
            selected: selected == minutes,
            onTap: () => onSelect(minutes),
          ),
          const VGap(Gap.md),
        ],
        const TpCallout(
          message:
              'TradePath never asks for brokerage credentials, account numbers or any financial '
              'details. Everything stays on this device.',
          icon: Icons.lock_outline_rounded,
          tone: TpCalloutTone.neutral,
        ),
      ],
    );
  }
}

class _IdentityPage extends StatelessWidget {
  const _IdentityPage({
    required this.controller,
    required this.avatar,
    required this.onAvatar,
  });

  final TextEditingController controller;
  final String avatar;
  final ValueChanged<String> onAvatar;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return _OnboardPage(
      title: 'Almost there',
      subtitle:
          'Pick a name and an avatar. Both are stored only on this device.',
      children: [
        TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          maxLength: 20,
          decoration: const InputDecoration(
            labelText: 'Display name',
            hintText: 'Trader',
            counterText: '',
          ),
        ),
        const VGap(Gap.xl),
        Text('Avatar', style: context.texts.titleSmall),
        const VGap(Gap.md),
        Wrap(
          spacing: Gap.md,
          runSpacing: Gap.md,
          children: [
            for (final entry in Avatars.all)
              Semantics(
                button: true,
                selected: avatar == entry.$1,
                label: 'Avatar ${entry.$1}',
                child: InkWell(
                  onTap: () => onAvatar(entry.$1),
                  borderRadius: BorderRadius.circular(Radii.pill),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: avatar == entry.$1 ? c.accentSoft : c.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: avatar == entry.$1 ? c.accent : c.border,
                        width: avatar == entry.$1 ? 2 : 1,
                      ),
                    ),
                    child: Icon(
                      entry.$2,
                      color: avatar == entry.$1 ? c.accent : c.textSecondary,
                      size: 28,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return TpCard(
      onTap: onTap,
      borderColor: selected ? c.accent : null,
      semanticLabel: title,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.texts.titleMedium),
                const VGap(Gap.xs),
                Text(subtitle, style: context.texts.bodySmall),
              ],
            ),
          ),
          const HGap(Gap.md),
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_unchecked_rounded,
            color: selected ? c.accent : c.textTertiary,
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return Padding(
      padding: const EdgeInsets.only(bottom: Gap.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: c.accentSoft,
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Icon(icon, size: 19, color: c.accent),
          ),
          const HGap(Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.texts.titleSmall),
                const VGap(Gap.xxs),
                Text(body, style: context.texts.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
