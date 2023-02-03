import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pocketslivescoringapp/models/match.dart';
import 'package:pocketslivescoringapp/utils/api_utils.dart';
import 'package:pocketslivescoringapp/utils/constants.dart';

/// Confirm cubit class
class ConfirmCubit extends Cubit<GameConfirm> {
  /// The constructor of the class.
  ConfirmCubit(
    MatchInfo info,
    int score1,
    int score2,
    int winnerId,
    String token, {
    required String time,
  }) : super(
          GameConfirm(
            score1,
            score2,
            info,
            winnerId,
            token: token,
            loading: false,
            time: time,
          ),
        );

  /// confirm player 1
  void confirmPlayer1() {
    emit(state.copyWith(player1Confirmed: true));
  }

  /// confirm player 2
  void confirmPlayer2() {
    emit(state.copyWith(player2Confirmed: true));
  }

  /// end game
  /// Ends the game.
  Future<void> endGame(String time) async {
    final result = await http.put(
      ApiUtils.getUrl(AppConstants.endMatchEndpoint),
      headers: {
        'Authorization': 'Bearer ${state.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'winner_id': state.winnerId,
        'context_data': {
          'game_time': time,
        }
      }),
    );

    debugPrint('Result: ${result.body}');
    if (result.statusCode == 200) {
      final data = jsonDecode(result.body) as Map<String, dynamic>;
      debugPrint('Data: $data');
      emit(state.copyWith(ended: true, loading: false));
    } else {
      emit(state.copyWith(ended: false, loading: false));
    }
  }
}

/// confirm cubit class
class GameConfirm {
  /// The constructor of the class.
  GameConfirm(
    this.score1,
    this.score2,
    this.matchInfo,
    this.winnerId, {
    this.player1Confirmed = false,
    this.player2Confirmed = false,
    this.ended = false,
    required this.token,
    required this.loading,
    required this.time,
  });

  /// time
  final String time;

  /// final score of player 1
  final int score1;

  /// final score of player 2
  final int score2;

  /// winner id
  int winnerId;

  /// MatchInfo
  final MatchInfo matchInfo;

  /// Player1 confirmed
  final bool player1Confirmed;

  /// Player2 confirmed
  final bool player2Confirmed;

  /// Ended
  final bool ended;

  /// The token of the user.
  final String token;

  /// loading
  final bool loading;

  /// copyWith
  GameConfirm copyWith({
    int? score1,
    int? score2,
    MatchInfo? matchInfo,
    bool? player1Confirmed,
    bool? player2Confirmed,
    bool? ended,
    int? winnerId,
    String? token,
    bool? loading,
    String? time,
  }) {
    return GameConfirm(
      time: time ?? this.time,
      score1 ?? this.score1,
      score2 ?? this.score2,
      matchInfo ?? this.matchInfo,
      winnerId ?? this.winnerId,
      player1Confirmed: player1Confirmed ?? this.player1Confirmed,
      player2Confirmed: player2Confirmed ?? this.player2Confirmed,
      ended: ended ?? this.ended,
      token: token ?? this.token,
      loading: loading ?? this.loading,
    );
  }
}
