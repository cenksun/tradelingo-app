import 'package:meta/meta.dart';

import '../../core/seeded_random.dart';
import '../models/activity.dart';
import '../models/enums.dart';
import '../models/lesson.dart';
import '../models/review_item.dart';
import '../models/skill.dart';
import 'spaced_repetition.dart';

/// One item selected for a practice or review session.
@immutable
class PracticeItem {
  const PracticeItem({
    required this.activity,
    required this.lessonId,
    required this.reason,
  });

  final Activity activity;
  final String lessonId;

  /// Why this item was chosen, shown to the learner so practice never feels
  /// arbitrary.
  final String reason;
}

/// Chooses what to practise next.
///
/// The selection is deterministic given the same inputs and seed, which makes
/// it testable and means two runs of the same session are reproducible. It
/// weighs four things: the spaced-repetition queue, current mastery, recent
/// mistakes, and how long since a concept was last seen.
class RecommendationEngine {
  const RecommendationEngine._();

  /// Builds a practice session.
  ///
  /// [focusSkillId] narrows to one skill; leaving it null draws from the
  /// learner's weakest areas across the whole curriculum.
  static List<PracticeItem> buildSession({
    required Curriculum curriculum,
    required List<ReviewItem> reviewItems,
    required List<SkillMastery> masteries,
    required Set<String> unlockedLessonIds,
    required DateTime now,
    String? focusSkillId,
    List<MistakeTag> recentMistakes = const [],
    int limit = 10,
    int seed = 0,
  }) {
    final rnd = SeededRandom(
      seed == 0 ? now.millisecondsSinceEpoch ~/ 60000 : seed,
    );

    // Only practise from lessons the learner has actually unlocked, so practice
    // never teaches ahead of the curriculum.
    final pool = <PracticeItem>[];
    final available = curriculum.allLessons
        .where((l) => unlockedLessonIds.contains(l.id))
        .toList(growable: false);

    if (available.isEmpty) return const [];

    final masteryById = {for (final m in masteries) m.skillId: m};
    final dueConcepts = <String, ReviewItem>{
      for (final item in SpacedRepetition.selectForSession(
        items: reviewItems,
        now: now,
        limit: 40,
      ))
        item.conceptTag: item,
    };
    final mistakeConcepts = recentMistakes.map((m) => m.name).toSet();

    for (final lesson in available) {
      if (focusSkillId != null && !lesson.skillIds.contains(focusSkillId)) {
        continue;
      }
      for (final activity in lesson.gradedActivities) {
        final score = _score(
          activity: activity,
          lesson: lesson,
          masteryById: masteryById,
          dueConcepts: dueConcepts,
          mistakeConcepts: mistakeConcepts,
          now: now,
        );
        if (score <= 0) continue;
        pool.add(
          PracticeItem(
            activity: activity,
            lessonId: lesson.id,
            reason: _reason(
              activity: activity,
              masteryById: masteryById,
              dueConcepts: dueConcepts,
              mistakeConcepts: mistakeConcepts,
            ),
          ),
        );
      }
    }

    if (pool.isEmpty) return const [];

    // Rank by score, then take a spread so a session is not ten variations of
    // the same concept.
    final scored = <(double, PracticeItem)>[
      for (final item in pool)
        (
          _score(
            activity: item.activity,
            lesson: curriculum.lessonById(item.lessonId)!,
            masteryById: masteryById,
            dueConcepts: dueConcepts,
            mistakeConcepts: mistakeConcepts,
            now: now,
          ),
          item,
        ),
    ];
    scored.sort((a, b) {
      final cmp = b.$1.compareTo(a.$1);
      if (cmp != 0) return cmp;
      return a.$2.activity.id.compareTo(b.$2.activity.id);
    });

    final chosen = <PracticeItem>[];
    final usedConcepts = <String, int>{};
    for (final entry in scored) {
      final concept = entry.$2.activity.concept;
      final used = usedConcepts[concept] ?? 0;
      // At most two questions on the same concept per session.
      if (used >= 2) continue;
      usedConcepts[concept] = used + 1;
      chosen.add(entry.$2);
      if (chosen.length >= limit) break;
    }

    // If filtering left the session short, top it up from the rest of the pool.
    if (chosen.length < limit) {
      for (final entry in scored) {
        if (chosen.length >= limit) break;
        if (chosen.contains(entry.$2)) continue;
        chosen.add(entry.$2);
      }
    }

    return rnd.shuffled(chosen);
  }

  /// Priority for a single candidate activity.
  static double _score({
    required Activity activity,
    required Lesson lesson,
    required Map<String, SkillMastery> masteryById,
    required Map<String, ReviewItem> dueConcepts,
    required Set<String> mistakeConcepts,
    required DateTime now,
  }) {
    var score = 10.0;

    // 1. Due for review — the strongest signal.
    final due = dueConcepts[activity.concept];
    if (due != null) {
      score += 45 + SpacedRepetition.priority(due, now) * 0.35;
    }

    // 2. Weak mastery in the skill this exercise trains.
    for (final skillId in activity.skillIds) {
      final mastery = masteryById[skillId];
      if (mastery == null) {
        score += 6;
        continue;
      }
      score += (100 - mastery.score) * 0.28;
      if (mastery.attempts < 5) score += 5;
    }

    // 3. Concepts tied to recent mistakes.
    if (mistakeConcepts.contains(activity.concept)) score += 22;

    // 4. Prefer exercises at or just above the learner's level: too easy adds
    // nothing, far too hard is discouraging.
    score += switch (activity.difficulty) {
      Difficulty.beginner => 2,
      Difficulty.intermediate => 5,
      Difficulty.advanced => 6,
      Difficulty.expert => 4,
    };

    // Boss activities are reserved for boss runs.
    if (lesson.isBoss) score -= 8;

    return score;
  }

  static String _reason({
    required Activity activity,
    required Map<String, SkillMastery> masteryById,
    required Map<String, ReviewItem> dueConcepts,
    required Set<String> mistakeConcepts,
  }) {
    if (dueConcepts.containsKey(activity.concept)) {
      final item = dueConcepts[activity.concept]!;
      if (item.lapses > 0) {
        return 'You have missed this one before, so it is scheduled again.';
      }
      return 'Due for review.';
    }
    if (mistakeConcepts.contains(activity.concept)) {
      return 'Linked to a mistake from a recent simulation.';
    }
    for (final skillId in activity.skillIds) {
      final mastery = masteryById[skillId];
      if (mastery != null && mastery.attempts >= 3 && mastery.score < 55) {
        return '${Skills.byId(skillId).shortName} is one of your weaker skills.';
      }
    }
    return 'Keeps this concept fresh.';
  }

  /// Skills ordered by how much attention they need.
  static List<SkillMastery> weakestSkills(
    List<SkillMastery> masteries, {
    int limit = 3,
  }) {
    final tested = masteries.where((m) => m.attempts >= 3).toList()
      ..sort((a, b) {
        final cmp = a.score.compareTo(b.score);
        return cmp != 0 ? cmp : a.skillId.compareTo(b.skillId);
      });
    return tested.take(limit).toList(growable: false);
  }
}
