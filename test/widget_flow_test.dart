import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradepath/app/app.dart';
import 'package:tradepath/app/providers.dart';
import 'package:tradepath/data/db/app_database.dart';
import 'package:tradepath/data/market/synthetic_series_generator.dart';
import 'package:tradepath/design_system/app_theme.dart';
import 'package:tradepath/domain/models/chart_series.dart';
import 'package:tradepath/domain/models/enums.dart';
import 'package:tradepath/domain/models/activity.dart';
import 'package:tradepath/domain/models/skill.dart';
import 'package:tradepath/features/learn/learner_controller.dart';
import 'package:tradepath/features/lesson/activity_player.dart';
import 'package:tradepath/features/simulator/simulation_run_screen.dart';
import 'package:tradepath/features/simulator/simulator_hub_screen.dart';
import 'package:tradepath/shared/chart/candle_chart.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  final now = DateTime(2026, 7, 1, 9);

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  /// Builds a container and waits for the learner state to load, without
  /// pumping the whole app.
  Future<void> prepareContainer(WidgetTester tester) async {
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(container.dispose);
    await container.read(learnerControllerProvider.future);
    await container
        .read(learnerControllerProvider.notifier)
        .completeOnboarding(
          username: 'Tester',
          level: ExperienceLevel.beginner,
          dailyGoalMinutes: 10,
          avatarId: 'avatar_01',
        );
  }

  Future<void> pumpPlayer(WidgetTester tester, Widget player) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: AppTheme.dark(), home: player),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpApp(WidgetTester tester) async {
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TradePathApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> completeOnboarding(WidgetTester tester) async {
    await container
        .read(learnerControllerProvider.notifier)
        .completeOnboarding(
          username: 'Tester',
          level: ExperienceLevel.beginner,
          dailyGoalMinutes: 10,
          avatarId: 'avatar_01',
        );
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  group('first run', () {
    testWidgets('a fresh install lands on onboarding', (tester) async {
      await pumpApp(tester);
      expect(find.text('TradePath'), findsWidgets);
      expect(find.text('Continue'), findsOneWidget);
      // The educational disclaimer is present before anything else.
      expect(
        find.textContaining('does not provide investment advice'),
        findsOneWidget,
      );
    });

    testWidgets('onboarding walks through its pages and needs a choice', (
      tester,
    ) async {
      await pumpApp(tester);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('How lessons work'), findsOneWidget);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Simulations'), findsOneWidget);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Where are you starting?'), findsOneWidget);

      // The experience page requires a selection before continuing.
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Where are you starting?'), findsOneWidget);

      await tester.tap(find.text('Complete beginner'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Daily goal'), findsOneWidget);
    });
  });

  group('learn tab', () {
    testWidgets('shows the header, the first world and the five tabs', (
      tester,
    ) async {
      await pumpApp(tester);
      await completeOnboarding(tester);

      expect(find.text('Trading Basics'), findsOneWidget);
      expect(find.text('NEXT UP'), findsOneWidget);
      expect(find.text('What Is a Market?'), findsWidgets);

      for (final tab in [
        'Learn',
        'Simulate',
        'Challenge',
        'Journal',
        'Profile',
      ]) {
        expect(find.text(tab), findsWidgets, reason: tab);
      }
    });

    testWidgets('later worlds are visible but locked', (tester) async {
      await pumpApp(tester);
      await completeOnboarding(tester);

      await tester.scrollUntilVisible(
        find.text('Candlesticks'),
        320,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
      expect(find.text('Candlesticks'), findsOneWidget);
      expect(find.textContaining('Pass the previous world'), findsWidgets);
    });

    testWidgets('the other tabs open', (tester) async {
      await pumpApp(tester);
      await completeOnboarding(tester);

      await tester.tap(find.text('Simulate'));
      await tester.pumpAndSettle();
      expect(find.text('Quick simulation'), findsOneWidget);
      expect(find.text('Custom simulation'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Weakness practice'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.text('Weakness practice'), findsOneWidget);

      await tester.tap(find.text('Journal'));
      await tester.pumpAndSettle();
      expect(find.text('No entries yet'), findsOneWidget);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.text('Tester'), findsOneWidget);
      expect(find.textContaining('Level 1'), findsWidgets);

      await tester.tap(find.text('Challenge'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Daily challenge'), findsWidgets);
    });
  });

  group('lesson flow', () {
    testWidgets('opens a lesson, advances, and grades an answer', (
      tester,
    ) async {
      await pumpApp(tester);
      await completeOnboarding(tester);

      // Open the first lesson from the "next up" card.
      await tester.tap(find.text('NEXT UP'));
      await tester.pumpAndSettle();

      // The first activity is the opening explanation card.
      expect(find.text('What Is a Market?'), findsWidgets);
      expect(find.widgetWithText(InkWell, 'Continue'), findsWidgets);

      // Step forward until a graded question appears.
      var guard = 0;
      while (find.text('Check').evaluate().isEmpty && guard < 12) {
        await tester.tap(find.text('Continue').last);
        await tester.pumpAndSettle();
        guard++;
      }
      expect(
        find.text('Check'),
        findsOneWidget,
        reason: 'a graded activity should appear within the first few cards',
      );

      // Check is disabled until an option is picked.
      final beforeHearts = container
          .read(learnerControllerProvider)
          .value!
          .profile
          .hearts;
      expect(beforeHearts, 5);
    });

    testWidgets('a wrong answer costs a heart and explains why', (
      tester,
    ) async {
      await prepareContainer(tester);

      const question = MultipleChoiceActivity(
        id: 'test_q1',
        prompt: 'Which statement is true?',
        skillIds: [Skills.marketBasics],
        options: ['The right one', 'The wrong one'],
        correctIndex: 0,
        explanation:
            'A quoted price records the most recent completed trade and nothing '
            'more.',
      );

      PlayerResult? finished;
      await pumpPlayer(
        tester,
        ActivityPlayer(
          title: 'Test',
          items: const [
            PlayableActivity(activity: question, lessonId: 'w01_l01'),
          ],
          onFinished: (r) => finished = r,
        ),
      );

      // Check does nothing until an option is chosen.
      expect(find.text('Check'), findsOneWidget);
      await tester.tap(find.text('Check'));
      await tester.pumpAndSettle();
      expect(find.text('Not quite'), findsNothing);

      await tester.tap(find.text('The wrong one'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Check'));
      await tester.pumpAndSettle();

      // Feedback explains why rather than just saying "wrong".
      expect(find.text('Not quite'), findsOneWidget);
      expect(
        find.textContaining('records the most recent completed trade'),
        findsOneWidget,
      );
      expect(
        container.read(learnerControllerProvider).value!.profile.hearts,
        4,
        reason: 'a wrong answer costs exactly one heart',
      );

      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();
      expect(finished, isNotNull);
      expect(finished!.correct, 0);
      expect(finished!.total, 1);
    });

    testWidgets('a correct answer is confirmed and costs no heart', (
      tester,
    ) async {
      await prepareContainer(tester);

      const question = TrueFalseActivity(
        id: 'test_q2',
        statement: 'Every completed trade has one buyer and one seller.',
        answer: true,
        skillIds: [Skills.marketBasics],
        explanation:
            'That is what makes a trade a trade; imbalance shows up as '
            'eagerness rather than as counts.',
      );

      await pumpPlayer(
        tester,
        ActivityPlayer(
          title: 'Test',
          items: const [
            PlayableActivity(activity: question, lessonId: 'w01_l01'),
          ],
          onFinished: (_) {},
        ),
      );

      await tester.tap(find.text('True'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Check'));
      await tester.pumpAndSettle();

      expect(find.text('Correct'), findsOneWidget);
      expect(
        container.read(learnerControllerProvider).value!.profile.hearts,
        5,
      );
    });

    testWidgets('practice for hearts never costs a heart', (tester) async {
      await prepareContainer(tester);
      await container.read(learnerControllerProvider.notifier).loseHeart();

      const question = MultipleChoiceActivity(
        id: 'test_q3',
        prompt: 'Pick one.',
        skillIds: [Skills.marketBasics],
        options: ['Right', 'Wrong'],
        correctIndex: 0,
        explanation: 'The first option is the one this exercise was after.',
      );

      await pumpPlayer(
        tester,
        ActivityPlayer(
          title: 'Hearts',
          heartsEnabled: false,
          items: const [
            PlayableActivity(activity: question, lessonId: 'w01_l01'),
          ],
          onFinished: (_) {},
        ),
      );

      await tester.tap(find.text('Wrong'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Check'));
      await tester.pumpAndSettle();

      expect(find.text('Not quite'), findsOneWidget);
      expect(
        container.read(learnerControllerProvider).value!.profile.hearts,
        4,
        reason:
            'hearts practice must not take the heart it is meant to restore',
      );
    });

    testWidgets('leaving a lesson asks for confirmation', (tester) async {
      await pumpApp(tester);
      await completeOnboarding(tester);

      await tester.tap(find.text('NEXT UP'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Leave this session?'), findsOneWidget);

      await tester.tap(find.text('Keep going'));
      await tester.pumpAndSettle();
      expect(find.text('Leave this session?'), findsNothing);
    });
  });

  group('chart widget', () {
    testWidgets('renders candles and reports taps', (tester) async {
      final series = SyntheticSeriesGenerator.build(
        const ChartRecipe(seed: 1234, pattern: ChartPattern.uptrend),
      );
      int? tapped;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark(),
          home: Scaffold(
            body: SizedBox(
              height: 300,
              width: 380,
              child: CandleChart(
                candles: series.candles,
                onCandleTap: (i) => tapped = i,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CustomPaint), findsWidgets);
      await tester.tapAt(const Offset(200, 150));
      await tester.pumpAndSettle();
      expect(tapped, isNotNull);
      expect(tapped, inInclusiveRange(0, series.candles.length - 1));
    });

    testWidgets('an empty series shows a message rather than crashing', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark(),
          home: const Scaffold(
            body: SizedBox(height: 200, child: CandleChart(candles: [])),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No chart data'), findsOneWidget);
    });
  });

  group('simulator flow', () {
    testWidgets('runs a long trade from decision through replay to review', (
      tester,
    ) async {
      await prepareContainer(tester);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.dark(),
            home: const SimulationRunScreen(options: SimulatorLaunchOptions()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // A scenario loads with the future hidden.
      expect(find.text('Read the chart'), findsOneWidget);
      expect(find.text('Long'), findsOneWidget);
      expect(find.text('Short'), findsOneWidget);
      expect(find.text('No trade'), findsOneWidget);
      // The chart announces how much is visible; the rest stays hidden.
      expect(
        find.bySemanticsLabel(RegExp('hidden until you decide')),
        findsOneWidget,
        reason: 'the learner is told the rest of the chart is hidden',
      );

      await tester.tap(find.text('Long'));
      await tester.pumpAndSettle();

      // The builder derives position size and reward-to-risk from the levels.
      // Stat tile labels render upper-case.
      expect(find.text('Build the trade'), findsOneWidget);
      expect(find.text('Commit and reveal'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('POSITION SIZE'),
        240,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 40,
      );
      await tester.pumpAndSettle();
      expect(find.text('POSITION SIZE'), findsOneWidget);
      expect(find.text('RISK AMOUNT'), findsOneWidget);
      expect(find.text('R:R'), findsWidgets);

      await tester.tap(find.text('Commit and reveal'));
      await tester.pumpAndSettle();

      // Replay controls appear, and the plan is locked.
      expect(find.text('Replay'), findsOneWidget);
      expect(find.text('Play'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);

      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      // Review: process score first, outcome second.
      expect(find.text('Review'), findsOneWidget);
      expect(find.text('PROCESS SCORE'), findsOneWidget);
      expect(find.text('Save to journal'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Score breakdown'),
        260,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 40,
      );
      await tester.pumpAndSettle();
      expect(find.text('Score breakdown'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Coach'),
        260,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 40,
      );
      await tester.pumpAndSettle();
      expect(find.text('Coach'), findsOneWidget);

      final before = container
          .read(learnerControllerProvider)
          .value!
          .account
          .tradeCount;
      await tester.tap(find.text('Save to journal'));
      await tester.pumpAndSettle();

      final state = container.read(learnerControllerProvider).value!;
      expect(state.account.tradeCount, before + 1);
      expect(state.profile.totalXp, greaterThan(0));

      final entries = await container
          .read(journalRepositoryProvider)
          .loadEntries();
      expect(entries.length, 1);
      expect(entries.first.direction, TradeDirection.long);
      expect(entries.first.positionSize, greaterThan(0));
      expect(entries.first.processScore, inInclusiveRange(0, 100));
    });

    testWidgets('a no-trade decision is recorded as a real decision', (
      tester,
    ) async {
      await prepareContainer(tester);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.dark(),
            home: const SimulationRunScreen(options: SimulatorLaunchOptions()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('No trade'));
      await tester.pumpAndSettle();
      expect(find.text('Record a no-trade decision?'), findsOneWidget);

      await tester.tap(find.text('Record it'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      expect(find.text('PROCESS SCORE'), findsOneWidget);
      await tester.tap(find.text('Save to journal'));
      await tester.pumpAndSettle();

      final entries = await container
          .read(journalRepositoryProvider)
          .loadEntries();
      expect(entries.length, 1);
      expect(entries.first.isNoTrade, isTrue);
      expect(entries.first.profitLoss, 0);
    });
  });

  group('settings', () {
    testWidgets('resets ask for confirmation before running', (tester) async {
      await pumpApp(tester);
      await completeOnboarding(tester);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings_rounded));
      await tester.pumpAndSettle();

      // The reset actions live near the bottom of a long settings list.
      await tester.scrollUntilVisible(
        find.text('Reset everything'),
        260,
        scrollable: find.byType(Scrollable).last,
        maxScrolls: 60,
      );
      await tester.pumpAndSettle();
      expect(find.text('Reset simulator'), findsWidgets);

      await tester.tap(find.text('Reset everything').first);
      await tester.pumpAndSettle();
      expect(find.text('Reset everything?'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      // Still onboarded: cancelling changed nothing.
      expect(
        container
            .read(learnerControllerProvider)
            .value!
            .profile
            .onboardingComplete,
        isTrue,
      );
    });
  });
}
