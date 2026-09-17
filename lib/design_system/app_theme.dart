import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'palette.dart';
import 'tokens.dart';

/// Builds the two TradePath themes from a single definition so that dark and
/// light stay structurally identical and only colours differ.
class AppTheme {
  const AppTheme._();

  static ThemeData dark() => _build(TpColors.dark, Brightness.dark);
  static ThemeData light() => _build(TpColors.light, Brightness.light);

  static ThemeData _build(TpColors c, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.accent,
      onPrimary: c.onAccent,
      primaryContainer: c.accentSoft,
      onPrimaryContainer: c.textPrimary,
      secondary: c.progress,
      onSecondary: Colors.white,
      secondaryContainer: c.progressSoft,
      onSecondaryContainer: c.textPrimary,
      error: c.danger,
      onError: Colors.white,
      errorContainer: c.danger.withValues(alpha: 0.16),
      onErrorContainer: c.textPrimary,
      surface: c.surface,
      onSurface: c.textPrimary,
      surfaceContainerHighest: c.surfaceRaised,
      onSurfaceVariant: c.textSecondary,
      outline: c.border,
      outlineVariant: c.borderStrong,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: c.textPrimary,
      onInverseSurface: c.background,
      inversePrimary: c.accent,
    );

    final base = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    final text = _textTheme(base.textTheme, c);

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      textTheme: text,
      primaryTextTheme: text,
      extensions: <ThemeExtension<dynamic>>[c],
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
        systemOverlayStyle: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      dividerTheme: DividerThemeData(color: c.border, space: 1, thickness: 1),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.cardRadius,
          side: BorderSide(color: c.border),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: Radii.sheetRadius),
        showDragHandle: true,
        dragHandleColor: c.borderStrong,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.cardRadius,
          side: BorderSide(color: c.border),
        ),
        titleTextStyle: text.titleMedium,
        contentTextStyle: text.bodyMedium,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.surfaceRaised,
        contentTextStyle: text.bodyMedium,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          side: BorderSide(color: c.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surfaceSunken,
        hintStyle: text.bodyMedium?.copyWith(color: c.textTertiary),
        labelStyle: text.labelLarge?.copyWith(color: c.textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Gap.lg,
          vertical: Gap.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: BorderSide(color: c.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: BorderSide(color: c.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          borderSide: BorderSide(color: c.danger, width: 2),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: c.accent,
        inactiveTrackColor: c.surfaceSunken,
        thumbColor: c.accent,
        overlayColor: c.accent.withValues(alpha: 0.14),
        trackHeight: 6,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.onAccent : c.textTertiary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.accent : c.surfaceSunken,
        ),
        trackOutlineColor: WidgetStateProperty.all(c.border),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.accent,
        linearTrackColor: c.surfaceSunken,
        circularTrackColor: c.surfaceSunken,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: c.surfaceRaised,
          borderRadius: BorderRadius.circular(Radii.sm),
          border: Border.all(color: c.border),
        ),
        textStyle: text.bodySmall,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.surface,
        indicatorColor: c.accentSoft,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => text.labelSmall?.copyWith(
            color: s.contains(WidgetState.selected) ? c.accent : c.textTertiary,
            fontWeight: s.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w600,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(
            size: Sizes.iconLg,
            color: s.contains(WidgetState.selected) ? c.accent : c.textTertiary,
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: c.textSecondary,
        textColor: c.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
        ),
      ),
      iconTheme: IconThemeData(color: c.textSecondary, size: Sizes.iconMd),
    );
  }

  static TextTheme _textTheme(TextTheme base, TpColors c) {
    TextStyle s(
      double size,
      FontWeight weight, {
      double? height,
      double? spacing,
      Color? color,
    }) => TextStyle(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: spacing,
      color: color ?? c.textPrimary,
    );

    return base.copyWith(
      displaySmall: s(34, FontWeight.w800, height: 1.15, spacing: -0.6),
      headlineLarge: s(28, FontWeight.w800, height: 1.2, spacing: -0.4),
      headlineMedium: s(24, FontWeight.w700, height: 1.22, spacing: -0.3),
      headlineSmall: s(20, FontWeight.w700, height: 1.25, spacing: -0.2),
      titleLarge: s(18, FontWeight.w700, height: 1.3),
      titleMedium: s(16, FontWeight.w700, height: 1.35),
      titleSmall: s(14, FontWeight.w700, height: 1.35),
      bodyLarge: s(16, FontWeight.w500, height: 1.5, color: c.textSecondary),
      bodyMedium: s(14, FontWeight.w500, height: 1.5, color: c.textSecondary),
      bodySmall: s(12.5, FontWeight.w500, height: 1.45, color: c.textTertiary),
      labelLarge: s(14, FontWeight.w700, spacing: 0.1),
      labelMedium: s(12.5, FontWeight.w700, spacing: 0.2),
      labelSmall: s(11, FontWeight.w700, spacing: 0.4, color: c.textTertiary),
    );
  }
}
