import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Philips Hue–inspired text styles
///
/// Hue's design uses a clean, rounded geometric font (Poppins)
/// with smooth weight contrast and generous spacing.
class AppTextStyles {
  // Headline 1 — Big titles, splash screens
  static TextStyle headline1 = GoogleFonts.nunito(
    color: kTextColor,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  // Headline 2 — Page titles / Section headers
  static TextStyle headline2 = GoogleFonts.nunito(
    color: kTextColor,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  // Headline 3 — Sub-headers / Prominent labels
  static TextStyle headline3 = GoogleFonts.nunito(
    color: kTextColor,
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );

  // Body Large — Regular paragraph text
  static TextStyle bodyLarge = GoogleFonts.nunito(
    color: kTextColor,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  // Body Medium — Common readable text
  static TextStyle bodyMedium = GoogleFonts.nunito(
    color: kTextColor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  // Body Small — Captions, secondary info
  static TextStyle bodySmall = GoogleFonts.nunito(
    color: kTextColor.withOpacity(0.8),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // Label / Button text — uppercase accent labels
  static TextStyle label = GoogleFonts.nunito(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
  );

  // Accent text — amber/CTA color (for highlights)
  static TextStyle accent = GoogleFonts.nunito(
    color: kAccentColor,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  // Muted — subtle placeholder or hint
  static TextStyle muted = GoogleFonts.nunito(
    color: kTextColor.withOpacity(0.6),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}
