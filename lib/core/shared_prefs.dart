import 'package:flutter/foundation.dart';
import 'package:pocketslivescoringapp/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shared preferences class
/// Used to store data in the device
/// The data currently stored is the theme of the app,
/// and the login state of the user.
class SharedPrefs {
  /// The constructor of the class.
  SharedPrefs._() {
    _init();
  }

  /// Initializes the shared preferences.
  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// The shared preferences instance.
  static SharedPreferences? _prefs;

  /// The instance of the class.
  static final SharedPrefs instance = SharedPrefs._();

  /// Sets the [state] of the user in the shared preferences.
  Future<void> setLoginState(AuthState state) async {
    try {
      await _prefs?.setInt(AppConstants.loginStateKey, state.index);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Gets the state of the user from the shared preferences.
  Future<AuthState> getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final loginState = prefs.getInt(AppConstants.loginStateKey);
    if (loginState != null) {
      return AuthState.values[loginState];
    }
    return AuthState.values[0];
  }

  /// Set token in shared preferences.
  Future<void> setToken(String token) async {
    try {
      await _prefs?.setString(AppConstants.tokenKey, token);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Get token from shared preferences.
  Future<String?> getToken() async {
    try {
      return _prefs?.getString(AppConstants.tokenKey);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}

/// The auth state of the user.
enum AuthState {
  /// The user is not logged in.
  authenticated,

  /// The user is logged in.
  unauthenticated,
}
