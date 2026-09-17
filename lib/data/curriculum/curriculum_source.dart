import '../../domain/models/lesson.dart';
import 'lesson_assembler.dart';
import 'lesson_spec.dart';
import 'worlds/world_01_basics.dart';
import 'worlds/world_02_candlesticks.dart';
import 'worlds/world_03_structure.dart';
import 'worlds/world_04_trends.dart';
import 'worlds/world_05_long_short.dart';
import 'worlds/world_06_orders.dart';
import 'worlds/world_07_stops.dart';
import 'worlds/world_08_risk.dart';
import 'worlds/world_09_levels.dart';
import 'worlds/world_10_liquidity.dart';
import 'worlds/world_11_price_action.dart';
import 'worlds/world_12_process.dart';

/// The authored curriculum, and the code that turns it into a [Curriculum].
class CurriculumSource {
  const CurriculumSource._();

  /// The twelve world specifications, in teaching order.
  static const List<WorldSpec> worldSpecs = [
    world01Basics,
    world02Candlesticks,
    world03Structure,
    world04Trends,
    world05LongShort,
    world06Orders,
    world07Stops,
    world08Risk,
    world09Levels,
    world10Liquidity,
    world11PriceAction,
    world12Process,
  ];

  /// Builds the full curriculum graph.
  ///
  /// Prerequisites are wired here so the rule lives in one place: each lesson
  /// requires the previous lesson in its world, and the first lesson of a world
  /// requires the previous world's boss.
  static Curriculum build() {
    final worlds = <World>[];
    String? previousBossId;

    for (final spec in worldSpecs) {
      final lessons = <Lesson>[];
      String? previousLessonId = previousBossId;

      for (var i = 0; i < spec.lessons.length; i++) {
        final lesson = LessonAssembler.buildLesson(
          worldId: spec.id,
          index: i + 1,
          spec: spec.lessons[i],
          prerequisiteLessonIds: previousLessonId == null
              ? const []
              : [previousLessonId],
          worldSkillId: spec.primarySkillId,
        );
        lessons.add(lesson);
        previousLessonId = lesson.id;
      }

      final boss = LessonAssembler.buildBoss(
        worldId: spec.id,
        index: spec.lessons.length + 1,
        spec: spec.boss,
        prerequisiteLessonIds: previousLessonId == null
            ? const []
            : [previousLessonId],
        worldSkillId: spec.primarySkillId,
      );
      lessons.add(boss);
      previousBossId = boss.id;

      worlds.add(
        World(
          id: spec.id,
          index: spec.index,
          title: spec.title,
          subtitle: spec.subtitle,
          description: spec.description,
          primarySkillId: spec.primarySkillId,
          accentColor: spec.accentColor,
          lessons: List.unmodifiable(lessons),
        ),
      );
    }

    return Curriculum(List.unmodifiable(worlds));
  }
}
