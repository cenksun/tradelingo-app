import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../design_system/app_theme.dart';
import '../domain/models/enums.dart';
import '../features/learn/learner_controller.dart';
import 'router.dart';

class TradePathApp extends ConsumerWidget {
  const TradePathApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(learnerControllerProvider).value?.settings;
    final choice = settings?.theme ?? ThemeChoice.dark;

    return MaterialApp.router(
      title: 'TradePath',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: switch (choice) {
        ThemeChoice.system => ThemeMode.system,
        ThemeChoice.dark => ThemeMode.dark,
        ThemeChoice.light => ThemeMode.light,
      },
      builder: (context, child) {
        // Respect the platform text scale but keep layouts usable at extremes.
        final scale = MediaQuery.textScalerOf(context).scale(1);
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale.clamp(0.85, 1.45))),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
