import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pocketslivescoringapp/cubits/confirm_cubit.dart';
import 'package:pocketslivescoringapp/cubits/score_cubit.dart';
import 'package:pocketslivescoringapp/cubits/sound_cubit.dart';
import 'package:pocketslivescoringapp/cubits/theme_cubit.dart';
import 'package:pocketslivescoringapp/models/match.dart';
import 'package:pocketslivescoringapp/models/player.dart';
import 'package:pocketslivescoringapp/screens/login/login_screen.dart';
import 'package:pocketslivescoringapp/widgets/confirm_widget.dart';
import 'package:pocketslivescoringapp/widgets/counter.dart';

/// Home screen of the app.
/// This is the screen that is shown after the user logs in.

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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _tickPlayer = AudioPlayer()..setAsset('assets/sounds/beep.mp3');

  /// game score bloc
  late GameScoreCubit _gameScoreCubit;

  /// The controller for the game timer.
  late final CustomTimerController _gameTimecontroller = CustomTimerController(
    vsync: this,
    begin: const Duration(minutes: 60),
    end: Duration.zero,
  );

  /// The controller for the player timer.
  late final CustomTimerController _playerTimecontroller =
      CustomTimerController(
    vsync: this,
    begin: const Duration(seconds: 30),
    end: Duration.zero,
  );

  @override
  void initState() {
    super.initState();
    _gameScoreCubit = GameScoreCubit(widget.token, widget.matchInfo);
    _gameTimecontroller.addListener(_onGameTimeChanged);
    _playerTimecontroller.addListener(_onPlayerTimeChanged);
  }

  /// Disposes the audio players.
  /// This is called when the widget is disposed.
  @override
  void dispose() {
    _tickPlayer.dispose();
    _gameTimecontroller.dispose();
    _playerTimecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameScoreCubit>(
      create: (_) => _gameScoreCubit,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: BlocListener<GameScoreCubit, GameScoreState>(
          listener: (context, state) {
            if (state is GameEnded) {
              _tickPlayer.stop();
              _showWinnerDialog(context);
            }
          },
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: _buildGameHeader(),
              ),
              Expanded(
                flex: 4,
                child: _buildPlayerControls(),
              ),
              Expanded(
                flex: 6,
                child: _buildTimer(),
              ),
              _buildFooter(),
            ],
          ),
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
            _buildPlayerControl(player: widget.matchInfo.playerOne, id: 1),
            SizedBox(width: MediaQuery.of(context).size.width * 0.1),
            _buildPlayerControl(player: widget.matchInfo.playerTwo, id: 2),
          ],
        ),
      );

  /// Builds the footer
  Widget _buildFooter() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: BlocBuilder<GameScoreCubit, GameScoreState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: _handleGameEnd,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'End Match',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
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

  void _navigateToLoginScreen(BuildContext context) {
    /// show confirmation dialog before navigating to login screen
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
              ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleLogout(context);
            },
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  Widget _buildPlayerControl({required Player player, required int id}) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<GameScoreCubit, GameScoreState>(
            builder: (context, state) {
              return Counter(
                disabled: state is GameEnded || state is GameIdle,
                onValueChanged: (value) {
                  _gameScoreCubit.updateScore(
                    id,
                    value,
                    _gameTimecontroller.remaining.value.minutes,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 10),
          Text(
            '${player.firstName} ${player.lastName ?? ''}',
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
      padding: const EdgeInsets.only(top: 12),
      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
      child: Column(
        children: [
          Text(
            'ACT QUICK',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
            ),
          ),
          CustomTimer(
            controller: _playerTimecontroller,
            builder: (state, time) {
              return Text(
                time.seconds.padLeft(2, '0'),
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.2,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              );
            },
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (_gameScoreCubit.state is GameIdle ||
                          _gameScoreCubit.state is GameEnded) {
                        return;
                      }

                      if (_playerTimecontroller.state.value ==
                              CustomTimerState.paused ||
                          _playerTimecontroller.state.value ==
                              CustomTimerState.reset) {
                        _playerTimecontroller.start();
                        _gameTimecontroller.start();
                        return;
                      }

                      _confirmReset(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      color: Theme.of(context).colorScheme.primary,
                      alignment: Alignment.center,
                      child: Text(
                        'RESET/START',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.fontSize,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (_gameScoreCubit.state is GameUpdated ||
                          _gameScoreCubit.state is GameStarted) {
                        if (_playerTimecontroller.state.value ==
                                CustomTimerState.counting &&
                            _gameTimecontroller.remaining.value.duration >
                                Duration.zero) {
                          _playerTimecontroller.pause();
                          _gameTimecontroller.pause();
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      color: Theme.of(context).colorScheme.tertiary,
                      alignment: Alignment.center,
                      child: Text(
                        'PAUSE',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.fontSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
            fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize,
          ),
        ),
        CustomTimer(
          controller: _gameTimecontroller,
          builder: (state, time) {
            return _buildGameTimerWidget(time.minutes, time.seconds);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<GameScoreCubit, GameScoreState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    state.when(
                      idle: () {
                        _gameScoreCubit.start();
                        _gameTimecontroller.start();
                      },
                      started: () {
                        _gameTimecontroller.pause();
                        _gameScoreCubit.pause();
                      },
                      updated: () {
                        _gameTimecontroller.pause();
                        _gameScoreCubit.pause();
                      },
                      paused: () {
                        _gameTimecontroller.start();
                        _gameScoreCubit.resume();
                      },
                      won: () => null,
                      ended: () => null,
                      error: (msg) {
                        _gameScoreCubit.pause();
                        _gameTimecontroller.pause();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(msg),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    state is GameIdle
                        ? 'Start'
                        : state is GamePaused
                            ? 'Resume'
                            : 'Pause',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall?.fontSize,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 64),
            ElevatedButton(
              onPressed: () {
                _gameScoreCubit.reset();
                _gameTimecontroller.reset();
                _playerTimecontroller.reset();
                _tickPlayer.seek(Duration.zero);
              },
              child: Text(
                'Reset',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGameTimerWidget(String minutes, String seconds) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          minutes.padLeft(2, '0'),
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          ':',
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.displayMedium?.fontSize,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          seconds.padLeft(2, '0'),
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  /// Game end logic
  void _handleGameEnd() {
    _showWinnerDialog(context);
  }

  void _showWinnerDialog(BuildContext context) {
    showModalBottomSheet<bool>(
      context: context,
      builder: (ctx) {
        return BlocProvider(
          create: (context) => ConfirmCubit(
            widget.matchInfo,
            _gameScoreCubit.player1Score,
            _gameScoreCubit.player2Score,
            _gameScoreCubit.winnerId ?? 1,
            widget.token,
            time: _gameTimecontroller.remaining.value.minutes,
          ),
          child: const ConfirmWidget(),
        );
      },
    ).then((value) {
      // ignore: use_if_null_to_convert_nulls_to_bools
      if (value == true) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
  }

  void _onPlayerTimeChanged() {
    final remainingSeconds =
        _playerTimecontroller.remaining.value.duration.inSeconds;
    final soundBloc = context.read<SoundCubit>();
    if (remainingSeconds == 0) {
      _playerTimecontroller.reset();
      _tickPlayer.seek(Duration.zero);
      if (_tickPlayer.playing) {
        _tickPlayer.stop();
      }
    } else if (remainingSeconds < 5) {
      if (soundBloc.state) {
        debugPrint('playing');
        _tickPlayer.play();
      } else {
        _tickPlayer.stop();
      }
    }
  }

  void _onGameTimeChanged() {
    final remainingSeconds =
        _gameTimecontroller.remaining.value.duration.inSeconds;
    if (remainingSeconds == 0) {
      _gameScoreCubit.timeOut();
    }
  }

  void _confirmReset(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Reset Timer',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to reset the Timer?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'CANCEL',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            TextButton(
              onPressed: () {
                _tickPlayer.seek(Duration.zero);
                _playerTimecontroller.reset();
                if (_tickPlayer.playing) {
                  _tickPlayer.stop();
                }
                Navigator.of(context).pop();
              },
              child: Text(
                'RESET',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}
