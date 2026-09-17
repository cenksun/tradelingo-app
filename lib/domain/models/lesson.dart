import 'package:meta/meta.dart';

import 'activity.dart';
import 'enums.dart';

enum LessonKind {
  standard('Lesson'),
  boss('Boss Challenge');

  const LessonKind(this.label);
  final String label;

  static LessonKind fromName(String? name) => LessonKind.values.firstWhere(
    (k) => k.name == name,
    orElse: () => LessonKind.standard,
  );
}

/// One unit of learning: a title plus an ordered list of activities.
@immutable
class Lesson {
  const Lesson({
    required this.id,
    required this.worldId,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.skillIds,
    required this.activities,
    required this.difficulty,
    this.kind = LessonKind.standard,
    this.prerequisiteLessonIds = const [],
    this.estimatedMinutes = 4,
    this.passThreshold = 0.0,
  });

  final String id;
  final String worldId;
  final int index;
  final String title;
  final String subtitle;
  final List<String> skillIds;
  final List<Activity> activities;
  final Difficulty difficulty;
  final LessonKind kind;
  final List<String> prerequisiteLessonIds;
  final int estimatedMinutes;

  /// Accuracy required to pass. Boss challenges use 0.8; ordinary lessons are
  /// completed by finishing them.
  final double passThreshold;

  bool get isBoss => kind == LessonKind.boss;

  /// Activities that count towards accuracy (explanation cards do not).
  List<Activity> get gradedActivities =>
      activities.where((a) => a.isGraded).toList(growable: false);

  int get gradedCount => gradedActivities.length;

  String get primarySkillId => skillIds.isEmpty ? 'general' : skillIds.first;
}

/// A themed group of lessons, ending in a boss challenge.
@immutable
class World {
  const World({
    required this.id,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.primarySkillId,
    required this.accentColor,
    required this.lessons,
  });

  final String id;
  final int index;
  final String title;
  final String subtitle;
  final String description;
  final String primarySkillId;

  /// ARGB value; the learn path uses it to colour the world's nodes.
  final int accentColor;
  final List<Lesson> lessons;

  Lesson? get boss {
    for (final l in lessons) {
      if (l.isBoss) return l;
    }
    return null;
  }

  List<Lesson> get standardLessons =>
      lessons.where((l) => !l.isBoss).toList(growable: false);

  int get lessonCount => lessons.length;

  Lesson? lessonById(String id) {
    for (final l in lessons) {
      if (l.id == id) return l;
    }
    return null;
  }
}

/// The full curriculum graph.
@immutable
class Curriculum {
  const Curriculum(this.worlds);

  final List<World> worlds;

  List<Lesson> get allLessons => [for (final w in worlds) ...w.lessons];

  int get lessonCount => allLessons.length;

  int get activityCount =>
      allLessons.fold(0, (sum, l) => sum + l.activities.length);

  World? worldById(String id) {
    for (final w in worlds) {
      if (w.id == id) return w;
    }
    return null;
  }

  Lesson? lessonById(String id) {
    for (final w in worlds) {
      final l = w.lessonById(id);
      if (l != null) return l;
    }
    return null;
  }

  World? worldOfLesson(String lessonId) {
    for (final w in worlds) {
      if (w.lessonById(lessonId) != null) return w;
    }
    return null;
  }

  /// Lessons that train a given skill, ordered by difficulty then position.
  List<Lesson> lessonsForSkill(String skillId) => allLessons
      .where((l) => l.skillIds.contains(skillId))
      .toList(growable: false);

  /// The lesson that follows [lessonId] in curriculum order, if any.
  Lesson? nextLesson(String lessonId) {
    final all = allLessons;
    for (var i = 0; i < all.length; i++) {
      if (all[i].id == lessonId) {
        return i + 1 < all.length ? all[i + 1] : null;
      }
    }
    return null;
  }
}
