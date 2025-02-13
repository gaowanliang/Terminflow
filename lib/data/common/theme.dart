import 'package:flutter/material.dart';

const appBarTheme = AppBarTheme(centerTitle: false, elevation: 0);

enum ColorSeed {
  baseColor('M3 Baseline', Color(0xff6750a4)),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink);

  const ColorSeed(this.label, this.color);
  final String label;
  final Color color;
}

ThemeData m3DarkThemeData(BuildContext context) {
  return ThemeData(
    colorSchemeSeed: ColorSeed.baseColor.color,
    useMaterial3: true,
    brightness: Brightness.dark,
    // fontFamily: "HarmonySans",
  );
}

ThemeData m3LightThemeData(BuildContext context) {
  return ThemeData(
    colorSchemeSeed: ColorSeed.baseColor.color,
    useMaterial3: true,
    brightness: Brightness.light,
    // fontFamily: "HarmonySans",
  );
}
