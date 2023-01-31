import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocketslivescoringapp/core/pocket_theme.dart';
import 'package:pocketslivescoringapp/cubits/sound_cubit.dart';
import 'package:pocketslivescoringapp/cubits/theme_cubit.dart';
import 'package:pocketslivescoringapp/screens/login/login_screen.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(
      () => runApp(
            MultiBlocProvider(
              providers: [
                BlocProvider<ThemeCubit>(
                  create: (_) => ThemeCubit(),
                ),
                BlocProvider<SoundCubit>(
                  create: (_) => SoundCubit(),
                ),
              ],
              child: const MyApp(),
            ),
          ), (error, stack) {
    debugPrint('Exception Caught: $error');
  });
}

/// The main app class.
class MyApp extends StatelessWidget {
  /// The constructor of the class.

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (_, state) {
        return MaterialApp(
          title: 'Pocket Live Scoring',
          darkTheme: PocketTheme.darkThemeData,
          theme: PocketTheme.lightThemeData,
          themeMode: state,
          home: const LoginScreen(),
        );
      },
    );
  }
}
