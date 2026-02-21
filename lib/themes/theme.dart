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
  scaffoldBackgroundColor: Colors.green,

  colorScheme: const ColorScheme.light(
    background: Colors.white,
    onPrimary: Colors.black,
    primary: Color(0xFFdddddd),
    secondary: Color(0xFFaaaaaa),
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
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFaaaaaa),
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
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

  colorScheme: ColorScheme.dark(
    background: const Color(0xFF121212),
    primary: Color(0xFF1F1F1F),
    onPrimary: Colors.white,
    secondary: const Color.fromRGBO(48, 48, 48, 1),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F1F1F),
    elevation: 0,
    centerTitle: true,
  ),

  cardTheme: CardThemeData(
    color: Color.fromARGB(255, 32, 32, 38),
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
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF1F1F1F),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
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
