import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff4c662b),
      surfaceTint: Color(0xff4c662b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffcdeda3),
      onPrimaryContainer: Color(0xff102000),
      secondary: Color(0xff4c662b),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffcdeda3),
      onSecondaryContainer: Color(0xff102000),
      tertiary: Color(0xff2b6a46),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffaff2c4),
      onTertiaryContainer: Color(0xff002110),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff9faef),
      onSurface: Color(0xff1a1c16),
      onSurfaceVariant: Color(0xff45483d),
      outline: Color(0xff75786c),
      outlineVariant: Color(0xffc5c8b9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f312a),
      inversePrimary: Color(0xffb1d18a),
      primaryFixed: Color(0xffcdeda3),
      onPrimaryFixed: Color(0xff102000),
      primaryFixedDim: Color(0xffb1d18a),
      onPrimaryFixedVariant: Color(0xff354e16),
      secondaryFixed: Color(0xffcdeda3),
      onSecondaryFixed: Color(0xff102000),
      secondaryFixedDim: Color(0xffb1d18a),
      onSecondaryFixedVariant: Color(0xff354e16),
      tertiaryFixed: Color(0xffaff2c4),
      onTertiaryFixed: Color(0xff002110),
      tertiaryFixedDim: Color(0xff94d5a9),
      onTertiaryFixedVariant: Color(0xff0c5130),
      surfaceDim: Color(0xffdadbd0),
      surfaceBright: Color(0xfff9faef),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f4e9),
      surfaceContainer: Color(0xffeeefe3),
      surfaceContainerHigh: Color(0xffe8e9de),
      surfaceContainerHighest: Color(0xffe2e3d8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff314a12),
      surfaceTint: Color(0xff4c662b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff617d3f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff314a12),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff617d3f),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff054d2c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff42815b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9faef),
      onSurface: Color(0xff1a1c16),
      onSurfaceVariant: Color(0xff414439),
      outline: Color(0xff5d6054),
      outlineVariant: Color(0xff797c6f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f312a),
      inversePrimary: Color(0xffb1d18a),
      primaryFixed: Color(0xff617d3f),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff496429),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff617d3f),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff496429),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff42815b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff286744),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdadbd0),
      surfaceBright: Color(0xfff9faef),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f4e9),
      surfaceContainer: Color(0xffeeefe3),
      surfaceContainerHigh: Color(0xffe8e9de),
      surfaceContainerHighest: Color(0xffe2e3d8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff152700),
      surfaceTint: Color(0xff4c662b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff314a12),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff152700),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff314a12),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff002914),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff054d2c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9faef),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff22251b),
      outline: Color(0xff414439),
      outlineVariant: Color(0xff414439),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f312a),
      inversePrimary: Color(0xffd6f7ac),
      primaryFixed: Color(0xff314a12),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff1c3300),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff314a12),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff1c3300),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff054d2c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff00341c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdadbd0),
      surfaceBright: Color(0xfff9faef),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f4e9),
      surfaceContainer: Color(0xffeeefe3),
      surfaceContainerHigh: Color(0xffe8e9de),
      surfaceContainerHighest: Color(0xffe2e3d8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb1d18a),
      surfaceTint: Color(0xffb1d18a),
      onPrimary: Color(0xff1f3701),
      primaryContainer: Color(0xff354e16),
      onPrimaryContainer: Color(0xffcdeda3),
      secondary: Color(0xffb1d18a),
      onSecondary: Color(0xff1f3701),
      secondaryContainer: Color(0xff354e16),
      onSecondaryContainer: Color(0xffcdeda3),
      tertiary: Color(0xff94d5a9),
      onTertiary: Color(0xff00391f),
      tertiaryContainer: Color(0xff0c5130),
      onTertiaryContainer: Color(0xffaff2c4),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff12140e),
      onSurface: Color(0xffe2e3d8),
      onSurfaceVariant: Color(0xffc5c8b9),
      outline: Color(0xff8f9284),
      outlineVariant: Color(0xff45483d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e3d8),
      inversePrimary: Color(0xff4c662b),
      primaryFixed: Color(0xffcdeda3),
      onPrimaryFixed: Color(0xff102000),
      primaryFixedDim: Color(0xffb1d18a),
      onPrimaryFixedVariant: Color(0xff354e16),
      secondaryFixed: Color(0xffcdeda3),
      onSecondaryFixed: Color(0xff102000),
      secondaryFixedDim: Color(0xffb1d18a),
      onSecondaryFixedVariant: Color(0xff354e16),
      tertiaryFixed: Color(0xffaff2c4),
      onTertiaryFixed: Color(0xff002110),
      tertiaryFixedDim: Color(0xff94d5a9),
      onTertiaryFixedVariant: Color(0xff0c5130),
      surfaceDim: Color(0xff12140e),
      surfaceBright: Color(0xff383a32),
      surfaceContainerLowest: Color(0xff0d0f09),
      surfaceContainerLow: Color(0xff1a1c16),
      surfaceContainer: Color(0xff1e201a),
      surfaceContainerHigh: Color(0xff282b24),
      surfaceContainerHighest: Color(0xff33362e),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb6d58e),
      surfaceTint: Color(0xffb1d18a),
      onPrimary: Color(0xff0c1a00),
      primaryContainer: Color(0xff7d9a59),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffb6d58e),
      onSecondary: Color(0xff0c1a00),
      secondaryContainer: Color(0xff7d9a59),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xff98d9ad),
      onTertiary: Color(0xff001b0c),
      tertiaryContainer: Color(0xff5f9e76),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff12140e),
      onSurface: Color(0xfffbfcf0),
      onSurfaceVariant: Color(0xffcaccbd),
      outline: Color(0xffa1a496),
      outlineVariant: Color(0xff818577),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e3d8),
      inversePrimary: Color(0xff364f17),
      primaryFixed: Color(0xffcdeda3),
      onPrimaryFixed: Color(0xff081400),
      primaryFixedDim: Color(0xffb1d18a),
      onPrimaryFixedVariant: Color(0xff253d05),
      secondaryFixed: Color(0xffcdeda3),
      onSecondaryFixed: Color(0xff081400),
      secondaryFixedDim: Color(0xffb1d18a),
      onSecondaryFixedVariant: Color(0xff253d05),
      tertiaryFixed: Color(0xffaff2c4),
      onTertiaryFixed: Color(0xff001508),
      tertiaryFixedDim: Color(0xff94d5a9),
      onTertiaryFixedVariant: Color(0xff003f23),
      surfaceDim: Color(0xff12140e),
      surfaceBright: Color(0xff383a32),
      surfaceContainerLowest: Color(0xff0d0f09),
      surfaceContainerLow: Color(0xff1a1c16),
      surfaceContainer: Color(0xff1e201a),
      surfaceContainerHigh: Color(0xff282b24),
      surfaceContainerHighest: Color(0xff33362e),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff4ffdf),
      surfaceTint: Color(0xffb1d18a),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffb6d58e),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff4ffdf),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffb6d58e),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffeffff0),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff98d9ad),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff12140e),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffafcec),
      outline: Color(0xffcaccbd),
      outlineVariant: Color(0xffcaccbd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e3d8),
      inversePrimary: Color(0xff1a3000),
      primaryFixed: Color(0xffd1f2a7),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffb6d58e),
      onPrimaryFixedVariant: Color(0xff0c1a00),
      secondaryFixed: Color(0xffd1f2a7),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb6d58e),
      onSecondaryFixedVariant: Color(0xff0c1a00),
      tertiaryFixed: Color(0xffb3f6c8),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff98d9ad),
      onTertiaryFixedVariant: Color(0xff001b0c),
      surfaceDim: Color(0xff12140e),
      surfaceBright: Color(0xff383a32),
      surfaceContainerLowest: Color(0xff0d0f09),
      surfaceContainerLow: Color(0xff1a1c16),
      surfaceContainer: Color(0xff1e201a),
      surfaceContainerHigh: Color(0xff282b24),
      surfaceContainerHighest: Color(0xff33362e),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
