import 'package:findzy/core/constants/app_colors.dart';
import 'package:findzy/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData hueTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kBgColor,
    cardColor: kCardColor,
    colorScheme: const ColorScheme.dark(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      surface: kCardColor,
      background: kBgColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: kTextColor,
      onBackground: kTextColor,
    ),

    // Apply your Poppins font globally
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: AppTextStyles.headline1,
      displayMedium: AppTextStyles.headline2,
      displaySmall: AppTextStyles.headline3,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.label,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: kBgColor,
      foregroundColor: kTextColor,
      elevation: 0,
      titleTextStyle: AppTextStyles.headline3,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kAccentColor,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: AppTextStyles.label,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kCardColor,
      hintStyle: AppTextStyles.muted,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimaryColor, width: 2),
      ),
    ),
  );
}
