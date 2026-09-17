import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/curriculum/curriculum_source.dart';
import '../data/db/app_database.dart';
import '../data/repositories/local_repositories.dart';
import '../domain/models/lesson.dart';
import '../domain/repositories/repositories.dart';
import '../domain/services/coach_service.dart';

/// The database instance. Overridden in `main` with the opened database, and in
/// tests with an in-memory one.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw StateError('appDatabaseProvider must be overridden before use');
});

/// Supplies "now". Overridden in tests so time-dependent behaviour — streaks,
/// the daily challenge, spaced repetition — can be driven deterministically.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => LocalProfileRepository(ref.watch(appDatabaseProvider)),
);

final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => LocalProgressRepository(ref.watch(appDatabaseProvider)),
);

final journalRepositoryProvider = Provider<JournalRepository>(
  (ref) => LocalJournalRepository(ref.watch(appDatabaseProvider)),
);

final challengeRepositoryProvider = Provider<ChallengeRepository>(
  (ref) => LocalChallengeRepository(ref.watch(appDatabaseProvider)),
);

/// The curriculum is assembled once and cached for the process lifetime.
final curriculumProvider = Provider<Curriculum>(
  (ref) => CurriculumSource.build(),
);

/// The coach. Swapping in a remote implementation later is a one-line change
/// here; no screen depends on which one is in use.
final coachServiceProvider = Provider<CoachService>(
  (ref) => const LocalCoachService(),
);
