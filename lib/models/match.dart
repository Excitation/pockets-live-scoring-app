import 'package:pocketslivescoringapp/models/player.dart';
import 'package:pocketslivescoringapp/models/tournament.dart';

/// The match model.
class MatchInfo {
  /// The constructor of the class.
  MatchInfo({
    required this.id,
    required this.playerOne,
    required this.playerTwo,
    required this.tournament,
    required this.happeningAt,
    required this.matchType,
    required this.status,
  });

  /// Converts the json to a [MatchInfo] object.
  factory MatchInfo.fromJson(Map<String, dynamic> json) => MatchInfo(
        id: json['id'] as int,
        playerOne: Player.fromMap(json['player_one'] as Map<String, dynamic>),
        playerTwo: Player.fromMap(json['player_two'] as Map<String, dynamic>),
        tournament:
            Tournament.fromJson(json['tournament'] as Map<String, dynamic>),
        happeningAt: DateTime.parse(json['happening_at'] as String),
        matchType: json['match_type'] as String,
        status: json['status'] as String,
      );

  /// none match info
  factory MatchInfo.none() => MatchInfo(
        id: -1,
        playerOne: Player.none(),
        playerTwo: Player.none(),
        tournament: Tournament.none(),
        happeningAt: DateTime.now(),
        matchType: '',
        status: '',
      );

  /// id of the match.
  final int id;

  /// player one of the match.
  final Player playerOne;

  /// player two of the match.
  final Player playerTwo;

  /// tournament of the match.
  final Tournament tournament;

  /// happening at of the match.
  final DateTime happeningAt;

  /// match type of the match.
  final String matchType;

  /// status of the match.
  final String status;

  /// get tournament name with the player names
  String get tournamentNameWithPlayers =>
      '${playerOne.firstName} vs ${playerTwo.firstName} - ${tournament.name}';

  @override
  String toString() =>
      // ignore: lines_longer_than_80_chars
      'Match(id: $id, playerOne: $playerOne, playerTwo: $playerTwo, tournament: $tournament, happeningAt: $happeningAt, matchType: $matchType, status: $status)';
}
