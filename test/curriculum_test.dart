import 'package:flutter_test/flutter_test.dart';
import 'package:tradepath/data/curriculum/curriculum_source.dart';
import 'package:tradepath/data/market/synthetic_series_generator.dart';
import 'package:tradepath/domain/models/activity.dart';
import 'package:tradepath/domain/models/skill.dart';

void main() {
  final curriculum = CurriculumSource.build();

  group('curriculum structure', () {
    test('contains exactly 12 worlds', () {
      expect(curriculum.worlds.length, 12);
    });

    test('every world has at least 10 lessons', () {
      for (final w in curriculum.worlds) {
        expect(
          w.lessonCount,
          greaterThanOrEqualTo(10),
          reason: '${w.id} has ${w.lessonCount}',
        );
      }
    });

    test('there are at least 120 lessons in total', () {
      expect(curriculum.lessonCount, greaterThanOrEqualTo(120));
    });

    test('world indexes are 1..12 and in order', () {
      for (var i = 0; i < curriculum.worlds.length; i++) {
        expect(curriculum.worlds[i].index, i + 1);
      }
    });

    test('every world ends with exactly one boss challenge', () {
      for (final w in curriculum.worlds) {
        final bosses = w.lessons.where((l) => l.isBoss).toList();
        expect(bosses.length, 1, reason: w.id);
        expect(w.lessons.last.isBoss, isTrue, reason: w.id);
        expect(bosses.first.passThreshold, closeTo(0.8, 0.001), reason: w.id);
      }
    });
  });

  group('identifiers', () {
    test('lesson ids are unique', () {
      final ids = curriculum.allLessons.map((l) => l.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('activity ids are unique across the whole curriculum', () {
      final ids = <String>[];
      for (final l in curriculum.allLessons) {
        ids.addAll(l.activities.map((a) => a.id));
      }
      final dupes = <String>{};
      final seen = <String>{};
      for (final id in ids) {
        if (!seen.add(id)) dupes.add(id);
      }
      expect(dupes, isEmpty, reason: 'duplicate activity ids: $dupes');
    });

    test('world ids are unique', () {
      final ids = curriculum.worlds.map((w) => w.id).toList();
      expect(ids.toSet().length, ids.length);
    });
  });

  group('metadata', () {
    test('every lesson has required metadata', () {
      for (final l in curriculum.allLessons) {
        expect(l.title.trim(), isNotEmpty, reason: l.id);
        expect(l.subtitle.trim(), isNotEmpty, reason: l.id);
        expect(l.skillIds, isNotEmpty, reason: l.id);
        expect(l.estimatedMinutes, greaterThan(0), reason: l.id);
        expect(l.worldId.trim(), isNotEmpty, reason: l.id);
      }
    });

    test('every lesson skill id exists in the skill catalogue', () {
      for (final l in curriculum.allLessons) {
        for (final s in l.skillIds) {
          expect(Skills.tryById(s), isNotNull, reason: '${l.id} -> $s');
        }
      }
    });

    test('every world primary skill exists', () {
      for (final w in curriculum.worlds) {
        expect(Skills.tryById(w.primarySkillId), isNotNull, reason: w.id);
      }
    });
  });

  group('prerequisites', () {
    test('every prerequisite refers to a real lesson', () {
      for (final l in curriculum.allLessons) {
        for (final p in l.prerequisiteLessonIds) {
          expect(curriculum.lessonById(p), isNotNull, reason: '${l.id} -> $p');
        }
      }
    });

    test('prerequisites always point backwards in curriculum order', () {
      final order = <String, int>{};
      final all = curriculum.allLessons;
      for (var i = 0; i < all.length; i++) {
        order[all[i].id] = i;
      }
      for (final l in all) {
        for (final p in l.prerequisiteLessonIds) {
          expect(
            order[p]!,
            lessThan(order[l.id]!),
            reason: '${l.id} depends on later lesson $p',
          );
        }
      }
    });

    test('the very first lesson has no prerequisites', () {
      expect(curriculum.allLessons.first.prerequisiteLessonIds, isEmpty);
    });

    test('each world after the first starts from the previous boss', () {
      for (var i = 1; i < curriculum.worlds.length; i++) {
        final first = curriculum.worlds[i].lessons.first;
        final previousBoss = curriculum.worlds[i - 1].boss!;
        expect(first.prerequisiteLessonIds, contains(previousBoss.id));
      }
    });
  });

  group('activities', () {
    test('every lesson has between 8 and 15 activities', () {
      for (final l in curriculum.allLessons) {
        expect(l.activities.length, greaterThanOrEqualTo(8), reason: l.id);
        expect(l.activities.length, lessThanOrEqualTo(15), reason: l.id);
      }
    });

    test('every lesson has at least four graded activities', () {
      for (final l in curriculum.allLessons) {
        expect(l.gradedCount, greaterThanOrEqualTo(4), reason: l.id);
      }
    });

    test('every activity has a prompt and an explanation where graded', () {
      for (final l in curriculum.allLessons) {
        for (final a in l.activities) {
          expect(a.displayPrompt.trim(), isNotEmpty, reason: '${l.id}/${a.id}');
          if (a.isGraded) {
            expect(a.explanation.trim(), isNotEmpty, reason: '${l.id}/${a.id}');
            expect(
              a.explanation.trim().length,
              greaterThan(27),
              reason:
                  '${l.id}/${a.id} explanation is too short to teach anything',
            );
          }
          expect(a.skillIds, isNotEmpty, reason: '${l.id}/${a.id}');
        }
      }
    });

    test('multiple choice options are distinct and the answer is in range', () {
      for (final l in curriculum.allLessons) {
        for (final a in l.activities) {
          if (a is MultipleChoiceActivity) {
            expect(a.options.length, greaterThanOrEqualTo(2), reason: a.id);
            expect(
              a.correctIndex,
              inInclusiveRange(0, a.options.length - 1),
              reason: a.id,
            );
            expect(
              a.options.toSet().length,
              a.options.length,
              reason: '${a.id} has duplicate options',
            );
          }
          if (a is SpotMistakeActivity) {
            expect(
              a.correctIndex,
              inInclusiveRange(0, a.options.length - 1),
              reason: a.id,
            );
          }
          if (a is MatchingActivity) {
            expect(a.terms.length, a.definitions.length, reason: a.id);
            expect(a.terms.length, greaterThanOrEqualTo(2), reason: a.id);
          }
          if (a is SequenceOrderingActivity) {
            expect(
              a.stepsInOrder.length,
              greaterThanOrEqualTo(3),
              reason: a.id,
            );
          }
        }
      }
    });

    test(
      'at least 15 of the 20 activity kinds are used across the curriculum',
      () {
        final kinds = <ActivityKind>{};
        for (final l in curriculum.allLessons) {
          for (final a in l.activities) {
            kinds.add(a.kind);
          }
        }
        expect(
          kinds.length,
          greaterThanOrEqualTo(15),
          reason: 'only used: ${kinds.map((k) => k.name).toList()..sort()}',
        );
      },
    );
  });

  group('chart exercises resolve to real answers', () {
    test('every chart activity has a solvable target on its generated chart', () {
      var checked = 0;
      for (final l in curriculum.allLessons) {
        for (final a in l.activities) {
          final recipe = a.recipe;
          if (recipe == null) continue;
          final series = SyntheticSeriesGenerator.build(recipe);
          expect(series.candles, isNotEmpty, reason: '${l.id}/${a.id}');
          checked++;

          switch (a) {
            case TapCandleActivity():
              expect(
                a.target.resolve(series),
                isNotNull,
                reason: '${l.id}/${a.id}',
              );
            case TapPricePointActivity():
              expect(
                a.candleTarget.resolve(series),
                isNotNull,
                reason: '${l.id}/${a.id}',
              );
            case IdentifyStructureActivity():
              expect(
                series.swingsWithLabel(a.targetLabel),
                isNotEmpty,
                reason:
                    '${l.id}/${a.id} wants ${a.targetLabel} on ${recipe.pattern}',
              );
            case LabelStructureActivity():
              expect(a.swingOrders, isNotEmpty, reason: '${l.id}/${a.id}');
              for (final o in a.swingOrders) {
                expect(
                  series.swings.any((s) => s.order == o),
                  isTrue,
                  reason: '${l.id}/${a.id} order $o',
                );
              }
            case ZoneSelectionActivity():
              expect(
                series.zonesOfKind(a.zoneKind),
                isNotEmpty,
                reason:
                    '${l.id}/${a.id} wants ${a.zoneKind} on ${recipe.pattern}',
              );
            case DragStopLossActivity():
              expect(
                LevelExerciseGeometry.forStop(series, a.direction),
                isNotNull,
                reason: '${l.id}/${a.id}',
              );
            case DragTakeProfitActivity():
              expect(
                LevelExerciseGeometry.forTarget(series, a.direction),
                isNotNull,
                reason: '${l.id}/${a.id}',
              );
              expect(
                LevelExerciseGeometry.forStop(series, a.direction),
                isNotNull,
                reason: '${l.id}/${a.id}',
              );
            case BuildTradeActivity():
              expect(
                LevelExerciseGeometry.forStop(series, a.direction),
                isNotNull,
                reason: '${l.id}/${a.id}',
              );
            case MiniSimulationActivity():
              expect(
                a.visibleCandles,
                greaterThan(4),
                reason: '${l.id}/${a.id}',
              );
              expect(
                a.visibleCandles,
                lessThan(series.candles.length),
                reason: '${l.id}/${a.id} would reveal the whole chart',
              );
            default:
              break;
          }
        }
      }
      expect(
        checked,
        greaterThan(80),
        reason:
            'expected a substantial number of chart exercises, found $checked',
      );
    });
  });

  test('curriculum reports a healthy activity total', () {
    expect(curriculum.activityCount, greaterThanOrEqualTo(1200));
  });
}
