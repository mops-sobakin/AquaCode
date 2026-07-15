import 'package:flutter/material.dart';
import 'app_theme.dart';

enum ThemeType { dark, aqua, white }

class ThemeProvider extends ChangeNotifier {
  ThemeType _currentTheme = ThemeType.dark;

  ThemeType get currentTheme => _currentTheme;

  ThemeData get themeData {
    switch (_currentTheme) {
      case ThemeType.dark:
        return AppTheme.darkTheme();
      case ThemeType.aqua:
        return AppTheme.aquaTheme();
      case ThemeType.white:
        return AppTheme.whiteTheme();
    }
  }

  void setTheme(ThemeType theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}
