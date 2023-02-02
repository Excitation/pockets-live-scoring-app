import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pocketslivescoringapp/models/match.dart';
import 'package:pocketslivescoringapp/utils/api_utils.dart';
import 'package:pocketslivescoringapp/utils/constants.dart';

/// GameScoreCubit
/// This cubit is used to manage the score of the game, start, end game
class GameScoreCubit extends Cubit<GameScoreState> {
  /// The constructor of the class.
  GameScoreCubit(this._token, this._matchInfo) : super(GameIdle());

  /// Token of the user.
  final String _token;

  /// Match info.
  final MatchInfo _matchInfo;

  /// The player 1 score.
  int player1Score = 0;

  /// The player 2 score.
  int player2Score = 0;

  /// winner id
  int? _winnerId;

  /// Starts the game.
  Future<void> start() async {
    final result = await http.put(
      ApiUtils.getUrl(AppConstants.startMatchEndpoint),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    debugPrint('Result: ${result.body}');
    if (result.statusCode == 200) {
      final data = jsonDecode(result.body) as Map<String, dynamic>;
      debugPrint('Data: $data');
      emit(GameStarted());
    } else {
      emit(GameError('Error starting the game: ${result.body}'));
    }
  }

  /// Update the game.
  Future<void> updateScore(int id, int score, int remainingTime) async {
    final newScore1 = id == 1 ? score : player1Score;
    final newScore2 = id == 2 ? score : player2Score;

    final result = await http.put(
      ApiUtils.getUrl(AppConstants.updateScoreEndpoint),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'player_one_score': newScore1,
        'player_two_score': newScore2,
        'context_data': {
          'game_time': '${remainingTime ~/ 60}:${remainingTime % 60}',
        }
      }),
    );

    debugPrint('Result: ${result.body}');
    if (result.statusCode == 200) {
      final data = jsonDecode(result.body) as Map<String, dynamic>;
      debugPrint('Data: $data');
      player1Score = newScore1;
      player2Score = newScore2;

      if (player1Score == 7 || player2Score == 7) {
        _winnerId = player1Score == 7
            ? _matchInfo.playerOne.id
            : _matchInfo.playerTwo.id;
        emit(GameWon());
      } else {
        emit(GameUpdated());
      }
    } else {
      emit(GameError('Error starting the game: ${result.body}'));
    }
  }

  /// Pauses the game.
  void pause() {
    emit(GamePaused());
  }

  /// Resumes the game.
  void resume() {
    emit(GameUpdated());
  }

  /// Resets the game.
  void reset() {
    player1Score = 0;
    player2Score = 0;
    _winnerId = null;
    emit(GameIdle());
  }

  /// game time out
  void timeOut() {
    _winnerId = player1Score > player2Score
        ? _matchInfo.playerOne.id
        : _matchInfo.playerTwo.id;
    emit(GameWon());
  }

  /// get winner id
  int? get winnerId => _winnerId;
}

/// The states that the timer can be in.
abstract class GameScoreState {}

/// Started state
class GameStarted extends GameScoreState {}

/// Ended state
class GameEnded extends GameScoreState {}

/// Paused state
class GamePaused extends GameScoreState {}

/// Idle state
class GameIdle extends GameScoreState {}

/// Game update state
class GameUpdated extends GameScoreState {}

/// Game won state
class GameWon extends GameScoreState {}

/// Error state
class GameError extends GameScoreState {
  /// The constructor of the class.
  GameError(this.message);

  /// The error message.
  final String message;
}
