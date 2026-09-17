import 'package:meta/meta.dart';

import '../models/achievement.dart';

/// An achievement plus where the learner currently stands on it.
@immutable
class AchievementProgress {
  const AchievementProgress({
    required this.achievement,
    required this.unlocked,
    required this.value,
  });

  final Achievement achievement;
  final bool unlocked;
  final int value;

  double get fraction => unlocked ? 1 : achievement.progressFraction(value);

  String get progressLabel =>
      '${value.clamp(0, achievement.target)} / ${achievement.target}';
}
