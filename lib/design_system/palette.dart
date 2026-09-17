import 'package:flutter/material.dart';

/// TradePath's own colour identity: a deep "terminal navy" base with a mint
/// signal accent and a violet progression accent.
///
/// Bullish / bearish colours are always paired with a shape or a text label in
/// the UI, so meaning never depends on colour alone.
@immutable
class TpColors extends ThemeExtension<TpColors> {
  const TpColors({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceSunken,
    required this.border,
    required this.borderStrong,
    required this.accent,
    required this.accentSoft,
    required this.onAccent,
    required this.progress,
    required this.progressSoft,
    required this.bullish,
    required this.bearish,
    required this.neutralTrend,
    required this.warning,
    required this.info,
    required this.danger,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.chartGrid,
    required this.chartAxis,
    required this.chartCrosshair,
    required this.entryLine,
    required this.stopLine,
    required this.targetLine,
    required this.zoneFill,
    required this.locked,
    required this.heart,
    required this.streak,
    required this.xp,
  });

  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color surfaceSunken;
  final Color border;
  final Color borderStrong;
  final Color accent;
  final Color accentSoft;
  final Color onAccent;
  final Color progress;
  final Color progressSoft;
  final Color bullish;
  final Color bearish;
  final Color neutralTrend;
  final Color warning;
  final Color info;
  final Color danger;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color chartGrid;
  final Color chartAxis;
  final Color chartCrosshair;
  final Color entryLine;
  final Color stopLine;
  final Color targetLine;
  final Color zoneFill;
  final Color locked;
  final Color heart;
  final Color streak;
  final Color xp;

  static const TpColors dark = TpColors(
    background: Color(0xFF080B12),
    surface: Color(0xFF111725),
    surfaceRaised: Color(0xFF18202F),
    surfaceSunken: Color(0xFF0C111B),
    border: Color(0xFF212B3D),
    borderStrong: Color(0xFF32405A),
    accent: Color(0xFF2BE5A8),
    accentSoft: Color(0xFF123B33),
    onAccent: Color(0xFF04120D),
    progress: Color(0xFF7C5CFF),
    progressSoft: Color(0xFF241E47),
    bullish: Color(0xFF2FD383),
    bearish: Color(0xFFFF5F7E),
    neutralTrend: Color(0xFF8B9AB8),
    warning: Color(0xFFFFB648),
    info: Color(0xFF52A8FF),
    danger: Color(0xFFFF6B5E),
    textPrimary: Color(0xFFEDF2FF),
    textSecondary: Color(0xFF9FADC9),
    textTertiary: Color(0xFF6B7A96),
    chartGrid: Color(0xFF1A2232),
    chartAxis: Color(0xFF6B7A96),
    chartCrosshair: Color(0xFF8FA3C4),
    entryLine: Color(0xFF52A8FF),
    stopLine: Color(0xFFFF5F7E),
    targetLine: Color(0xFF2FD383),
    zoneFill: Color(0x332BE5A8),
    locked: Color(0xFF3A4459),
    heart: Color(0xFFFF5F7E),
    streak: Color(0xFFFF9F43),
    xp: Color(0xFF7C5CFF),
  );

