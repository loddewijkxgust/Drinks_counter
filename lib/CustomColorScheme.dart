// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show Brightness;
// import 'package:flutter/widgets.dart';


// @immutable
// class CustomColorScheme with Diagnosticable implements ColorScheme {
  
//   const CustomColorScheme({
//     required this.primary,
//     required this.primaryVariant,
//     required this.secondary,
//     required this.secondaryVariant,
//     required this.surface,
//     required this.background,
//     required this.error,
//     required this.onPrimary,
//     required this.onSecondary,
//     required this.onSurface,
//     required this.onBackground,
//     required this.onError,
//     required this.brightness,
//   }) : assert(primary != null),
//        assert(primaryVariant != null),
//        assert(secondary != null),
//        assert(secondaryVariant != null),
//        assert(surface != null),
//        assert(background != null),
//        assert(error != null),
//        assert(onPrimary != null),
//        assert(onSecondary != null),
//        assert(onSurface != null),
//        assert(onBackground != null),
//        assert(onError != null),
//        assert(brightness != null);

  
  
//   const CustomColorScheme.light({
//     this.primary = const Color(0xff6200ee),
//     this.primaryVariant = const Color(0xff3700b3),
//     this.secondary = const Color(0xff03dac6),
//     this.secondaryVariant = const Color(0xff018786),
//     this.surface = Colors.white,
//     this.background = Colors.white,
//     this.error = const Color(0xffb00020),
//     this.onPrimary = Colors.white,
//     this.onSecondary = Colors.black,
//     this.onSurface = Colors.black,
//     this.onBackground = Colors.black,
//     this.onError = Colors.white,
//     this.brightness = Brightness.light,
//   }) : assert(primary != null),
//        assert(primaryVariant != null),
//        assert(secondary != null),
//        assert(secondaryVariant != null),
//        assert(surface != null),
//        assert(background != null),
//        assert(error != null),
//        assert(onPrimary != null),
//        assert(onSecondary != null),
//        assert(onSurface != null),
//        assert(onBackground != null),
//        assert(onError != null),
//        assert(brightness != null);

  
  
//   const CustomColorScheme.dark({
//     this.primary = const Color(0xffbb86fc),
//     this.primaryVariant = const Color(0xff3700B3),
//     this.secondary = const Color(0xff03dac6),
//     this.secondaryVariant = const Color(0xff03dac6),
//     this.surface = const Color(0xff121212),
//     this.background = const Color(0xff121212),
//     this.error = const Color(0xffcf6679),
//     this.onPrimary = Colors.black,
//     this.onSecondary = Colors.black,
//     this.onSurface = Colors.white,
//     this.onBackground = Colors.white,
//     this.onError = Colors.black,
//     this.brightness = Brightness.dark,
//   }) : assert(primary != null),
//        assert(primaryVariant != null),
//        assert(secondary != null),
//        assert(secondaryVariant != null),
//        assert(surface != null),
//        assert(background != null),
//        assert(error != null),
//        assert(onPrimary != null),
//        assert(onSecondary != null),
//        assert(onSurface != null),
//        assert(onBackground != null),
//        assert(onError != null),
//        assert(brightness != null);


  
  
//   const CustomColorScheme.highContrastLight({
//     this.primary = const Color(0xff0000ba),
//     this.primaryVariant = const Color(0xff000088),
//     this.secondary = const Color(0xff66fff9),
//     this.secondaryVariant = const Color(0xff018786),
//     this.surface = Colors.white,
//     this.background = Colors.white,
//     this.error = const Color(0xff790000),
//     this.onPrimary = Colors.white,
//     this.onSecondary = Colors.black,
//     this.onSurface = Colors.black,
//     this.onBackground = Colors.black,
//     this.onError = Colors.white,
//     this.brightness = Brightness.light,
//   }) : assert(primary != null),
//         assert(primaryVariant != null),
//         assert(secondary != null),
//         assert(secondaryVariant != null),
//         assert(surface != null),
//         assert(background != null),
//         assert(error != null),
//         assert(onPrimary != null),
//         assert(onSecondary != null),
//         assert(onSurface != null),
//         assert(onBackground != null),
//         assert(onError != null),
//         assert(brightness != null);

  
  
