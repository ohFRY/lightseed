import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff904a41),
      surfaceTint: Color(0xff904a41),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffdad5),
      onPrimaryContainer: Color(0xff3b0906),
      secondary: Color(0xff775652),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffdad5),
      onSecondaryContainer: Color(0xff2c1512),
      tertiary: Color(0xff406835),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffc1efaf),
      onTertiaryContainer: Color(0xff012200),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff231918),
      onSurfaceVariant: Color(0xff534341),
      outline: Color(0xff857370),
      outlineVariant: Color(0xffd8c2be),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff392e2c),
      onInverseSurface: Color(0xffffedea),
      inversePrimary: Color(0xffffb4a9),
      primaryFixed: Color(0xffffdad5),
      onPrimaryFixed: Color(0xff3b0906),
      primaryFixedDim: Color(0xffffb4a9),
      onPrimaryFixedVariant: Color(0xff73342c),
      secondaryFixed: Color(0xffffdad5),
      onSecondaryFixed: Color(0xff2c1512),
      secondaryFixedDim: Color(0xffe7bdb7),
      onSecondaryFixedVariant: Color(0xff5d3f3b),
      tertiaryFixed: Color(0xffc1efaf),
      onTertiaryFixed: Color(0xff012200),
      tertiaryFixedDim: Color(0xffa6d395),
      onTertiaryFixedVariant: Color(0xff294f20),
      surfaceDim: Color(0xffe8d6d3),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ee),
      surfaceContainer: Color(0xfffceae7),
      surfaceContainerHigh: Color(0xfff7e4e1),
      surfaceContainerHighest: Color(0xfff1dedc),
    );
  }

  ThemeData light() {
    return theme(lightScheme()).copyWith(
      pageTransitionsTheme: pageTransitionsTheme, 
    );
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff6e3028),
      surfaceTint: Color(0xff904a41),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffaa6056),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff593b37),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff8f6c67),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff254b1c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff567f49),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff231918),
      onSurfaceVariant: Color(0xff4f3f3d),
      outline: Color(0xff6c5b59),
      outlineVariant: Color(0xff897674),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff392e2c),
      onInverseSurface: Color(0xffffedea),
      inversePrimary: Color(0xffffb4a9),
      primaryFixed: Color(0xffaa6056),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff8d483f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff8f6c67),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff74544f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff567f49),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff3e6533),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe8d6d3),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ee),
      surfaceContainer: Color(0xfffceae7),
      surfaceContainerHigh: Color(0xfff7e4e1),
      surfaceContainerHighest: Color(0xfff1dedc),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff44100b),
      surfaceTint: Color(0xff904a41),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff6e3028),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff341c18),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff593b37),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff022900),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff254b1c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff2e211f),
      outline: Color(0xff4f3f3d),
      outlineVariant: Color(0xff4f3f3d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff392e2c),
      onInverseSurface: Color(0xffffffff),
      inversePrimary: Color(0xffffe7e3),
      primaryFixed: Color(0xff6e3028),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff521a14),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff593b37),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff402622),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff254b1c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff0e3407),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe8d6d3),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ee),
      surfaceContainer: Color(0xfffceae7),
      surfaceContainerHigh: Color(0xfff7e4e1),
      surfaceContainerHighest: Color(0xfff1dedc),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb4a9),
      surfaceTint: Color(0xffffb4a9),
      onPrimary: Color(0xff561e18),
      primaryContainer: Color(0xff73342c),
      onPrimaryContainer: Color(0xffffdad5),
      secondary: Color(0xffe7bdb7),
      onSecondary: Color(0xff442926),
      secondaryContainer: Color(0xff5d3f3b),
      onSecondaryContainer: Color(0xffffdad5),
      tertiary: Color(0xffa6d395),
      onTertiary: Color(0xff12380b),
      tertiaryContainer: Color(0xff294f20),
      onTertiaryContainer: Color(0xffc1efaf),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1a1110),
      onSurface: Color(0xfff1dedc),
      onSurfaceVariant: Color(0xffd8c2be),
      outline: Color(0xffa08c89),
      outlineVariant: Color(0xff534341),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff1dedc),
      onInverseSurface: Color(0xff392e2c),
      inversePrimary: Color(0xff904a41),
      primaryFixed: Color(0xffffdad5),
      onPrimaryFixed: Color(0xff3b0906),
      primaryFixedDim: Color(0xffffb4a9),
      onPrimaryFixedVariant: Color(0xff73342c),
      secondaryFixed: Color(0xffffdad5),
      onSecondaryFixed: Color(0xff2c1512),
      secondaryFixedDim: Color(0xffe7bdb7),
      onSecondaryFixedVariant: Color(0xff5d3f3b),
      tertiaryFixed: Color(0xffc1efaf),
      onTertiaryFixed: Color(0xff012200),
      tertiaryFixedDim: Color(0xffa6d395),
      onTertiaryFixedVariant: Color(0xff294f20),
      surfaceDim: Color(0xff1a1110),
      surfaceBright: Color(0xff423735),
      surfaceContainerLowest: Color(0xff140c0b),
      surfaceContainerLow: Color(0xff231918),
      surfaceContainer: Color(0xff271d1c),
      surfaceContainerHigh: Color(0xff322826),
      surfaceContainerHighest: Color(0xff3d3231),
    );
  }

  ThemeData dark() {
    return theme(darkScheme()).copyWith(
      pageTransitionsTheme: pageTransitionsTheme, 
    );
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffbab0),
      surfaceTint: Color(0xffffb4a9),
      onPrimary: Color(0xff330503),
      primaryContainer: Color(0xffcc7b70),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffebc1bb),
      onSecondary: Color(0xff26100d),
      secondaryContainer: Color(0xffae8882),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffaad799),
      onTertiary: Color(0xff011c00),
      tertiaryContainer: Color(0xff719c63),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1a1110),
      onSurface: Color(0xfffff9f8),
      onSurfaceVariant: Color(0xffdcc6c2),
      outline: Color(0xffb39e9b),
      outlineVariant: Color(0xff927f7c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff1dedc),
      onInverseSurface: Color(0xff322826),
      inversePrimary: Color(0xff74352d),
      primaryFixed: Color(0xffffdad5),
      onPrimaryFixed: Color(0xff2c0101),
      primaryFixedDim: Color(0xffffb4a9),
      onPrimaryFixedVariant: Color(0xff5e241d),
      secondaryFixed: Color(0xffffdad5),
      onSecondaryFixed: Color(0xff200b08),
      secondaryFixedDim: Color(0xffe7bdb7),
      onSecondaryFixedVariant: Color(0xff4b2f2b),
      tertiaryFixed: Color(0xffc1efaf),
      onTertiaryFixed: Color(0xff011600),
      tertiaryFixedDim: Color(0xffa6d395),
      onTertiaryFixedVariant: Color(0xff183e10),
      surfaceDim: Color(0xff1a1110),
      surfaceBright: Color(0xff423735),
      surfaceContainerLowest: Color(0xff140c0b),
      surfaceContainerLow: Color(0xff231918),
      surfaceContainer: Color(0xff271d1c),
      surfaceContainerHigh: Color(0xff322826),
      surfaceContainerHighest: Color(0xff3d3231),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff9f8),
      surfaceTint: Color(0xffffb4a9),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffbab0),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffff9f8),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffebc1bb),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff2ffe7),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffaad799),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1a1110),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffff9f8),
      outline: Color(0xffdcc6c2),
      outlineVariant: Color(0xffdcc6c2),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff1dedc),
      onInverseSurface: Color(0xff000000),
      inversePrimary: Color(0xff4e1812),
      primaryFixed: Color(0xffffe0db),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffbab0),
      onPrimaryFixedVariant: Color(0xff330503),
      secondaryFixed: Color(0xffffe0db),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffebc1bb),
      onSecondaryFixedVariant: Color(0xff26100d),
      tertiaryFixed: Color(0xffc5f4b3),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffaad799),
      onTertiaryFixedVariant: Color(0xff011c00),
      surfaceDim: Color(0xff1a1110),
      surfaceBright: Color(0xff423735),
      surfaceContainerLowest: Color(0xff140c0b),
      surfaceContainerLow: Color(0xff231918),
      surfaceContainer: Color(0xff271d1c),
      surfaceContainerHigh: Color(0xff322826),
      surfaceContainerHighest: Color(0xff3d3231),
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

// Class for no animation page transitions on desktop apps
class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

// Theme for page transitions
final pageTransitionsTheme = const PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.linux: NoAnimationPageTransitionsBuilder(),
    TargetPlatform.macOS: NoAnimationPageTransitionsBuilder(),
    TargetPlatform.windows: NoAnimationPageTransitionsBuilder(),
  },
);