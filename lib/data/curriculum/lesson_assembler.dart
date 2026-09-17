import 'dart:math' as math;

import '../../core/seeded_random.dart';
import '../../domain/models/activity.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/lesson.dart';
import 'chart_activity_factory.dart';
import 'lesson_spec.dart';

/// Expands authored [LessonSpec]s into runnable [Lesson]s.
///
/// The expansion rules live here rather than in the content files, so every
/// lesson in the app has the same shape: an opening card, concepts interleaved
/// with practice, chart work, a terminology check and a recap. Lessons are
/// always between [minActivities] and [maxActivities] activities long.
class LessonAssembler {
  const LessonAssembler._();

  static const int minActivities = 8;
  static const int maxActivities = 15;

  static String lessonId(String worldId, int index) =>
      '${worldId}_l${index.toString().padLeft(2, '0')}';

  static String bossId(String worldId) => '${worldId}_boss';

  static Lesson buildLesson({
    required String worldId,
    required int index,
    required LessonSpec spec,
    required List<String> prerequisiteLessonIds,
    required String worldSkillId,
  }) {
    final id = lessonId(worldId, index);
    final skills = spec.skills.isEmpty ? [worldSkillId] : spec.skills;
    final counter = _IdCounter(id);

    final activities = <Activity>[];

    activities.add(
      ExplanationActivity(
        id: counter.next(),
        skillIds: skills,
        title: spec.title,
        body: spec.intro,
        difficulty: spec.difficulty,
        conceptTag: 'intro',
      ),
    );

    // Exercises are consumed one at a time between concept cards, so a learner
    // meets an idea and then immediately uses it.
    final pool = <Activity>[
      for (var i = 0; i < spec.quizzes.length; i++)
        _quiz(counter.next(), spec.quizzes[i], skills, spec.difficulty),
      for (var i = 0; i < spec.facts.length; i++)
        _fact(counter.next(), spec.facts[i], skills, spec.difficulty),
      for (var i = 0; i < spec.charts.length; i++)
        ChartActivityFactory.build(
          id: counter.next(),
          spec: spec.charts[i],
          skillIds: skills,
          lessonDifficulty: spec.difficulty,
        ),
      for (var i = 0; i < spec.extras.length; i++)
        _extra(counter.next(), spec.extras[i], skills, spec.difficulty),
    ];

    var poolCursor = 0;
    for (final concept in spec.concepts) {
      activities.add(
        ExplanationActivity(
          id: counter.next(),
          skillIds: skills,
          title: concept.term,
          body: concept.detail,
          bullets: concept.bullets,
          difficulty: spec.difficulty,
          conceptTag: _slug(concept.term),
        ),
      );
      if (poolCursor < pool.length) {
        activities.add(pool[poolCursor++]);
      }
    }
    while (poolCursor < pool.length) {
      activities.add(pool[poolCursor++]);
    }

    if (spec.includeMatching && spec.concepts.length >= 3) {
      activities.add(
        MatchingActivity(
          id: counter.next(),
          skillIds: skills,
          difficulty: spec.difficulty,
          terms: [for (final c in spec.concepts) c.term],
          definitions: [for (final c in spec.concepts) c.oneLiner],
          conceptTag: 'terminology',
          explanation:
              'Getting the vocabulary exact matters: most confusion later on comes from two '
              'terms that sound similar being used interchangeably.',
        ),
      );
    }

    // Top up short lessons with recall questions generated from the concepts.
    var fill = 0;
    while (activities.length < minActivities - 1 && spec.concepts.length >= 2) {
      activities.add(
        _conceptRecall(
          counter.next(),
          spec.concepts,
          fill,
          skills,
          spec.difficulty,
        ),
      );
      fill++;
      if (fill > spec.concepts.length * 2) break;
    }

    activities.add(
      ExplanationActivity(
        id: counter.next(),
        skillIds: skills,
        title: 'Recap',
        body: spec.recap ?? _autoRecap(spec),
        bullets: [for (final c in spec.concepts) '${c.term}: ${c.oneLiner}'],
        difficulty: spec.difficulty,
        conceptTag: 'recap',
      ),
    );

    return Lesson(
      id: id,
      worldId: worldId,
      index: index,
      title: spec.title,
      subtitle: spec.subtitle,
      skillIds: skills,
      activities: _trim(activities),
      difficulty: spec.difficulty,
      prerequisiteLessonIds: prerequisiteLessonIds,
      estimatedMinutes: spec.minutes,
    );
  }

