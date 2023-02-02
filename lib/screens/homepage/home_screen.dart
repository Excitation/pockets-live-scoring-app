import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pocketslivescoringapp/cubits/confirm_cubit.dart';
import 'package:pocketslivescoringapp/cubits/gametime_cubit.dart';
import 'package:pocketslivescoringapp/cubits/playertime_cubit.dart';
import 'package:pocketslivescoringapp/cubits/score_cubit.dart';
import 'package:pocketslivescoringapp/cubits/sound_cubit.dart';
import 'package:pocketslivescoringapp/cubits/theme_cubit.dart';
import 'package:pocketslivescoringapp/models/match.dart';
import 'package:pocketslivescoringapp/models/player.dart';
import 'package:pocketslivescoringapp/screens/login/login_screen.dart';
import 'package:pocketslivescoringapp/utils/toast_utils.dart';
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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _tickPlayer = AudioPlayer()
    ..setLoopMode(LoopMode.all)
    ..setAsset('assets/sounds/tick.mp3');

  /// gameTimeBloc
  final _gameTimeCubit = GameTimeCubit();

  /// playerTimeBloc
  final _playerTimeCubit = PlayerTimeCubit();

  /// game score bloc
  late GameScoreCubit _gameScoreCubit;

  @override
  void initState() {
    super.initState();
    _gameScoreCubit = GameScoreCubit(widget.token, widget.matchInfo);
  }

  /// Disposes the audio players.
  /// This is called when the widget is disposed.
  @override
  void dispose() {
    _tickPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GameTimeCubit>(
          create: (_) => _gameTimeCubit,
        ),
        BlocProvider<PlayerTimeCubit>(
          create: (_) => _playerTimeCubit,
        ),
        BlocProvider<GameScoreCubit>(
          create: (_) => _gameScoreCubit,
        ),
      ],
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
                flex: 6,
                child: _buildGameHeader(),
              ),
              Expanded(
                flex: 5,
                child: _buildPlayerControls(),
              ),
              Expanded(
                flex: 5,
                child: _buildTimer(),
              ),
              Expanded(
                flex: 2,
                child: _buildFooter(),
              ),
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
              onPressed: () {
                if (state is GameWon) {
                  return _handleGameEnd();
                }
                ToastUtils.showWarningToast(context, 'Game not over yet!');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: state is GameWon
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.1),
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

  Future<void> _navigateToLoginScreen(BuildContext context) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
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
                disabled: state is GameEnded ||
                    state is GameIdle ||
                    state is GamePaused,
                onValueChanged: (value) {
                  _gameScoreCubit.updateScore(id, value, _gameTimeCubit.state);
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
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ACT QUICK',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
            ),
          ),
          BlocConsumer<PlayerTimeCubit, int>(
            listener: (context, state) {
              final isSoundEnabled = BlocProvider.of<SoundCubit>(context).state;
              if (_playerTimeCubit.isIdle) {
                if (_tickPlayer.playing) _tickPlayer.stop();
                return;
              }

              if (state == 0) {
                if (_tickPlayer.playing) _tickPlayer.stop();
                return _playerTimeCubit.reset();
              }

              if (!isSoundEnabled) {
                if (_tickPlayer.playing) _tickPlayer.stop();
              }

              if (state < 10 && state > 5) {
                _tickPlayer.setSpeed(1.5);
              } else if (state <= 5 && state > 0) {
                _tickPlayer.setSpeed(2);
              } else {
                _tickPlayer.setSpeed(1);
              }

              if (!_tickPlayer.playing) _tickPlayer.play();
            },
            builder: (context, state) {
              debugPrint('Seconds: $state');
              return Text(
                state.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_tickPlayer.playing) _tickPlayer.stop();
                  _playerTimeCubit.reset();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  'Reset',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize:
                        Theme.of(context).textTheme.headlineSmall?.fontSize,
                  ),
                ),
              ),
              const SizedBox(width: 64),
              ElevatedButton(
                onPressed: () {
                  if (_gameScoreCubit.state is GameUpdated ||
                      _gameScoreCubit.state is GameStarted) {
                    _playerTimeCubit.start();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  'Start',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize:
                        Theme.of(context).textTheme.headlineSmall?.fontSize,
                  ),
                ),
              ),
            ],
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
        const SizedBox(height: 10),
        BlocConsumer<GameTimeCubit, int>(
          listener: (context, state) {
            if (state == 0) {
              _gameScoreCubit.timeOut();
              _gameTimeCubit.reset();
            }
          },
          builder: (context, state) {
            final minutes = (state / 60).floor();
            final seconds = state % 60;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  minutes.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.displayLarge?.fontSize,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.displayMedium?.fontSize,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  seconds.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.displayLarge?.fontSize,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<GameScoreCubit, GameScoreState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    if (state is GameEnded || state is GameWon) return;

                    if (state is GameStarted || state is GameUpdated) {
                      _gameScoreCubit.pause();
                      _gameTimeCubit.pause();
                    }

                    if (state is GameIdle) {
                      _gameScoreCubit.start();
                      _gameTimeCubit.start();
                    }

                    if (state is GamePaused) {
                      _gameScoreCubit.resume();
                      _gameTimeCubit.resume();
                    }
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
                _gameTimeCubit.reset();
                _playerTimeCubit.reset();
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
            time: _gameTimeCubit.state,
          ),
          child: const ConfirmWidget(),
        );
      },
    ).then((value) {
      // ignore: use_if_null_to_convert_nulls_to_bools
      if (value == true) {
        _navigateToLoginScreen(context);
      }
    });
  }
}
