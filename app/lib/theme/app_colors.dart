import 'package:flutter/material.dart';

/// Color system from DESIGN.md — "Noir-Kraft" Brutalist palette
class AppColors {
  AppColors._();

  // Brand colors
  static const Color brandRed = Color(0xFFC41E1E);
  static const Color accentRed = Color(0xFFE63946);

  // Surface colors
  static const Color surface = Color(0xFFFDF8F8);
  static const Color surfaceDim = Color(0xFFDDD9D8);
  static const Color surfaceBright = Color(0xFFFDF8F8);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF7F3F2);
  static const Color surfaceContainer = Color(0xFFF1EDEC);
  static const Color surfaceContainerHigh = Color(0xFFEBE7E6);
  static const Color surfaceContainerHighest = Color(0xFFE5E2E1);
  static const Color surfaceVariant = Color(0xFFE5E2E1);
  static const Color surfaceTint = Color(0xFF5F5E5E);

  // On-surface colors
  static const Color onSurface = Color(0xFF1C1B1B);
  static const Color onSurfaceVariant = Color(0xFF444748);

  // Inverse
  static const Color inverseSurface = Color(0xFF313030);
  static const Color inverseOnSurface = Color(0xFFF4F0EF);
  static const Color inversePrimary = Color(0xFFC8C6C5);

  // Primary
  static const Color primary = Color(0xFF000000);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF1C1B1B);
  static const Color onPrimaryContainer = Color(0xFF858383);

  // Secondary
  static const Color secondary = Color(0xFF5F5E5E);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE4E2E1);
  static const Color onSecondaryContainer = Color(0xFF656464);

  // Tertiary
  static const Color tertiary = Color(0xFF000000);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF1C1B1A);
  static const Color onTertiaryContainer = Color(0xFF868382);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Outline
  static const Color outline = Color(0xFF747878);
  static const Color outlineVariant = Color(0xFFC4C7C7);

  // Background
  static const Color background = Color(0xFFFDF8F8);
  static const Color onBackground = Color(0xFF1C1B1B);

  // Fixed variants
  static const Color primaryFixed = Color(0xFFE5E2E1);
  static const Color primaryFixedDim = Color(0xFFC8C6C5);
  static const Color secondaryFixed = Color(0xFFE4E2E1);
  static const Color secondaryFixedDim = Color(0xFFC8C6C6);
  static const Color tertiaryFixed = Color(0xFFE6E2DF);
  static const Color tertiaryFixedDim = Color(0xFFCAC6C4);
}