  static Lesson buildBoss({
    required String worldId,
    required int index,
    required BossSpec spec,
    required List<String> prerequisiteLessonIds,
    required String worldSkillId,
  }) {
    final id = bossId(worldId);
    final skills = spec.skills.isEmpty ? [worldSkillId] : spec.skills;
    final counter = _IdCounter(id);

    final activities = <Activity>[
      ExplanationActivity(
        id: counter.next(),
        skillIds: skills,
        title: spec.title,
        body: spec.intro,
        bullets: [
          'You need ${(spec.passThreshold * 100).round()}% to pass.',
          'Hearts still apply, and you can retry as many times as you like.',
          'Anything you miss is added to your review queue automatically.',
        ],
        difficulty: spec.difficulty,
        conceptTag: 'boss_intro',
      ),
      for (var i = 0; i < spec.charts.length; i++)
        ChartActivityFactory.build(
          id: counter.next(),
          spec: spec.charts[i],
          skillIds: skills,
          lessonDifficulty: spec.difficulty,
        ),
      for (var i = 0; i < spec.quizzes.length; i++)
        _quiz(counter.next(), spec.quizzes[i], skills, spec.difficulty),
      for (var i = 0; i < spec.extras.length; i++)
        _extra(counter.next(), spec.extras[i], skills, spec.difficulty),
      for (var i = 0; i < spec.facts.length; i++)
        _fact(counter.next(), spec.facts[i], skills, spec.difficulty),
    ];

    return Lesson(
      id: id,
      worldId: worldId,
      index: index,
      title: spec.title,
      subtitle: spec.subtitle,
      skillIds: skills,
      activities: _trim(activities),
      difficulty: spec.difficulty,
      kind: LessonKind.boss,
      prerequisiteLessonIds: prerequisiteLessonIds,
      estimatedMinutes: spec.minutes,
      passThreshold: spec.passThreshold,
    );
  }

  static List<Activity> _trim(List<Activity> activities) {
    if (activities.length <= maxActivities) {
      return List.unmodifiable(activities);
    }
    // Keep the opening card, the recap and as much graded work as fits.
    final first = activities.first;
    final last = activities.last;
    final middle = activities.sublist(1, activities.length - 1);
    final keep = middle.take(maxActivities - 2).toList();
    return List.unmodifiable([first, ...keep, last]);
  }

  static Activity _quiz(
    String id,
    QuizSpec spec,
    List<String> skills,
    Difficulty difficulty,
  ) => MultipleChoiceActivity(
    id: id,
    prompt: spec.prompt,
    skillIds: skills,
    difficulty: difficulty,
    options: spec.options,
    correctIndex: spec.correctIndex,
    optionFeedback: spec.optionFeedback,
    explanation: spec.why,
    conceptTag: spec.concept,
    mistakeOnWrong: spec.mistake,
  );

  static Activity _fact(
    String id,
    FactSpec spec,
    List<String> skills,
    Difficulty difficulty,
  ) => TrueFalseActivity(
    id: id,
    statement: spec.statement,
    answer: spec.isTrue,
    skillIds: skills,
    difficulty: difficulty,
    explanation: spec.why,
    conceptTag: spec.concept,
  );

