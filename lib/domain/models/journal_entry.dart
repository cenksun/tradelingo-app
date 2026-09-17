import 'package:meta/meta.dart';

import 'enums.dart';

/// One completed simulation, recorded automatically.
///
/// Journalling simulated trades by hand would be busywork, so the simulator
/// writes the entry itself and leaves the learner to add the part a machine
/// cannot: what they were thinking.
@immutable
class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.scenarioId,
    required this.completedAt,
    required this.assetSymbol,
    required this.timeframeName,
    required this.direction,
    required this.entry,
    required this.stopLoss,
    required this.takeProfit,
    required this.riskPercent,
    required this.positionSize,
    required this.rewardToRisk,
    required this.outcome,
    required this.rMultiple,
    required this.profitLoss,
    required this.processScore,
    required this.difficulty,
    this.mistakeTags = const [],
    this.features = const [],
    this.note = '',
    this.favourite = false,
    this.ambiguousClose = false,
  });

  final String id;
  final String scenarioId;
  final DateTime completedAt;
  final String assetSymbol;
  final String timeframeName;
  final TradeDirection direction;
  final double entry;
  final double stopLoss;
  final double takeProfit;
  final double riskPercent;
  final double positionSize;
  final double rewardToRisk;
  final TradeOutcome outcome;
  final double rMultiple;
  final double profitLoss;
  final double processScore;
  final Difficulty difficulty;
  final List<MistakeTag> mistakeTags;
  final List<String> features;
  final String note;
  final bool favourite;
  final bool ambiguousClose;

  bool get isNoTrade => direction == TradeDirection.noTrade;
  bool get isWin => !isNoTrade && profitLoss > 0;
  bool get isLoss => !isNoTrade && profitLoss < 0;

  JournalEntry copyWith({String? note, bool? favourite}) => JournalEntry(
    id: id,
    scenarioId: scenarioId,
    completedAt: completedAt,
    assetSymbol: assetSymbol,
    timeframeName: timeframeName,
    direction: direction,
    entry: entry,
    stopLoss: stopLoss,
    takeProfit: takeProfit,
    riskPercent: riskPercent,
    positionSize: positionSize,
    rewardToRisk: rewardToRisk,
    outcome: outcome,
    rMultiple: rMultiple,
    profitLoss: profitLoss,
    processScore: processScore,
    difficulty: difficulty,
    mistakeTags: mistakeTags,
    features: features,
    note: note ?? this.note,
    favourite: favourite ?? this.favourite,
    ambiguousClose: ambiguousClose,
  );
}

/// Filters for the journal list.
@immutable
class JournalFilter {
  const JournalFilter({
    this.direction,
    this.result,
    this.difficulty,
    this.skillId,
    this.mistakeTag,
    this.favouritesOnly = false,
    this.search = '',
  });

  final TradeDirection? direction;
  final JournalResultFilter? result;
  final Difficulty? difficulty;
  final String? skillId;
  final MistakeTag? mistakeTag;
  final bool favouritesOnly;
  final String search;

  bool get isEmpty =>
      direction == null &&
      result == null &&
      difficulty == null &&
      skillId == null &&
      mistakeTag == null &&
      !favouritesOnly &&
      search.trim().isEmpty;

  JournalFilter copyWith({
    TradeDirection? direction,
    JournalResultFilter? result,
    Difficulty? difficulty,
    String? skillId,
    MistakeTag? mistakeTag,
    bool? favouritesOnly,
    String? search,
    bool clearDirection = false,
    bool clearResult = false,
    bool clearDifficulty = false,
    bool clearMistake = false,
  }) => JournalFilter(
    direction: clearDirection ? null : (direction ?? this.direction),
    result: clearResult ? null : (result ?? this.result),
    difficulty: clearDifficulty ? null : (difficulty ?? this.difficulty),
    skillId: skillId ?? this.skillId,
    mistakeTag: clearMistake ? null : (mistakeTag ?? this.mistakeTag),
    favouritesOnly: favouritesOnly ?? this.favouritesOnly,
    search: search ?? this.search,
  );

  bool matches(JournalEntry e) {
    if (direction != null && e.direction != direction) return false;
    if (difficulty != null && e.difficulty != difficulty) return false;
    if (mistakeTag != null && !e.mistakeTags.contains(mistakeTag)) return false;
    if (favouritesOnly && !e.favourite) return false;
    switch (result) {
      case JournalResultFilter.win:
        if (!e.isWin) return false;
      case JournalResultFilter.loss:
        if (!e.isLoss) return false;
      case JournalResultFilter.noTrade:
        if (!e.isNoTrade) return false;
      case null:
        break;
    }
    final q = search.trim().toLowerCase();
    if (q.isNotEmpty) {
      final haystack = [
        e.assetSymbol,
        e.timeframeName,
        e.note,
        e.scenarioId,
        ...e.features,
        ...e.mistakeTags.map((t) => t.label),
      ].join(' ').toLowerCase();
      if (!haystack.contains(q)) return false;
    }
    return true;
  }
}

enum JournalResultFilter {
  win('Win'),
  loss('Loss'),
  noTrade('No trade');

  const JournalResultFilter(this.label);
  final String label;
}