//   const CustomColorScheme.highContrastDark({
//     this.primary = const Color(0xffefb7ff),
//     this.primaryVariant = const Color(0xffbe9eff),
//     this.secondary = const Color(0xff66fff9),
//     this.secondaryVariant = const Color(0xff66fff9),
//     this.surface = const Color(0xff121212),
//     this.background = const Color(0xff121212),
//     this.error = const Color(0xff9b374d),
//     this.onPrimary = Colors.black,
//     this.onSecondary = Colors.black,
//     this.onSurface = Colors.white,
//     this.onBackground = Colors.white,
//     this.onError = Colors.black,
//     this.brightness = Brightness.dark,
//   }) : assert(primary != null),
//         assert(primaryVariant != null),
//         assert(secondary != null),
//         assert(secondaryVariant != null),
//         assert(surface != null),
//         assert(background != null),
//         assert(error != null),
//         assert(onPrimary != null),
//         assert(onSecondary != null),
//         assert(onSurface != null),
//         assert(onBackground != null),
//         assert(onError != null),
//         assert(brightness != null);

  
  
  
  
//   factory CustomColorScheme.fromSwatch({
//     MaterialColor primarySwatch = Colors.blue,
//     Color? primaryColorDark,
//     Color? accentColor,
//     Color? cardColor,
//     Color? backgroundColor,
//     Color? errorColor,
//     Brightness brightness = Brightness.light,
//   }) {
//     assert(primarySwatch != null);
//     assert(brightness != null);

//     final bool isDark = brightness == Brightness.dark;
//     final bool primaryIsDark = _brightnessFor(primarySwatch) == Brightness.dark;
//     final Color secondary = accentColor ?? (isDark ? Colors.tealAccent[200]! : primarySwatch);
//     final bool secondaryIsDark = _brightnessFor(secondary) == Brightness.dark;

//     return CustomColorScheme(
//       primary: primarySwatch,
//       primaryVariant: primaryColorDark ?? (isDark ? Colors.black : primarySwatch[700]!),
//       secondary: secondary,
//       secondaryVariant: isDark ? Colors.tealAccent[700]! : primarySwatch[700]!,
//       surface: cardColor ?? (isDark ? Colors.grey[800]! : Colors.white),
//       background: backgroundColor ?? (isDark ? Colors.grey[700]! : primarySwatch[200]!),
//       error: errorColor ?? Colors.red[700]!,
//       onPrimary: primaryIsDark ? Colors.white : Colors.black,
//       onSecondary: secondaryIsDark ? Colors.white : Colors.black,
//       onSurface: isDark ? Colors.white : Colors.black,
//       onBackground: primaryIsDark ? Colors.white : Colors.black,
//       onError: isDark ? Colors.black : Colors.white,
//       brightness: brightness,
//     );
//   }

//   static Brightness _brightnessFor(Color color) => ThemeData.estimateBrightnessForColor(color);

  
//   final Color primary;

  
//   final Color primaryVariant;

  
  
//   final Color secondary;

  
//   final Color secondaryVariant;

  
//   final Color surface;

  
//   final Color background;

  
  
//   final Color error;

  
  
  
  
  
//   final Color onPrimary;

  
  
  
  
  
//   final Color onSecondary;

  
  
  
  
  
//   final Color onSurface;

  
  
  
  
  
//   final Color onBackground;

  
  
  
  
  
//   final Color onError;

  
//   final Brightness brightness;

  
  
