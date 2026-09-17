import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/achievements/achievements_screen.dart';
import '../features/analytics/analytics_screen.dart';
import '../features/challenge/challenge_screen.dart';
import '../features/challenge/daily_challenge_screen.dart';
import '../features/journal/journal_detail_screen.dart';
import '../features/journal/journal_screen.dart';
import '../features/learn/learn_screen.dart';
import '../features/learn/learner_controller.dart';
import '../features/lesson/lesson_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/practice/practice_hub_screen.dart';
import '../features/practice/practice_session_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/simulator/simulation_run_screen.dart';
import '../features/simulator/simulator_hub_screen.dart';
import 'shell.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// The app's routes.
///
/// Built once and refreshed through a listenable, so switching tabs or
/// finishing onboarding never rebuilds the router and loses navigation state.
final routerProvider = Provider<GoRouter>((ref) {
  final onboarded = ValueNotifier<bool?>(null);
  ref.listen(learnerControllerProvider, (_, next) {
    onboarded.value = next.value?.profile.onboardingComplete;
  }, fireImmediately: true);
  ref.onDispose(onboarded.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/learn',
    refreshListenable: onboarded,
    redirect: (context, state) {
      final complete = onboarded.value;
      // Still loading: let the destination render its own loading state.
      if (complete == null) return null;
      final atOnboarding = state.matchedLocation.startsWith('/onboarding');
      if (!complete && !atOnboarding) return '/onboarding';
      if (complete && atOnboarding) return '/learn';
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('No screen matched ${state.uri}'),
        ),
      ),
    ),
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/lesson/:lessonId',
        parentNavigatorKey: _rootKey,
        builder: (context, state) =>
            LessonScreen(lessonId: state.pathParameters['lessonId']!),
      ),
      GoRoute(
        path: '/simulate/run',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => SimulationRunScreen(
          options: SimulatorLaunchOptions.fromQueryParameters(
            state.uri.queryParameters,
          ),
        ),
      ),
      GoRoute(
        path: '/practice',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const PracticeHubScreen(),
        routes: [
          GoRoute(
            path: ':mode',
            parentNavigatorKey: _rootKey,
            builder: (context, state) =>
                PracticeSessionScreen(mode: state.pathParameters['mode']!),
          ),
        ],
      ),
      GoRoute(
        path: '/challenge/daily',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const DailyChallengeScreen(),
      ),
      GoRoute(
        path: '/journal/:entryId',
        parentNavigatorKey: _rootKey,
        builder: (context, state) =>
            JournalDetailScreen(entryId: state.pathParameters['entryId']!),
      ),
      GoRoute(
        path: '/analytics',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: '/achievements',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/learn',
                builder: (context, state) => const LearnScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/simulate',
                builder: (context, state) => const SimulatorHubScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/challenge',
                builder: (context, state) => const ChallengeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/journal',
                builder: (context, state) => const JournalScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
