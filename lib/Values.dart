import 'package:flutter/material.dart';


// import 'colors.dart';
// import 'theme_data.dart';


class Values {
  static double fontSizeXSmall = 15;
  static double fontSizeSmall = 20;
  static double fontSizeMSmall = 25;
  static double fontSize = 30;
  static double fontSizeMLarge = 35;
  static double fontSizeLarge = 40;
  static double fontSizeXLarge = 45;

  static bool release = false;

  static ColorScheme lightTheme() {
    return ColorScheme(
      primary: ColorScheme.light().primary,
      primaryVariant: ColorScheme.light().primaryVariant,
      secondary: ColorScheme.light().secondary,
      secondaryVariant: ColorScheme.light().secondaryVariant,
      surface: ColorScheme.light().surface,
      background: ColorScheme.light().background,
      error: ColorScheme.light().error,
      onPrimary: ColorScheme.light().onPrimary,
      onSecondary: ColorScheme.light().onSecondary,
      onSurface: ColorScheme.light().onSurface,
      onBackground: ColorScheme.light().onBackground,
      onError: ColorScheme.light().onError,
      brightness: ColorScheme.light().brightness,
    );
  }
}

