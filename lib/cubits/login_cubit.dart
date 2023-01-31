import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pocketslivescoringapp/utils/api_utils.dart';
import 'package:pocketslivescoringapp/utils/constants.dart';

/// The login cubit.
class LoginCubit extends Cubit<LoginState> {
  /// The constructor of the class.
  LoginCubit() : super(const LoginState.idle());

  /// Logs in the user.
  Future<void> login({
    required String matchId,
    required String passcode,
  }) async {
    try {
      emit(const LoginState.loading());
      if (matchId == '-1') {
        emit(const LoginState.error(message: 'Invalid match id'));
        return;
      }

      final result = await http.post(
        ApiUtils.getUrl(AppConstants.loginEndpoint + matchId),
        body: {'passcode': passcode},
      );

      debugPrint('Result: ${result.body}');
      if (result.statusCode == 200) {
        final data = jsonDecode(result.body) as Map<String, dynamic>;
        debugPrint('Data: $data');
        final token = (data['body'] as Map<String, dynamic>)['token'] as String;
        emit(LoginState.success(token: token));
        return;
      }

      if (result.statusCode != 200) {
        emit(LoginState.error(message: result.body));
        return;
      }
    } catch (e) {
      debugPrint('Error: $e');
      emit(LoginState.error(message: e.toString()));
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
  const factory LoginState.success({required String token}) = LoginStateSuccess;
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
  const LoginStateSuccess({required this.token});

  /// The token of the user.
  final String token;
}
