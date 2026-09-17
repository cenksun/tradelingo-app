# Curriculum assets

The curriculum is **Dart, not JSON**, and lives in `lib/data/curriculum/`.

Lessons are authored as compact specs (`LessonSpec`) — concepts, questions,
facts and chart tasks — which `LessonAssembler` expands into the 8–15 activities
each lesson runs. Chart exercises store a `ChartRecipe` (a seed plus a shape)
rather than candle arrays, so a single template produces a different chart every
time it appears.

Keeping it in Dart buys three things a JSON asset would not: the analyzer checks
every reference at compile time, the integrity tests in `test/curriculum_test.dart`
run against the real objects, and there is no asset parsing or error handling on
the startup path.

This directory exists for curriculum assets added later — illustrations, audio,
or externally-authored lesson packs.
