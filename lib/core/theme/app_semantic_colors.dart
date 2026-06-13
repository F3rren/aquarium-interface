/// Semantic colour tokens for the ReefLife design system.
library;

import 'package:flutter/material.dart';

/// A [ThemeExtension] that centralises the app's semantic colours.
///
/// Three families live here:
/// - **Status palette** — conveys parameter health: [statusOptimal] (in range),
///   [statusWarning] (drifting), [statusError] (out of range / high), and
///   [statusLow] (below range, shown as informational rather than alarming).
/// - **Parameter accents** — the per-parameter brand colours used on gauges,
///   cards, and dialogs ([temperatureAccent], [phAccent], [salinityAccent],
///   [orpAccent]) plus the [trendUp] / [trendDown] indicators.
/// - **Decorative accents** — [accentViolet], [accentPink], [accentNeutral]
///   used for non-status categories (corals, fish, muted chips, …).
///
/// Before this extension these colours were duplicated as inline `Color(0xFF…)`
/// literals across dozens of widgets, which made the palette impossible to keep
/// consistent. Read them through [BuildContextSemanticColors.semantic]:
///
/// ```dart
/// final c = context.semantic;
/// color: c.statusOptimal,
/// ```
///
/// [dark] and [light] carry **different, calibrated values**: the dark palette
/// uses the lighter Tailwind 400 shades that glow on the deep-navy background,
/// while the light palette steps one shade deeper (500/600) so the same colours
/// keep enough contrast on near-white surfaces. Tune the whole app's palette
/// from this one file.
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
    required this.accentViolet,
    required this.accentPink,
    required this.accentNeutral,
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

  /// Decorative accent (violet) — corals and other non-status categories.
  final Color accentViolet;

  /// Decorative accent (pink) — secondary category highlight.
  final Color accentPink;

  /// Muted neutral accent for disabled / informational chips.
  final Color accentNeutral;

  /// Palette for the dark (default) ocean theme — Tailwind 400-ish shades.
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
    accentViolet: Color(0xFF8b5cf6),
    accentPink: Color(0xFFec4899),
    accentNeutral: Color(0xFF6b7280),
  );

  /// Palette for the light theme — one shade deeper for contrast on white.
  static const AppSemanticColors light = AppSemanticColors(
    statusOptimal: Color(0xFF10b981),
    statusWarning: Color(0xFFf59e0b),
    statusError: Color(0xFFdc2626),
    statusLow: Color(0xFF3b82f6),
    temperatureAccent: Color(0xFFdc2626),
    phAccent: Color(0xFF3b82f6),
    salinityAccent: Color(0xFF14b8a6),
    orpAccent: Color(0xFF3b82f6),
    trendUp: Color(0xFFdc2626),
    trendDown: Color(0xFF3b82f6),
    accentViolet: Color(0xFF7c3aed),
    accentPink: Color(0xFFdb2777),
    accentNeutral: Color(0xFF64748b),
  );

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
    Color? accentViolet,
    Color? accentPink,
    Color? accentNeutral,
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
      accentViolet: accentViolet ?? this.accentViolet,
      accentPink: accentPink ?? this.accentPink,
      accentNeutral: accentNeutral ?? this.accentNeutral,
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
      accentViolet: Color.lerp(accentViolet, other.accentViolet, t)!,
      accentPink: Color.lerp(accentPink, other.accentPink, t)!,
      accentNeutral: Color.lerp(accentNeutral, other.accentNeutral, t)!,
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