  static Activity _extra(
    String id,
    ExtraSpec spec,
    List<String> skills,
    Difficulty difficulty,
  ) {
    switch (spec) {
      case RiskCalcSpec():
        return RiskCalculationActivity(
          id: id,
          prompt: spec.prompt,
          skillIds: skills,
          difficulty: difficulty,
          expected: spec.expected,
          explanation: spec.why,
          conceptTag: spec.concept ?? 'risk_amount',
        );
      case RiskRewardSpec():
        return RiskRewardActivity(
          id: id,
          prompt: spec.prompt,
          skillIds: skills,
          difficulty: difficulty,
          entry: spec.entry,
          stopLoss: spec.stopLoss,
          takeProfit: spec.takeProfit,
          direction: spec.direction,
          explanation: spec.why,
          conceptTag: spec.concept ?? 'risk_reward',
        );
      case OrderTypeSpec():
        return OrderTypeActivity(
          id: id,
          prompt: 'Which order type fits this situation?',
          scenario: spec.scenario,
          skillIds: skills,
          difficulty: difficulty,
          correct: spec.correct,
          explanation: spec.why,
        );
      case SequenceSpec():
        return SequenceOrderingActivity(
          id: id,
          prompt: spec.prompt,
          skillIds: skills,
          difficulty: difficulty,
          stepsInOrder: spec.stepsInOrder,
          explanation: spec.why,
          conceptTag: spec.concept ?? 'process_sequence',
        );
      case SpotMistakeSpec():
        return SpotMistakeActivity(
          id: id,
          scenario: spec.scenario,
          skillIds: skills,
          difficulty: difficulty,
          options: spec.options,
          correctIndex: spec.correctIndex,
          tag: spec.tag,
          explanation: spec.why,
        );
    }
  }

  /// Builds a definition-recall question using the other concepts in the same
  /// lesson as distractors, which keeps the wrong answers plausible.
  static Activity _conceptRecall(
    String id,
    List<ConceptSpec> concepts,
    int offset,
    List<String> skills,
    Difficulty difficulty,
  ) {
    final rnd = SeededRandom.fromString(id, offset);
    final targetIndex = offset % concepts.length;
    final target = concepts[targetIndex];
    final others = [
      for (var i = 0; i < concepts.length; i++)
        if (i != targetIndex) concepts[i],
    ];
    final distractors = rnd
        .shuffled(others)
        .take(math.min(3, others.length))
        .map((c) => c.oneLiner)
        .toList();
    final options = rnd.shuffled([target.oneLiner, ...distractors]);
    final correctIndex = options.indexOf(target.oneLiner);
    return MultipleChoiceActivity(
      id: id,
      prompt: 'Which of these describes "${target.term}"?',
      skillIds: skills,
      difficulty: difficulty,
      options: options,
      correctIndex: correctIndex,
      explanation: '${target.term}: ${target.detail}',
      conceptTag: _slug(target.term),
    );
  }

  static String _autoRecap(LessonSpec spec) {
    final terms = spec.concepts.map((c) => c.term).toList();
    final list = terms.length <= 1
        ? (terms.isEmpty ? 'the ideas above' : terms.first)
        : '${terms.sublist(0, terms.length - 1).join(', ')} and ${terms.last}';
    return 'That covers $list. These come back in later lessons and in your review queue, so '
        'anything that felt shaky here will get another pass.';
  }

  static String _slug(String value) {
    final buffer = StringBuffer();
    for (final rune in value.toLowerCase().runes) {
      final ch = String.fromCharCode(rune);
      if (RegExp(r'[a-z0-9]').hasMatch(ch)) {
        buffer.write(ch);
      } else if (buffer.isNotEmpty && !buffer.toString().endsWith('_')) {
        buffer.write('_');
      }
    }
    final out = buffer.toString();
    return out.endsWith('_') ? out.substring(0, out.length - 1) : out;
  }
}

class _IdCounter {
  _IdCounter(this.prefix);
  final String prefix;
  int _n = 0;
  String next() => '${prefix}_a${(_n++).toString().padLeft(2, '0')}';
}
