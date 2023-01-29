import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketslivescoringapp/core/pocket_theme.dart';
import 'package:pocketslivescoringapp/core/shared_prefs.dart';
import 'package:pocketslivescoringapp/providers/theme_provider.dart';
import 'package:pocketslivescoringapp/screens/homepage/home_screen.dart';
import 'package:pocketslivescoringapp/screens/login/login_screen.dart';
import 'package:pocketslivescoringapp/utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(() => runApp(const ProviderScope(child: MyApp())),
      (error, stack) {
    debugPrint('Exception Caught: $error');
  });
}

/// The main app class.
class MyApp extends ConsumerWidget {
  /// The constructor of the class.

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Pocket Live Scoring',
      darkTheme: PocketTheme.darkThemeData,
      theme: PocketTheme.lightThemeData,
      themeMode: theme == AppTheme.dark ? ThemeMode.dark : ThemeMode.light,
      routes: {
        RouteConstants.login: (context) => const LoginScreen(),
        RouteConstants.home: (context) => const HomeScreen(),
      },
      home: FutureBuilder(
        future: SharedPrefs.instance.getLoginState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == AuthState.authenticated) {
              return const HomeScreen();
            }
            return const LoginScreen();
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        },
      ),
    );
  }
}
