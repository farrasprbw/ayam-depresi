import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system from DESIGN.md
/// - Headlines: Bricolage Grotesque (quirky, distorted)
/// - Body: Plus Jakarta Sans (readable, soft)
/// - Technical: JetBrains Mono (industrial, monospaced)
class AppTypography {
  AppTypography._();

  // Display — 72px, weight 800
  static TextStyle get display => GoogleFonts.bricolageGrotesque(
        fontSize: 72,
        fontWeight: FontWeight.w800,
        height: 1.0,
        letterSpacing: -0.04 * 72,
      );

  // Headline Large — 48px, weight 800
  static TextStyle get headlineLg => GoogleFonts.bricolageGrotesque(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -0.02 * 48,
      );

  // Headline Large Mobile — 36px, weight 800
  static TextStyle get headlineLgMobile => GoogleFonts.bricolageGrotesque(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        height: 1.1,
      );

  // Headline Medium — 32px, weight 700
  static TextStyle get headlineMd => GoogleFonts.bricolageGrotesque(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  // Body Large — 18px, weight 500
  static TextStyle get bodyLg => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.6,
      );

  // Body Medium — 16px, weight 400
  static TextStyle get bodyMd => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  // Label Mono — 14px, weight 600
  static TextStyle get labelMono => GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  // Label Mono Small — 10px, weight 600
  static TextStyle get labelMonoSmall => GoogleFonts.jetBrainsMono(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );
}
