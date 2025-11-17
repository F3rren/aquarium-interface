import 'package:flutter/material.dart';

/// BMW iX inspired color palette for the Acquarium app
class AppColors {
  // Background colors
  static const Color backgroundDark = Color(0xFF2d2d2d);
  static const Color backgroundCard = Color(0xFF3a3a3a);
  static const Color backgroundLight = Color(0xFF4a4a4a);
  
  // Primary accent colors
  static const Color primaryBlue = Color(0xFF60a5fa);
  static const Color primaryGreen = Color(0xFF34d399);
  static const Color primaryRed = Color(0xFFef4444);
  static const Color primaryTeal = Color(0xFF2dd4bf);
  static const Color primaryPurple = Color(0xFFa855f7);
  static const Color primaryPink = Color(0xFFec4899);
  
  // Text colors
  static const Color textWhite = Colors.white;
  static const Color textGray = Colors.white60;
  static const Color textGrayLight = Colors.white38;
  
  // Border colors
  static Color borderLight = Colors.white.withValues(alpha: 0.1);
  static Color borderMedium = Colors.white.withValues(alpha: 0.2);
  
  // Status colors
  static const Color statusSuccess = Color(0xFF34d399);
  static const Color statusWarning = Color(0xFFfbbf24);
  static const Color statusError = Color(0xFFef4444);
  static const Color statusInfo = Color(0xFF60a5fa);
  
  // Gradient colors
  static const List<Color> gradientDark = [
    Color(0xFF2d2d2d),
    Color(0xFF1a1a1a),
  ];
  
  static const List<Color> gradientBlue = [
    Color(0xFF60a5fa),
    Color(0xFF3b82f6),
  ];
  
  static const List<Color> gradientTeal = [
    Color(0xFF2dd4bf),
    Color(0xFF14b8a6),
  ];
  
  // Helper methods for opacity variations
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
  
  static Color primaryBlueLight = primaryBlue.withValues(alpha: 0.2);
  static Color primaryGreenLight = primaryGreen.withValues(alpha: 0.2);
  static Color primaryRedLight = primaryRed.withValues(alpha: 0.2);
  static Color primaryTealLight = primaryTeal.withValues(alpha: 0.2);
  
  // Parameter specific colors
  static const Color temperatureLow = Color(0xFF60a5fa);
  static const Color temperatureOptimal = Color(0xFF34d399);
  static const Color temperatureHigh = Color(0xFFef4444);
  
  static const Color phLow = Color(0xFFef4444);
  static const Color phOptimal = Color(0xFF34d399);
  static const Color phHigh = Color(0xFFef4444);
  
  static const Color salinityLow = Color(0xFFef4444);
  static const Color salinityOptimal = Color(0xFF34d399);
  static const Color salinityHigh = Color(0xFFef4444);
  
  static const Color orpLow = Color(0xFFef4444);
  static const Color orpOptimal = Color(0xFF34d399);
  static const Color orpHigh = Color(0xFFef4444);
}
