import 'package:flutter/material.dart';
import 'package:memetic_whats/themes/theme.dart';

// final ThemeData lightMode = ThemeData(
//   brightness: Brightness.light,
//   colorScheme: ColorScheme.light(primary: Colors.blue, surface: Colors.white,secondary: Colors.red),
// );

// final ThemeData darkMode = ThemeData(
//   brightness: Brightness.dark,
//   colorScheme: ColorScheme.dark(
//     // background: const Color(0xFF121212),
//     primary: Colors.blue,
//     // surface: Colors.grey[900]!,
//     surface: const Color(0xFF121212),
//     secondary: const Color.fromRGBO(48, 48, 48, 1)
//   ),
// );

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  // getter and setter
  ThemeData get myThemeData => _themeData;
  set myThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  bool get isDarkMode => _themeData == darkMode;

  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();
  }
}
