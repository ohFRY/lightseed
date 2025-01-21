import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3f6900),
      surfaceTint: Color(0xff3f6900),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff93d541),
      onPrimaryContainer: Color(0xff213a00),
      secondary: Color(0xff334a18),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff556e38),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4f6700),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8ba83e),
      onTertiaryContainer: Color(0xff0b1100),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff7fbea),
      onSurface: Color(0xff191d13),
      onSurfaceVariant: Color(0xff424937),
      outline: Color(0xff727a66),
      outlineVariant: Color(0xffc2cab2),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3227),
      inversePrimary: Color(0xff97d945),
      primaryFixed: Color(0xffb2f65f),
      onPrimaryFixed: Color(0xff102000),
      primaryFixedDim: Color(0xff97d945),
      onPrimaryFixedVariant: Color(0xff2f4f00),
      secondaryFixed: Color(0xffcfecaa),
      onSecondaryFixed: Color(0xff0f2000),
      secondaryFixedDim: Color(0xffb3d090),
      onSecondaryFixedVariant: Color(0xff364d1b),
      tertiaryFixed: Color(0xffcfef7c),
      onTertiaryFixed: Color(0xff151f00),
      tertiaryFixedDim: Color(0xffb3d263),
      onTertiaryFixedVariant: Color(0xff3a4d00),
      surfaceDim: Color(0xffd8dccc),
      surfaceBright: Color(0xfff7fbea),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f5e5),
      surfaceContainer: Color(0xffecf0df),
      surfaceContainerHigh: Color(0xffe6eada),
      surfaceContainerHighest: Color(0xffe0e4d4),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff2c4b00),
      surfaceTint: Color(0xff3f6900),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4f8200),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff334918),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff556e38),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff374900),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff637e16),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7fbea),
      onSurface: Color(0xff191d13),
      onSurfaceVariant: Color(0xff3e4534),
      outline: Color(0xff5a624f),
      outlineVariant: Color(0xff767e69),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3227),
      inversePrimary: Color(0xff97d945),
      primaryFixed: Color(0xff4f8200),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff3e6700),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff637c45),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4b632f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff637e16),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4d6400),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd8dccc),
      surfaceBright: Color(0xfff7fbea),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f5e5),
      surfaceContainer: Color(0xffecf0df),
      surfaceContainerHigh: Color(0xffe6eada),
      surfaceContainerHighest: Color(0xffe0e4d4),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff142700),
      surfaceTint: Color(0xff3f6900),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2c4b00),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff142700),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff334918),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff1b2600),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff374900),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7fbea),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff1f2617),
      outline: Color(0xff3e4534),
      outlineVariant: Color(0xff3e4534),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3227),
      inversePrimary: Color(0xffbfff72),
      primaryFixed: Color(0xff2c4b00),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff1c3300),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff334918),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff1d3203),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff374900),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff243100),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd8dccc),
      surfaceBright: Color(0xfff7fbea),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f5e5),
      surfaceContainer: Color(0xffecf0df),
      surfaceContainerHigh: Color(0xffe6eada),
      surfaceContainerHighest: Color(0xffe0e4d4),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffacf059),
      surfaceTint: Color(0xff97d945),
      onPrimary: Color(0xff1f3700),
      primaryContainer: Color(0xff84c432),
      onPrimaryContainer: Color(0xff182c00),
      secondary: Color(0xffb3d090),
      onSecondary: Color(0xff213606),
      secondaryContainer: Color(0xff3c5421),
      onSecondaryContainer: Color(0xffd7f5b1),
      tertiary: Color(0xffb3d263),
      onTertiary: Color(0xff273500),
      tertiaryContainer: Color(0xff637e16),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff11150b),
      onSurface: Color(0xffe0e4d4),
      onSurfaceVariant: Color(0xffc2cab2),
      outline: Color(0xff8c947e),
      outlineVariant: Color(0xff424937),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4d4),
      inversePrimary: Color(0xff3f6900),
      primaryFixed: Color(0xffb2f65f),
      onPrimaryFixed: Color(0xff102000),
      primaryFixedDim: Color(0xff97d945),
      onPrimaryFixedVariant: Color(0xff2f4f00),
      secondaryFixed: Color(0xffcfecaa),
      onSecondaryFixed: Color(0xff0f2000),
      secondaryFixedDim: Color(0xffb3d090),
      onSecondaryFixedVariant: Color(0xff364d1b),
      tertiaryFixed: Color(0xffcfef7c),
      onTertiaryFixed: Color(0xff151f00),
      tertiaryFixedDim: Color(0xffb3d263),
      onTertiaryFixedVariant: Color(0xff3a4d00),
      surfaceDim: Color(0xff11150b),
      surfaceBright: Color(0xff363b2f),
      surfaceContainerLowest: Color(0xff0b0f07),
      surfaceContainerLow: Color(0xff191d13),
      surfaceContainer: Color(0xff1d2117),
      surfaceContainerHigh: Color(0xff272b21),
      surfaceContainerHighest: Color(0xff32362b),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffacf059),
      surfaceTint: Color(0xff97d945),
      onPrimary: Color(0xff172b00),
      primaryContainer: Color(0xff84c432),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffb7d494),
      onSecondary: Color(0xff0c1a00),
      secondaryContainer: Color(0xff7e995e),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffb8d667),
      onTertiary: Color(0xff111900),
      tertiaryContainer: Color(0xff7f9b33),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff11150b),
      onSurface: Color(0xfff9fdec),
      onSurfaceVariant: Color(0xffc6ceb6),
      outline: Color(0xff9ea690),
      outlineVariant: Color(0xff7e8671),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4d4),
      inversePrimary: Color(0xff2f5100),
      primaryFixed: Color(0xffb2f65f),
      onPrimaryFixed: Color(0xff081400),
      primaryFixedDim: Color(0xff97d945),
      onPrimaryFixedVariant: Color(0xff233d00),
      secondaryFixed: Color(0xffcfecaa),
      onSecondaryFixed: Color(0xff081400),
      secondaryFixedDim: Color(0xffb3d090),
      onSecondaryFixedVariant: Color(0xff263c0c),
      tertiaryFixed: Color(0xffcfef7c),
      onTertiaryFixed: Color(0xff0d1300),
      tertiaryFixedDim: Color(0xffb3d263),
      onTertiaryFixedVariant: Color(0xff2c3b00),
      surfaceDim: Color(0xff11150b),
      surfaceBright: Color(0xff363b2f),
      surfaceContainerLowest: Color(0xff0b0f07),
      surfaceContainerLow: Color(0xff191d13),
      surfaceContainer: Color(0xff1d2117),
      surfaceContainerHigh: Color(0xff272b21),
      surfaceContainerHighest: Color(0xff32362b),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff4ffdf),
      surfaceTint: Color(0xff97d945),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff9bde49),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff4ffe0),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffb7d494),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff6ffd7),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffb8d667),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff11150b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff6fee5),
      outline: Color(0xffc6ceb6),
      outlineVariant: Color(0xffc6ceb6),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4d4),
      inversePrimary: Color(0xff1a3000),
      primaryFixed: Color(0xffb6fb63),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff9bde49),
      onPrimaryFixedVariant: Color(0xff0c1a00),
      secondaryFixed: Color(0xffd3f1ae),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb7d494),
      onSecondaryFixedVariant: Color(0xff0c1a00),
      tertiaryFixed: Color(0xffd3f380),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffb8d667),
      onTertiaryFixedVariant: Color(0xff111900),
      surfaceDim: Color(0xff11150b),
      surfaceBright: Color(0xff363b2f),
      surfaceContainerLowest: Color(0xff0b0f07),
      surfaceContainerLow: Color(0xff191d13),
      surfaceContainer: Color(0xff1d2117),
      surfaceContainerHigh: Color(0xff272b21),
      surfaceContainerHighest: Color(0xff32362b),
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
