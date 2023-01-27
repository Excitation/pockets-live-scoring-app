import 'package:flutter/material.dart';

/// Home screen of the app.
/// This is the screen that is shown after the user logs in.
class HomeScreen extends StatefulWidget {
  /// The constructor of the class.
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Text('Home Screen'),
      ),
    );
  }
}
