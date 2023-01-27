import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pocketslivescoringapp/core/pocket_theme.dart';
import 'package:pocketslivescoringapp/providers/login_state_provider.dart';
import 'package:pocketslivescoringapp/providers/theme_provider.dart';
import 'package:pocketslivescoringapp/screens/homepage/home_screen.dart';
import 'package:pocketslivescoringapp/screens/login/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(() => runApp(const MyApp()), (error, stack) {
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginStateProvider>(
          create: (context) => LoginStateProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: Consumer2(
        builder: (
          context,
          LoginStateProvider loginStateProvider,
          ThemeProvider themeProvider,
          child,
        ) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Pockets Live Scoring App',
            theme: themeProvider.appTheme == AppTheme.dark
                ? PocketTheme.darkThemeData
                : PocketTheme.lightThemeData,
            home: loginStateProvider.isLoggedIn
                ? const HomeScreen()
                : const LoginScreen(),
          );
        },
      ),
    );
  }
}
