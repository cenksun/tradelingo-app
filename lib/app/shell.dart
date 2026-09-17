import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../design_system/components.dart';

/// The five-destination bottom navigation shell.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const List<({IconData icon, IconData active, String label})>
  _destinations = [
    (icon: Icons.school_outlined, active: Icons.school_rounded, label: 'Learn'),
    (
      icon: Icons.candlestick_chart_outlined,
      active: Icons.candlestick_chart_rounded,
      label: 'Simulate',
    ),
    (
      icon: Icons.emoji_events_outlined,
      active: Icons.emoji_events_rounded,
      label: 'Challenge',
    ),
    (
      icon: Icons.menu_book_outlined,
      active: Icons.menu_book_rounded,
      label: 'Journal',
    ),
    (
      icon: Icons.person_outline_rounded,
      active: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.tp;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: c.border)),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) => navigationShell.goBranch(
            index,
            // Tapping the current tab pops it back to its root.
            initialLocation: index == navigationShell.currentIndex,
          ),
          destinations: [
            for (final d in _destinations)
              NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.active),
                label: d.label,
                tooltip: d.label,
              ),
          ],
        ),
      ),
    );
  }
}
