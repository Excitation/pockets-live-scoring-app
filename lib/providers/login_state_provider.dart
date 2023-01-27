import 'package:flutter/material.dart';
import 'package:pocketslivescoringapp/core/shared_prefs.dart';

/// Login state provider
/// This provider is used to manage the login state of the user in the app.
class LoginStateProvider extends ChangeNotifier {
  /// The constructor of the class.
  LoginStateProvider() {
    _sharedPrefs = SharedPrefs();
    _getLoginState();
  }

  /// The shared preferences class.
  late SharedPrefs _sharedPrefs;

  /// The current login state of the user.
  LoginState _loginState = LoginState.loggedOut;

  /// The current login state of the user.
  LoginState get loginState => _loginState;

  /// Sets the login state of the user.
  set loginState(LoginState loginState) {
    _loginState = loginState;
    notifyListeners();
  }

  /// Sets the login state of the user asynchroniously.
  Future<void> setLoginState(LoginState loginState) async {
    _loginState = loginState;
    await _sharedPrefs.setLoginState(this);
    notifyListeners();
  }

  /// Checks if the user is logged in or not.
  bool get isLoggedIn => _loginState == LoginState.loggedIn;

  /// Gets the login state of the user.
  Future<void> _getLoginState() async {
    await _sharedPrefs.getLoginState(this);
  }
}

/// The login state of the user.
enum LoginState {
  /// The user is logged out.
  loggedOut,

  /// The user is logged in.
  loggedIn,
}