//   CustomColorScheme copyWith({
//     Color? primary,
//     Color? primaryVariant,
//     Color? secondary,
//     Color? secondaryVariant,
//     Color? surface,
//     Color? background,
//     Color? error,
//     Color? onPrimary,
//     Color? onSecondary,
//     Color? onSurface,
//     Color? onBackground,
//     Color? onError,
//     Brightness? brightness,
//   }) {
//     return CustomColorScheme(
//       primary: primary ?? this.primary,
//       primaryVariant: primaryVariant ?? this.primaryVariant,
//       secondary: secondary ?? this.secondary,
//       secondaryVariant: secondaryVariant ?? this.secondaryVariant,
//       surface: surface ?? this.surface,
//       background: background ?? this.background,
//       error: error ?? this.error,
//       onPrimary: onPrimary ?? this.onPrimary,
//       onSecondary: onSecondary ?? this.onSecondary,
//       onSurface: onSurface ?? this.onSurface,
//       onBackground: onBackground ?? this.onBackground,
//       onError: onError ?? this.onError,
//       brightness: brightness ?? this.brightness,
//     );
//   }

  
  
  
//   static CustomColorScheme lerp(CustomColorScheme a, CustomColorScheme b, double t) {
//     return CustomColorScheme(
//       primary: Color.lerp(a.primary, b.primary, t)!,
//       primaryVariant: Color.lerp(a.primaryVariant, b.primaryVariant, t)!,
//       secondary: Color.lerp(a.secondary, b.secondary, t)!,
//       secondaryVariant: Color.lerp(a.secondaryVariant, b.secondaryVariant, t)!,
//       surface: Color.lerp(a.surface, b.surface, t)!,
//       background: Color.lerp(a.background, b.background, t)!,
//       error: Color.lerp(a.error, b.error, t)!,
//       onPrimary: Color.lerp(a.onPrimary, b.onPrimary, t)!,
//       onSecondary: Color.lerp(a.onSecondary, b.onSecondary, t)!,
//       onSurface: Color.lerp(a.onSurface, b.onSurface, t)!,
//       onBackground: Color.lerp(a.onBackground, b.onBackground, t)!,
//       onError: Color.lerp(a.onError, b.onError, t)!,
//       brightness: t < 0.5 ? a.brightness : b.brightness,
//     );
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other))
//       return true;
//     if (other.runtimeType != runtimeType)
//       return false;
//     return other is CustomColorScheme
//         && other.primary == primary
//         && other.primaryVariant == primaryVariant
//         && other.secondary == secondary
//         && other.secondaryVariant == secondaryVariant
//         && other.surface == surface
//         && other.background == background
//         && other.error == error
//         && other.onPrimary == onPrimary
//         && other.onSecondary == onSecondary
//         && other.onSurface == onSurface
//         && other.onBackground == onBackground
//         && other.onError == onError
//         && other.brightness == brightness;
//   }

//   @override
//   int get hashCode {
//     return hashValues(
//       primary,
//       primaryVariant,
//       secondary,
//       secondaryVariant,
//       surface,
//       background,
//       error,
//       onPrimary,
//       onSecondary,
//       onSurface,
//       onBackground,
//       onError,
//       brightness,
//     );
//   }

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     const CustomColorScheme defaultScheme = CustomColorScheme.light();
//     properties.add(ColorProperty('primary', primary, defaultValue: defaultScheme.primary));
//     properties.add(ColorProperty('primaryVariant', primaryVariant, defaultValue: defaultScheme.primaryVariant));
//     properties.add(ColorProperty('secondary', secondary, defaultValue: defaultScheme.secondary));
//     properties.add(ColorProperty('secondaryVariant', secondaryVariant, defaultValue: defaultScheme.secondaryVariant));
//     properties.add(ColorProperty('surface', surface, defaultValue: defaultScheme.surface));
//     properties.add(ColorProperty('background', background, defaultValue: defaultScheme.background));
//     properties.add(ColorProperty('error', error, defaultValue: defaultScheme.error));
//     properties.add(ColorProperty('onPrimary', onPrimary, defaultValue: defaultScheme.onPrimary));
//     properties.add(ColorProperty('onSecondary', onSecondary, defaultValue: defaultScheme.onSecondary));
//     properties.add(ColorProperty('onSurface', onSurface, defaultValue: defaultScheme.onSurface));
//     properties.add(ColorProperty('onBackground', onBackground, defaultValue: defaultScheme.onBackground));
//     properties.add(ColorProperty('onError', onError, defaultValue: defaultScheme.onError));
//     properties.add(DiagnosticsProperty<Brightness>('brightness', brightness, defaultValue: defaultScheme.brightness));
//   }
// }

