import 'package:meta/meta.dart';

import '../../core/formatters.dart';
import '../models/enums.dart';
import '../models/journal_entry.dart';
import '../models/scenario.dart';
import '../models/skill.dart';
import '../models/trade.dart';
import 'process_score.dart';
import 'risk_calculator.dart';

/// A short piece of coaching shown after a simulation or a practice session.
@immutable
class CoachMessage {
  const CoachMessage({
    required this.headline,
    required this.body,
    this.suggestions = const [],
    this.recommendedSkillId,
    this.recommendedLessonId,
  });

  final String headline;
  final String body;
  final List<String> suggestions;
  final String? recommendedSkillId;
  final String? recommendedLessonId;
}

/// Everything the coach needs to say something useful.
@immutable
class CoachContext {
  const CoachContext({
    required this.plan,
    required this.score,
    this.result,
    this.bundle,
    this.weakSkills = const [],
    this.recentMistakes = const [],
    this.recentEntries = const [],
  });

  final TradePlan plan;
  final ProcessScore score;
  final TradeResult? result;
  final ScenarioBundle? bundle;
  final List<SkillMastery> weakSkills;
  final List<MistakeTag> recentMistakes;
  final List<JournalEntry> recentEntries;
}

/// The coaching interface.
///
/// V1 ships [LocalCoachService], which is entirely deterministic and needs no
/// network. A future `RemoteAiCoachService` can implement the same interface
/// without any screen changing, because screens only ever see [CoachMessage].
abstract class CoachService {
  const CoachService();

  /// Feedback on one completed simulation.
  CoachMessage reviewTrade(CoachContext context);

  /// A short prompt for the practice hub, based on current weaknesses.
  CoachMessage practiceSuggestion({
    required List<SkillMastery> masteries,
    required List<MistakeTag> recentMistakes,
  });
}

/// The offline coach.
///
/// It reads the trade metrics, the process components and the learner's weak
/// skills, then assembles feedback from rule checks. There are no network
/// calls, real or simulated — every sentence is derived from data already in
/// the app.
class LocalCoachService extends CoachService {
  const LocalCoachService();

  @override
  CoachMessage reviewTrade(CoachContext context) {
    final plan = context.plan;
    final score = context.score;
    final result = context.result;

    final headline = _headline(score, result, plan);
    final body = StringBuffer();

    if (plan.isNoTrade) {
      body.write(
        'You recorded a no-trade decision. That is a real decision, and it is graded here like '
        'any other.',
      );
    } else {
      body.write(
        'You planned a ${plan.direction.label.toLowerCase()} risking '
        '${Fmt.percent(plan.riskPercent, decimals: 2)} of the virtual account, with a stop '
        '${Fmt.price(plan.stopDistance)} away and a planned reward-to-risk of '
        '${Fmt.ratio(plan.rewardToRisk)}.',
      );
      if (result != null && !result.isNoTrade) {
        body.write(
          ' The replay finished at ${Fmt.rMultiple(result.rMultiple)} '
          '(${result.outcome.label.toLowerCase()}).',
        );
      }
    }

    // Name the weakest graded dimension, since that is the most useful thing
    // to say next.
    final graded = score.components.where((c) => !c.subjective).toList()
      ..sort((a, b) => a.score.compareTo(b.score));
    if (graded.isNotEmpty && graded.first.score < 70) {
      body.write(
        ' The weakest part of this plan was ${graded.first.label.toLowerCase()}: ',
      );
      body.write(graded.first.comment);
    } else if (score.total >= 80) {
      body.write(
        ' Nothing in this plan stands out as a problem — risk, invalidation and reward all held '
        'together.',
      );
    }

    final suggestions = <String>[
      ...score.improvements.take(2),
      if (context.recentMistakes.isNotEmpty)
        _recurringMistakeLine(context.recentMistakes),
    ]..removeWhere((s) => s.trim().isEmpty);

    return CoachMessage(
      headline: headline,
      body: body.toString(),
      suggestions: suggestions,
      recommendedSkillId: _skillForMistakes(score.mistakes),
    );
  }

