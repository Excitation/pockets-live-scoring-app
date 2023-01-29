import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketslivescoringapp/core/shared_prefs.dart';
import 'package:pocketslivescoringapp/network/api_service.dart';

/// auth provider class
/// This provider is used to manage the login state of the user in the app.
/// It has 3 states, loading, error, success, and idle

final loginProvider = StateNotifierProvider<LoginProvider, LoginState>((ref) {
  return LoginProvider();
});

/// Login provider class
/// This class is used to manage the login state of the user in the app.
class LoginProvider extends StateNotifier<LoginState> {
  /// The constructor of the class.
  LoginProvider() : super(const LoginState.idle()) {
    _sharedPrefs = SharedPrefs.instance;
  }

  /// The shared preferences class.
  late SharedPrefs _sharedPrefs;

  /// performs the login action
  /// [email] the email of the user
  /// [password] the password of the user
  Future<void> login(String email, String password) async {
    state = const LoginState.loading();

    try {
      final result = await ApiService.instance.login(email, password);
      if (result) {
        await _sharedPrefs.setLoginState(AuthState.authenticated);
        state = const LoginState.success();
      } else {
        state = const LoginState.error(message: 'Invalid credentials');
      }
    } catch (e) {
      state = LoginState.error(message: e.toString());
    }
  }

  /// performs the logout action
  Future<void> logout() async {
    state = const LoginState.loading();

    try {
      await _sharedPrefs.setLoginState(AuthState.unauthenticated);
      state = const LoginState.success();
    } catch (e) {
      state = LoginState.error(message: e.toString());
    }
  }
}

/// The login state of the user.
abstract class LoginState {
  /// The login state is idle.
  const factory LoginState.idle() = LoginStateIdle;

  /// The login state is loading.
  const factory LoginState.loading() = LoginStateLoading;

  /// The login state is error.
  const factory LoginState.error({String? message}) = LoginStateError;

  /// The login state is success.
  const factory LoginState.success() = LoginStateSuccess;
}

/// The login state is idle.
class LoginStateIdle implements LoginState {
  /// The constructor of the class.
  const LoginStateIdle();
}

/// The login state is loading.
class LoginStateLoading implements LoginState {
  /// The constructor of the class.
  const LoginStateLoading();
}

/// The login state is error.
class LoginStateError implements LoginState {
  /// The constructor of the class.
  const LoginStateError({this.message});

  /// The error message.
  final String? message;
}

/// The login state is success.
class LoginStateSuccess implements LoginState {
  /// The constructor of the class.
  const LoginStateSuccess();
}
