import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pocketslivescoringapp/models/match.dart';
import 'package:pocketslivescoringapp/utils/api_utils.dart';
import 'package:pocketslivescoringapp/utils/constants.dart';

/// The tables cubit.
/// This is used to get the tables from the api.
/// This is used in the LoginScreen.

class MatchesCubit extends Cubit<MatchesState> {
  /// The constructor of the class.
  /// The default state is MatchesInitial.
  MatchesCubit() : super(MatchesInitial());

  /// selected match info
  MatchInfo? selectedMatch;

  /// Gets the tables from the api.
  Future<void> getMatches() async {
    emit(MatchesLoading());
    debugPrint('Getting matches');
    try {
      final response =
          await http.get(ApiUtils.getUrl(AppConstants.matchesEndpoint));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final body = data['body'] as List<dynamic>;
        if (body.isEmpty) {
          return emit(MatchesError(message: 'No Matches Available'));
        }
        final matches = body
            .map(
              (dynamic item) =>
                  MatchInfo.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        selectedMatch = matches.first;
        return emit(MatchesLoaded(matches: matches));
      }
      emit(MatchesError(message: response.body));
    } catch (e) {
      emit(MatchesError(message: e.toString()));
    }
  }
}

/// The state of the matches.
abstract class MatchesState {}

/// The initial state of the matches.
class MatchesInitial implements MatchesState {}

/// The loading state of the matches.
class MatchesLoading implements MatchesState {}

/// The error state of the matches.
class MatchesError implements MatchesState {
  /// The constructor of the class.
  MatchesError({this.message});

  /// The error message.
  final String? message;
}

/// The success state of the matches.
class MatchesLoaded implements MatchesState {
  /// The constructor of the class.
  MatchesLoaded({required this.matches});

  /// The list of tables.
  final List<MatchInfo> matches;
}

/// .when extension for the MatchesState.
extension MatchesStateX on MatchesState {
  /// The when function for the MatchesState.
  R when<R>({
    required R Function(MatchesInitial) initial,
    required R Function(MatchesLoading) loading,
    required R Function(MatchesError) error,
    required R Function(MatchesLoaded) loaded,
  }) {
    final s = this;
    if (s is MatchesInitial) {
      return initial(s);
    } else if (s is MatchesLoading) {
      return loading(s);
    } else if (s is MatchesError) {
      return error(s);
    } else if (s is MatchesLoaded) {
      return loaded(s);
    } else {
      throw Exception('Unknown state: $s');
    }
  }
}
