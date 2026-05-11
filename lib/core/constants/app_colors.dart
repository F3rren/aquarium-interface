/// Centralised colour palette for the ReefLife app.
///
/// All colours follow a BMW iX–inspired design system: dark neutral
/// backgrounds, vibrant accent hues, and clearly differentiated status
/// colours.  Use these constants instead of raw [Color] literals so that
/// visual changes can be applied app-wide from a single location.
import 'package:flutter/material.dart';

/// Static colour palette used throughout the ReefLife UI.
///
/// The class is not meant to be instantiated — every member is either
/// `static const` or a lazily-computed `static` field.  Semi-transparent
/// variants (the `*Light` and `border*` fields) are computed once at class
/// load time via [Color.withValues].
class AppColors {
  // ---------------------------------------------------------------------------
  // Background colours
  // ---------------------------------------------------------------------------

  /// Primary dark surface colour used for full-screen backgrounds.
  static const Color backgroundDark = Color(0xFF2d2d2d);

  /// Card / elevated surface colour, slightly lighter than [backgroundDark].
  static const Color backgroundCard = Color(0xFF3a3a3a);

  /// Secondary dark surface, used for input fields and secondary containers.
  static const Color backgroundLight = Color(0xFF4a4a4a);

  // ---------------------------------------------------------------------------
  // Primary accent colours
  // ---------------------------------------------------------------------------

  /// Sky-blue accent — used for water-related parameters and primary actions.
  static const Color primaryBlue = Color(0xFF60a5fa);

  /// Emerald-green accent — used for "safe" / optimal-range indicators.
  static const Color primaryGreen = Color(0xFF34d399);

  /// Red accent — used for errors, critical alerts, and destructive actions.
  static const Color primaryRed = Color(0xFFef4444);

  /// Teal accent — used for salinity and reef-specific highlights.
  static const Color primaryTeal = Color(0xFF2dd4bf);

  /// Purple accent — used for equipment-category labels.
  static const Color primaryPurple = Color(0xFFa855f7);

  /// Pink accent — used for dosing-category labels and coral highlights.
  static const Color primaryPink = Color(0xFFec4899);

  // ---------------------------------------------------------------------------
  // Text colours
  // ---------------------------------------------------------------------------

  /// Full-opacity white text — primary body and headline text on dark surfaces.
  static const Color textWhite = Colors.white;

  /// 60 % white — secondary / subtitle text on dark surfaces.
  static const Color textGray = Colors.white60;

  /// 38 % white — disabled or hint text on dark surfaces.
  static const Color textGrayLight = Colors.white38;

  // ---------------------------------------------------------------------------
  // Border colours (semi-transparent, computed at load time)
  // ---------------------------------------------------------------------------

  /// Subtle border at 10 % white opacity — separators and card outlines.
  static Color borderLight = Colors.white.withValues(alpha: 0.1);

  /// Medium border at 20 % white opacity — focused inputs and dividers.
  static Color borderMedium = Colors.white.withValues(alpha: 0.2);

  // ---------------------------------------------------------------------------
  // Status colours
  // ---------------------------------------------------------------------------

  /// Indicates a successful operation or an in-range parameter value.
  static const Color statusSuccess = Color(0xFF34d399);

  /// Indicates a warning or a parameter approaching its safe-range boundary.
  static const Color statusWarning = Color(0xFFfbbf24);

  /// Indicates an error or a parameter outside its safe range.
  static const Color statusError = Color(0xFFef4444);

  /// Indicates an informational state or a neutral parameter reading.
  static const Color statusInfo = Color(0xFF60a5fa);

  // ---------------------------------------------------------------------------
  // Gradient colour stops
  // ---------------------------------------------------------------------------

  /// Two-stop dark gradient for full-screen and card backgrounds.
  static const List<Color> gradientDark = [
    Color(0xFF2d2d2d),
    Color(0xFF1a1a1a),
  ];

  /// Two-stop blue gradient for primary action buttons and highlights.
  static const List<Color> gradientBlue = [
    Color(0xFF60a5fa),
    Color(0xFF3b82f6),
  ];

  /// Two-stop teal gradient for reef/saltwater themed UI elements.
  static const List<Color> gradientTeal = [
    Color(0xFF2dd4bf),
    Color(0xFF14b8a6),
  ];

  // ---------------------------------------------------------------------------
  // Opacity helpers
  // ---------------------------------------------------------------------------

  /// Returns [color] at the given [opacity] (0.0–1.0).
  ///
  /// Prefer the pre-computed `*Light` variants below when a fixed 20 % alpha
  /// is sufficient, to avoid redundant allocations in build methods.
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// [primaryBlue] at 20 % opacity — used for blue chip/badge backgrounds.
  static Color primaryBlueLight = primaryBlue.withValues(alpha: 0.2);

  /// [primaryGreen] at 20 % opacity — used for success chip/badge backgrounds.
  static Color primaryGreenLight = primaryGreen.withValues(alpha: 0.2);

  /// [primaryRed] at 20 % opacity — used for error chip/badge backgrounds.
  static Color primaryRedLight = primaryRed.withValues(alpha: 0.2);

  /// [primaryTeal] at 20 % opacity — used for teal chip/badge backgrounds.
  static Color primaryTealLight = primaryTeal.withValues(alpha: 0.2);

  // ---------------------------------------------------------------------------
  // Parameter-specific indicator colours
  // ---------------------------------------------------------------------------

  /// Temperature reading below the safe minimum threshold.
  static const Color temperatureLow = Color(0xFF60a5fa);

  /// Temperature reading within the optimal range.
  static const Color temperatureOptimal = Color(0xFF34d399);

  /// Temperature reading above the safe maximum threshold.
  static const Color temperatureHigh = Color(0xFFef4444);

  /// pH reading below the safe minimum threshold.
  static const Color phLow = Color(0xFFef4444);

  /// pH reading within the optimal range.
  static const Color phOptimal = Color(0xFF34d399);

  /// pH reading above the safe maximum threshold.
  static const Color phHigh = Color(0xFFef4444);

  /// Salinity reading below the safe minimum threshold.
  static const Color salinityLow = Color(0xFFef4444);

  /// Salinity reading within the optimal range.
  static const Color salinityOptimal = Color(0xFF34d399);

  /// Salinity reading above the safe maximum threshold.
  static const Color salinityHigh = Color(0xFFef4444);

  /// ORP reading below the safe minimum threshold.
  static const Color orpLow = Color(0xFFef4444);

  /// ORP reading within the optimal range.
  static const Color orpOptimal = Color(0xFF34d399);

  /// ORP reading above the safe maximum threshold.
  static const Color orpHigh = Color(0xFFef4444);
}
