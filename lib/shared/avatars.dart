import 'package:flutter/material.dart';

/// The local avatar set. Simple geometric icons drawn from the Material set —
/// no third-party logos or likenesses anywhere in the app.
class Avatars {
  const Avatars._();

  static const List<(String, IconData)> all = [
    ('avatar_01', Icons.show_chart_rounded),
    ('avatar_02', Icons.candlestick_chart_rounded),
    ('avatar_03', Icons.terrain_rounded),
    ('avatar_04', Icons.auto_graph_rounded),
    ('avatar_05', Icons.hexagon_outlined),
    ('avatar_06', Icons.bolt_rounded),
  ];

  static IconData iconFor(String id) =>
      all.firstWhere((a) => a.$1 == id, orElse: () => all.first).$2;
}