  @override
  CoachMessage practiceSuggestion({
    required List<SkillMastery> masteries,
    required List<MistakeTag> recentMistakes,
  }) {
    final tested = masteries.where((m) => m.attempts >= 3).toList()
      ..sort((a, b) => a.score.compareTo(b.score));

    if (tested.isEmpty) {
      return const CoachMessage(
        headline: 'Start anywhere',
        body:
            'There is not enough answer history yet to find a weak spot. Work through a few '
            'lessons and this will start pointing at something specific.',
        suggestions: ['Complete a lesson in World 1 or 2 to build a baseline.'],
      );
    }

    final weakest = tested.first;
    final skill = Skills.byId(weakest.skillId);
    final body = StringBuffer(
      '${skill.name} is currently your lowest-rated skill at ${weakest.score.round()} out of 100, '
      'across ${weakest.attempts} answers.',
    );
    if (weakest.accuracy > 0) {
      body.write(
        ' You have been right ${Fmt.percentOfRatio(weakest.accuracy)} of the time on it.',
      );
    }

    final suggestions = <String>[
      'Run a targeted ${skill.shortName} practice session — it draws from your weakest concepts '
          'first.',
      if (recentMistakes.isNotEmpty) _recurringMistakeLine(recentMistakes),
      if (tested.length > 1)
        '${Skills.byId(tested[1].skillId).name} is the next one worth attention.',
    ];

    return CoachMessage(
      headline: 'Work on ${skill.shortName}',
      body: body.toString(),
      suggestions: suggestions,
      recommendedSkillId: skill.id,
    );
  }

  String _headline(ProcessScore score, TradeResult? result, TradePlan plan) {
    if (plan.isNoTrade) {
      return score.total >= 85
          ? 'Good call to stand aside'
          : 'A defensible pass';
    }
    if (result != null && result.isWin && score.total < 50) {
      return 'Profitable, but the process needs work';
    }
    if (result != null && result.isLoss && score.total >= 75) {
      return 'A loss on a sound plan';
    }
    return score.band;
  }

  String _recurringMistakeLine(List<MistakeTag> mistakes) {
    final counts = <MistakeTag, int>{};
    for (final m in mistakes) {
      counts[m] = (counts[m] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) {
        final cmp = b.value.compareTo(a.value);
        return cmp != 0 ? cmp : a.key.name.compareTo(b.key.name);
      });
    final top = sorted.first;
    if (top.value < 2) {
      return '${top.key.label} showed up recently: ${top.key.description}';
    }
    return '"${top.key.label}" has come up ${top.value} times recently. '
        '${top.key.description}';
  }

  String? _skillForMistakes(List<MistakeTag> mistakes) {
    if (mistakes.isEmpty) return null;
    return switch (mistakes.first) {
      MistakeTag.overRisk || MistakeTag.sizingError => Skills.riskManagement,
      MistakeTag.stopTooTight ||
      MistakeTag.stopTooWide ||
      MistakeTag.ignoredInvalidation ||
      MistakeTag.noStop => Skills.stopLoss,
      MistakeTag.poorRr => Skills.stopLoss,
      MistakeTag.structureMisread => Skills.marketStructure,
      MistakeTag.trendMisread => Skills.trendReading,
      MistakeTag.wrongOrderType => Skills.orders,
      MistakeTag.lateEntry ||
      MistakeTag.impulsiveTrade ||
      MistakeTag.missedNoTrade ||
      MistakeTag.hesitation => Skills.tradePlanning,
    };
  }
}

/// Risk guardrail messaging shared by the trade builder.
class RiskGuardrails {
  const RiskGuardrails._();

  static String? messageFor(double riskPercent) {
    if (riskPercent > RiskCalculator.extremeRiskThreshold) {
      return 'Risking ${Fmt.percent(riskPercent, decimals: 1)} of an account on one position can '
          'produce very large drawdowns. This simulator will allow the experiment, but it will '
          'reduce your Risk Discipline score.';
    }
    if (riskPercent > RiskCalculator.highRiskThreshold) {
      return 'This is above the conservative training band used for scoring. The trade is '
          'allowed; your Risk Discipline score will reflect it.';
    }
    return null;
  }
}
