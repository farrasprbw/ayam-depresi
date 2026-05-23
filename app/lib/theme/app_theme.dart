import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Brutalist design system constants
/// From DESIGN.md: "Fixed-Grid Brutalist model"
class AppThemeConstants {
  AppThemeConstants._();

  // Spacing (8px grid)
  static const double base = 8.0;
  static const double gutter = 16.0;
  static const double marginMobile = 20.0;
  static const double marginDesktop = 64.0;
  static const double containerMax = 1200.0;

  // Border widths (brutalist)
  static const double borderThin = 2.0;
  static const double borderThick = 4.0;

  // Hard-drop shadow offsets
  static const double shadowSmall = 4.0;
  static const double shadowLarge = 8.0;

  // Border radius (0 — brutalist sharp corners)
  static const double borderRadius = 0.0;

  /// Brutalist border — 4px solid black
  static Border get brutalBorder => Border.all(
        color: AppColors.primary,
        width: borderThick,
      );

  /// Brutalist border thin — 2px solid black
  static Border get brutalBorderThin => Border.all(
        color: AppColors.primary,
        width: borderThin,
      );

  /// Hard-drop shadow (small: 4px offset)
  static List<BoxShadow> get brutalShadow => [
        const BoxShadow(
          color: AppColors.primary,
          offset: Offset(shadowSmall, shadowSmall),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ];

  /// Hard-drop shadow (large: 8px offset)
  static List<BoxShadow> get brutalShadowLg => [
        const BoxShadow(
          color: AppColors.primary,
          offset: Offset(shadowLarge, shadowLarge),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ];

  /// Pressed state shadow (2px offset)
  static List<BoxShadow> get brutalShadowPressed => [
        const BoxShadow(
          color: AppColors.primary,
          offset: Offset(2, 2),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ];
}
