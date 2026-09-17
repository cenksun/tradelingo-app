import 'package:meta/meta.dart';

import '../../core/app_date.dart';
import '../../core/seeded_random.dart';
import '../models/enums.dart';

/// One row in the offline demo league table.
@immutable
class LeagueEntry {
  const LeagueEntry({
    required this.name,
    required this.xp,
    required this.isPlayer,
    required this.isSample,
  });

  final String name;
  final int xp;
  final bool isPlayer;

  /// True for the generated sample profiles. The UI labels these clearly so
  /// they are never mistaken for other people.
  final bool isSample;
}

@immutable
class LeagueStanding {
  const LeagueStanding({
    required this.tier,
    required this.weekKey,
    required this.entries,
    required this.playerRank,
    required this.promotionRank,
    required this.relegationRank,
  });

  final LeagueTier tier;
  final String weekKey;
  final List<LeagueEntry> entries;
  final int playerRank;

  /// Finishing at or above this rank promotes.
  final int promotionRank;

  /// Finishing at or below this rank relegates.
  final int relegationRank;

  bool get inPromotionZone => playerRank <= promotionRank;
  bool get inRelegationZone => playerRank >= relegationRank;
}

/// A local, clearly-fictional league.
///
/// V1 is offline, so there are no other players. Rather than pretend otherwise,
/// this generates a table of obviously-labelled **sample profiles** with
/// deterministic weekly XP. The interface is the piece that matters: swapping
/// in a real leaderboard later means replacing this one method.
///
/// Ranking uses learning XP — consistency of study — rather than simulated
/// profit, so the table never rewards reckless trading.
class LeagueService {
  const LeagueService._();

  static const int groupSize = 15;
  static const int promotionRank = 4;
  static const int relegationRank = 12;

  static const List<String> _sampleNames = [
    'Sample: Quiet Candle',
    'Sample: Range Rider',
    'Sample: Patient Pine',
    'Sample: Structure Owl',
    'Sample: Slow Ticker',
    'Sample: Wick Watcher',
    'Sample: Risk Robin',
    'Sample: Level Lark',
    'Sample: Steady Stag',
    'Sample: Chart Crow',
    'Sample: Journal Jay',
    'Sample: Session Swift',
    'Sample: Gap Gull',
    'Sample: Trend Tern',
    'Sample: Delta Dove',
    'Sample: Basis Bee',
    'Sample: Ledger Lynx',
    'Sample: Spread Swan',
  ];

  /// Builds this week's table.
  ///
  /// [weeklyXp] is the player's XP earned since the start of the week.
  static LeagueStanding standing({
    required LeagueTier tier,
    required DateTime now,
    required int weeklyXp,
    required String playerName,
  }) {
    final weekKey = AppDate.weekKey(now);
    final rnd = SeededRandom.fromString('$weekKey|${tier.name}', 4231);

    // Sample profiles score in a band that widens with the tier, so higher
    // tiers require more consistent study to stay in.
    final base = 220 + tier.rank * 260;
    final spread = 180 + tier.rank * 160;

    final names = rnd.shuffled(_sampleNames).take(groupSize - 1).toList();
    final entries = <LeagueEntry>[
      for (final name in names)
        LeagueEntry(
          name: name,
          xp: base + rnd.nextInt(spread),
          isPlayer: false,
          isSample: true,
        ),
      LeagueEntry(
        name: playerName,
        xp: weeklyXp < 0 ? 0 : weeklyXp,
        isPlayer: true,
        isSample: false,
      ),
    ];

    entries.sort((a, b) {
      final cmp = b.xp.compareTo(a.xp);
      if (cmp != 0) return cmp;
      // Ties break in the player's favour, then alphabetically, so the order is
      // stable across rebuilds.
      if (a.isPlayer != b.isPlayer) return a.isPlayer ? -1 : 1;
      return a.name.compareTo(b.name);
    });

    final rank = entries.indexWhere((e) => e.isPlayer) + 1;

    return LeagueStanding(
      tier: tier,
      weekKey: weekKey,
      entries: List.unmodifiable(entries),
      playerRank: rank,
      promotionRank: promotionRank,
      relegationRank: relegationRank,
    );
  }

  /// Applies end-of-week movement between tiers.
  static LeagueTier settle(LeagueStanding standing) {
    if (standing.inPromotionZone) return standing.tier.next;
    if (standing.inRelegationZone) return standing.tier.previous;
    return standing.tier;
  }

  static const String disclaimer =
      'These competitors are sample profiles generated on this device. TradePath V1 works '
      'entirely offline, so there are no other players here. Ranking uses learning XP rather '
      'than simulated profit.';
}