  static const TpColors light = TpColors(
    background: Color(0xFFF4F7FC),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFFFFFFF),
    surfaceSunken: Color(0xFFEDF1F8),
    border: Color(0xFFDCE3EF),
    borderStrong: Color(0xFFB8C4D8),
    accent: Color(0xFF00A578),
    accentSoft: Color(0xFFD7F5EB),
    onAccent: Color(0xFFFFFFFF),
    progress: Color(0xFF5B3FE0),
    progressSoft: Color(0xFFE7E1FF),
    bullish: Color(0xFF12915A),
    bearish: Color(0xFFD62A4E),
    neutralTrend: Color(0xFF5B6A85),
    warning: Color(0xFFB77400),
    info: Color(0xFF1667C7),
    danger: Color(0xFFC53A2E),
    textPrimary: Color(0xFF0E1526),
    textSecondary: Color(0xFF4A5871),
    textTertiary: Color(0xFF75839C),
    chartGrid: Color(0xFFE3E9F3),
    chartAxis: Color(0xFF5B6A85),
    chartCrosshair: Color(0xFF3C4A63),
    entryLine: Color(0xFF1667C7),
    stopLine: Color(0xFFD62A4E),
    targetLine: Color(0xFF12915A),
    zoneFill: Color(0x3300A578),
    locked: Color(0xFFB8C4D8),
    heart: Color(0xFFD62A4E),
    streak: Color(0xFFE07B00),
    xp: Color(0xFF5B3FE0),
  );

  @override
  TpColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceRaised,
    Color? surfaceSunken,
    Color? border,
    Color? borderStrong,
    Color? accent,
    Color? accentSoft,
    Color? onAccent,
    Color? progress,
    Color? progressSoft,
    Color? bullish,
    Color? bearish,
    Color? neutralTrend,
    Color? warning,
    Color? info,
    Color? danger,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? chartGrid,
    Color? chartAxis,
    Color? chartCrosshair,
    Color? entryLine,
    Color? stopLine,
    Color? targetLine,
    Color? zoneFill,
    Color? locked,
    Color? heart,
    Color? streak,
    Color? xp,
  }) {
    return TpColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      onAccent: onAccent ?? this.onAccent,
      progress: progress ?? this.progress,
      progressSoft: progressSoft ?? this.progressSoft,
      bullish: bullish ?? this.bullish,
      bearish: bearish ?? this.bearish,
      neutralTrend: neutralTrend ?? this.neutralTrend,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      danger: danger ?? this.danger,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      chartGrid: chartGrid ?? this.chartGrid,
      chartAxis: chartAxis ?? this.chartAxis,
      chartCrosshair: chartCrosshair ?? this.chartCrosshair,
      entryLine: entryLine ?? this.entryLine,
      stopLine: stopLine ?? this.stopLine,
      targetLine: targetLine ?? this.targetLine,
      zoneFill: zoneFill ?? this.zoneFill,
      locked: locked ?? this.locked,
      heart: heart ?? this.heart,
      streak: streak ?? this.streak,
      xp: xp ?? this.xp,
    );
  }

  @override
  TpColors lerp(covariant TpColors? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return TpColors(
      background: c(background, other.background),
      surface: c(surface, other.surface),
      surfaceRaised: c(surfaceRaised, other.surfaceRaised),
      surfaceSunken: c(surfaceSunken, other.surfaceSunken),
      border: c(border, other.border),
      borderStrong: c(borderStrong, other.borderStrong),
      accent: c(accent, other.accent),
      accentSoft: c(accentSoft, other.accentSoft),
      onAccent: c(onAccent, other.onAccent),
      progress: c(progress, other.progress),
      progressSoft: c(progressSoft, other.progressSoft),
      bullish: c(bullish, other.bullish),
      bearish: c(bearish, other.bearish),
      neutralTrend: c(neutralTrend, other.neutralTrend),
      warning: c(warning, other.warning),
      info: c(info, other.info),
      danger: c(danger, other.danger),
      textPrimary: c(textPrimary, other.textPrimary),
      textSecondary: c(textSecondary, other.textSecondary),
      textTertiary: c(textTertiary, other.textTertiary),
      chartGrid: c(chartGrid, other.chartGrid),
      chartAxis: c(chartAxis, other.chartAxis),
      chartCrosshair: c(chartCrosshair, other.chartCrosshair),
      entryLine: c(entryLine, other.entryLine),
      stopLine: c(stopLine, other.stopLine),
      targetLine: c(targetLine, other.targetLine),
      zoneFill: c(zoneFill, other.zoneFill),
      locked: c(locked, other.locked),
      heart: c(heart, other.heart),
      streak: c(streak, other.streak),
      xp: c(xp, other.xp),
    );
  }
}

/// Convenience accessor: `context.tp.accent`.
extension TpColorsContext on BuildContext {
  TpColors get tp => Theme.of(this).extension<TpColors>() ?? TpColors.dark;
  TextTheme get texts => Theme.of(this).textTheme;
}
