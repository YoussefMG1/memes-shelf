import 'package:flutter/material.dart';

// ThemeData lightMode = ThemeData(
//   brightness: Brightness.light,
//   colorScheme: ColorScheme.light(
//     background: Colors.grey.shade400,
//     primary: Colors.grey.shade300,
//     secondary: Colors.grey.shade200,
//   ),
// );
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),

  colorScheme: const ColorScheme.light(
    background: Color(0xFFF5F5F5),
    primary: Colors.white,
    secondary: Color(0xFFE0E0E0),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),

  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(18)),
    ),
  ),

  drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),

  listTileTheme: const ListTileThemeData(
    iconColor: Colors.black,
    textColor: Colors.black,
  ),
);

// ThemeData darkMode = ThemeData(
//   brightness: Brightness.dark,
//   colorScheme: ColorScheme.dark(
//     background: Colors.grey.shade900,
//     primary: Colors.grey.shade800,
//     secondary: Colors.grey.shade700,
//   )
// );
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),

  colorScheme: const ColorScheme.dark(
    background: Color(0xFF121212),
    primary: Color(0xFF1F1F1F),
    secondary: Color(0xFF3E3E49),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F1F1F),
    elevation: 0,
    centerTitle: true,
  ),

  cardTheme: CardThemeData(
    color: Color(0xFF3E3E49),
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(18)),
    ),
  ),

  drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF121212)),

  listTileTheme: const ListTileThemeData(
    iconColor: Colors.white,
    textColor: Colors.white,
  ),
);

ThemeData testTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade500),
  textTheme: TextTheme(),
  iconTheme: IconThemeData(size: 26),
);

// default theme
// ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),)
