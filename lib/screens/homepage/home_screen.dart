import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pocketslivescoringapp/cubits/game_cubit.dart';
import 'package:pocketslivescoringapp/cubits/player_cubit.dart';
import 'package:pocketslivescoringapp/cubits/sound_cubit.dart';
import 'package:pocketslivescoringapp/cubits/theme_cubit.dart';
import 'package:pocketslivescoringapp/models/match.dart';
import 'package:pocketslivescoringapp/screens/login/login_screen.dart';
import 'package:pocketslivescoringapp/widgets/counter.dart';
import 'package:pocketslivescoringapp/widgets/pocket_timer.dart';

/// Home screen of the app.
/// This is the screen that is shown after the user logs in.
///

class HomeScreen extends StatefulWidget {
  /// The constructor of the class.
  const HomeScreen({
    super.key,
    required this.token,
    required this.matchInfo,
  });

  /// token of the user.
  final String token;

  /// Matchinfo of the match.
  final MatchInfo matchInfo;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _tickPlayer = AudioPlayer()..setAsset('assets/sounds/tick.mp3');
  final _tickTickPlayer = AudioPlayer()
    ..setAsset('assets/sounds/tick-tick.mp3');
  final _gameTimeController = TimerController();
  final _playerTimeController = TimerController();

  /// Disposes the audio players.
  /// This is called when the widget is disposed.
  @override
  void dispose() {
    _tickPlayer.dispose();
    _tickTickPlayer.dispose();
    _gameTimeController.dispose();
    _playerTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MatchCubit(),
        ),
        BlocProvider(
          create: (context) => PlayerCubit(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            _buildGameHeader(),
            const SizedBox(height: 32),
            Expanded(child: _buildPlayerControls()),
            const SizedBox(height: 64),
            Expanded(child: _buildTimer()),
            const SizedBox(height: 64),
            _buildFooter(context)
          ],
        ),
      ),
    );
  }

  Widget _buildGameHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
      child: Stack(
        children: [
          Align(
            child: _buildGameTimer(context),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: _buildIcons(),
          ),
        ],
      ),
    );
  }

  /// Builds the controls for both players
  Widget _buildPlayerControls() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          children: [
            _buildPlayerControl(context),
            SizedBox(width: MediaQuery.of(context).size.width * 0.1),
            _buildPlayerControl(context),
          ],
        ),
      );

  /// Builds the footer
  /// Takes the constraints
  Widget _buildFooter(BuildContext context) => Container(
        padding: const EdgeInsets.all(32),
        color: Theme.of(context).colorScheme.background,
        child: ElevatedButton(onPressed: () {}, child: const Text('End Game')),
      );

  Widget _buildIcons() => Row(
        children: [
          IconButton(
            onPressed: () {
              BlocProvider.of<SoundCubit>(context).toggleSound();
            },
            icon: BlocBuilder<SoundCubit, bool>(
              builder: (context, state) {
                return Icon(
                  state ? CupertinoIcons.volume_up : CupertinoIcons.volume_off,
                  color: Theme.of(context).colorScheme.onBackground,
                );
              },
            ),
          ),
          IconButton(
            onPressed: () {
              BlocProvider.of<ThemeCubit>(context).toggleTheme();
            },
            icon: Icon(
              CupertinoIcons.brightness,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          IconButton(
            onPressed: () {
              _navigateToLoginScreen(context);
            },
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      );

  Future<void> _navigateToLoginScreen(BuildContext context) {
    return Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, 1);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildPlayerControl(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Counter(
            onValueChanged: (value) => {},
          ),
          const SizedBox(height: 10),
          Text(
            'Kevin Hart',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTimer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ACT QUICK:',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
                ),
              ),
              PocketTimer(
                controller: _playerTimeController,
                duration: const Duration(seconds: 60),
                onUpdate: (value) {
                  if (context.read<SoundCubit>().state == true) {
                    if (_tickPlayer.playing) {
                      _tickPlayer.stop();
                    }
                    if (_tickTickPlayer.playing) {
                      _tickTickPlayer.stop();
                    }
                    return;
                  }

                  if (value > const Duration(seconds: 10)) {
                    _tickPlayer.play();
                  } else {
                    _tickPlayer.stop();
                    _tickTickPlayer.play();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          // start/reset button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'START',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameTimer(BuildContext context) {
    return Column(
      children: [
        Text(
          'Time Remaining',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
          ),
        ),
        const SizedBox(height: 10),
        PocketTimer(
          duration: const Duration(minutes: 60),
          controller: _gameTimeController,
          onFinish: () {
            _handleGameEnd(context);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Consumer(
            //   builder: (context, watch, child) =>
            //       watch(_gameTimeController).event == TimerEvent.paused
            //           ? child!
            //           : const SizedBox.shrink(),
            //   child: ElevatedButton(
            //     onPressed: () => _gameTimeController.event == TimerEvent.paused
            //         ? _gameTimeController.resume()
            //         : _gameTimeController.start(),
            //     child: Text(
            //       'Start',
            //       style: TextStyle(
            //         color: Theme.of(context).colorScheme.onBackground,
            //         fontSize:
            //             Theme.of(context).textTheme.headlineSmall?.fontSize,
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(width: 64),
            ElevatedButton(
              onPressed: _gameTimeController.reset,
              child: Text(
                'Reset',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleGameEnd(BuildContext context) {}
}
