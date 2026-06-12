/// Semantic colour tokens for the ReefLife design system.
library;

import 'package:flutter/material.dart';

/// A [ThemeExtension] that centralises the app's semantic colours.
///
/// Two families live here:
/// - **Status palette** — conveys parameter health: [statusOptimal] (in range),
///   [statusWarning] (drifting), [statusError] (out of range / high), and
///   [statusLow] (below range, shown as informational rather than alarming).
/// - **Parameter accents** — the per-parameter brand colours used on gauges,
///   cards, and dialogs ([temperatureAccent], [phAccent], [salinityAccent],
///   [orpAccent]) plus the [trendUp] / [trendDown] indicators.
///
/// Before this extension these colours were duplicated as inline `Color(0xFF…)`
/// literals in dozens of widgets, which made the palette impossible to keep
/// consistent. Read them through [BuildContextSemanticColors.semantic]:
///
/// ```dart
/// final c = context.semantic;
/// color: c.statusOptimal,
/// ```
///
/// [light] and [dark] currently share the same values, so the migration is
/// purely structural — tuning a colour now means editing this one file.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.statusOptimal,
    required this.statusWarning,
    required this.statusError,
    required this.statusLow,
    required this.temperatureAccent,
    required this.phAccent,
    required this.salinityAccent,
    required this.orpAccent,
    required this.trendUp,
    required this.trendDown,
  });

  /// Parameter within its healthy range (green).
  final Color statusOptimal;

  /// Parameter drifting toward the edge of its range (amber).
  final Color statusWarning;

  /// Parameter out of range or too high (red).
  final Color statusError;

  /// Parameter below its range — informational rather than alarming (blue).
  final Color statusLow;

  /// Brand accent for temperature surfaces.
  final Color temperatureAccent;

  /// Brand accent for pH surfaces.
  final Color phAccent;

  /// Brand accent for salinity surfaces.
  final Color salinityAccent;

  /// Brand accent for ORP / redox surfaces.
  final Color orpAccent;

  /// Indicator shown when a reading increased since the previous value.
  final Color trendUp;

  /// Indicator shown when a reading decreased since the previous value.
  final Color trendDown;

  /// Palette for the dark (default) ocean theme.
  static const AppSemanticColors dark = AppSemanticColors(
    statusOptimal: Color(0xFF34d399),
    statusWarning: Color(0xFFfbbf24),
    statusError: Color(0xFFef4444),
    statusLow: Color(0xFF60a5fa),
    temperatureAccent: Color(0xFFef4444),
    phAccent: Color(0xFF60a5fa),
    salinityAccent: Color(0xFF2dd4bf),
    orpAccent: Color(0xFF60a5fa),
    trendUp: Color(0xFFef4444),
    trendDown: Color(0xFF60a5fa),
  );

  /// Palette for the light theme. Mirrors [dark] for now (see class docs).
  static const AppSemanticColors light = dark;

  @override
  AppSemanticColors copyWith({
    Color? statusOptimal,
    Color? statusWarning,
    Color? statusError,
    Color? statusLow,
    Color? temperatureAccent,
    Color? phAccent,
    Color? salinityAccent,
    Color? orpAccent,
    Color? trendUp,
    Color? trendDown,
  }) {
    return AppSemanticColors(
      statusOptimal: statusOptimal ?? this.statusOptimal,
      statusWarning: statusWarning ?? this.statusWarning,
      statusError: statusError ?? this.statusError,
      statusLow: statusLow ?? this.statusLow,
      temperatureAccent: temperatureAccent ?? this.temperatureAccent,
      phAccent: phAccent ?? this.phAccent,
      salinityAccent: salinityAccent ?? this.salinityAccent,
      orpAccent: orpAccent ?? this.orpAccent,
      trendUp: trendUp ?? this.trendUp,
      trendDown: trendDown ?? this.trendDown,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      statusOptimal: Color.lerp(statusOptimal, other.statusOptimal, t)!,
      statusWarning: Color.lerp(statusWarning, other.statusWarning, t)!,
      statusError: Color.lerp(statusError, other.statusError, t)!,
      statusLow: Color.lerp(statusLow, other.statusLow, t)!,
      temperatureAccent: Color.lerp(
        temperatureAccent,
        other.temperatureAccent,
        t,
      )!,
      phAccent: Color.lerp(phAccent, other.phAccent, t)!,
      salinityAccent: Color.lerp(salinityAccent, other.salinityAccent, t)!,
      orpAccent: Color.lerp(orpAccent, other.orpAccent, t)!,
      trendUp: Color.lerp(trendUp, other.trendUp, t)!,
      trendDown: Color.lerp(trendDown, other.trendDown, t)!,
    );
  }
}

/// Ergonomic access to [AppSemanticColors] from a [BuildContext].
extension BuildContextSemanticColors on BuildContext {
  /// The active [AppSemanticColors].
  ///
  /// Falls back to [AppSemanticColors.dark] when no extension is registered
  /// (for example in widget tests that pump a bare [MaterialApp]), so callers
  /// never need a null check.
  AppSemanticColors get semantic =>
      Theme.of(this).extension<AppSemanticColors>() ?? AppSemanticColors.dark;
}
