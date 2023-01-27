import 'package:pocketslivescoringapp/providers/login_state_provider.dart';
import 'package:pocketslivescoringapp/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shared preferences class
/// Used to store data in the device
/// The data currently stored is the theme of the app,
/// and the login state of the user.
class SharedPrefs {
  /// The constructor of the class.
  SharedPrefs();

  /// Gets the theme of the app.
  Future<void> setTheme(ThemeProvider themeProvider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme', themeProvider.appTheme.index);
  }

  /// Sets the theme of the app.
  Future<void> getTheme(ThemeProvider themeProvider) async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getInt('theme');
    if (theme != null) {
      themeProvider.appTheme = AppTheme.values[theme];
    }
  }

  /// Sets the login state of the user.
  Future<void> setLoginState(LoginStateProvider loginStateProvider) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('loginState', loginStateProvider.loginState.index);
  }

  /// Gets the login state of the user.
  Future<void> getLoginState(LoginStateProvider loginStateProvider) async {
    final prefs = await SharedPreferences.getInstance();
    final loginState = prefs.getInt('loginState');
    if (loginState != null) {
      loginStateProvider.loginState = LoginState.values[loginState];
    }
  }
}
