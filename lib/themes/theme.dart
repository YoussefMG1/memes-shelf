import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade500,
    primary: Colors.grey.shade400,
    secondary: Colors.grey.shade200,
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade700,
  )
);
ThemeData testTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade500),
  textTheme: TextTheme(),
  iconTheme: IconThemeData(size: 26),
);

// default theme
// ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),)