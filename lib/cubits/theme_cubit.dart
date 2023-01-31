import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Theme cubit.
class ThemeCubit extends Cubit<ThemeMode> {
  /// The constructor of the class.
  ThemeCubit() : super(ThemeMode.dark);

  /// Toggles the theme of the app.
  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}
