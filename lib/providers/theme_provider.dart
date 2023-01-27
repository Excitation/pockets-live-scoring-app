import 'package:flutter/material.dart';
import 'package:pocketslivescoringapp/core/shared_prefs.dart';

/// Theme provider
/// This provider is used to manage the theme of the app.
class ThemeProvider extends ChangeNotifier {
  /// The constructor of the class.
  ThemeProvider() {
    _appTheme = AppTheme.dark;
    _sharedPrefs = SharedPrefs();
    _getTheme();
  }
  late SharedPrefs _sharedPrefs;

  /// The current theme of the app.
  AppTheme _appTheme = AppTheme.dark;

  /// The current theme of the app.
  AppTheme get appTheme => _appTheme;

  /// Sets the theme of the app.
  set appTheme(AppTheme appTheme) {
    _appTheme = appTheme;
    notifyListeners();
  }

  /// Gets the theme of the app.
  Future<void> _getTheme() async {
    await _sharedPrefs.getTheme(this);
  }
}

/// The theme of the app.
enum AppTheme {
  /// The dark theme of the app.
  dark,

  /// The light theme of the app.
  light,
}
