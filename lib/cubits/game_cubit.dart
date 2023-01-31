import 'package:flutter_bloc/flutter_bloc.dart';

/// match cubit class
/// This cubit is used to manage the match state
/// It has states waiting to start, match started
/// and match paused, match resumed, match ended, match reset

class MatchCubit extends Cubit<MatchState> {
  /// The constructor of the class.
  MatchCubit() : super(MatchState.idle);

  /// Starts the match.
  void start() {
    emit(MatchState.started);
  }

  /// Pauses the match.
  void pause() {
    emit(MatchState.paused);
  }

  /// Resumes the match.
  void resume() {
    emit(MatchState.resumed);
  }

  /// Ends the match.
  void end() {
    emit(MatchState.ended);
  }

  /// Resets the match.
  void reset() {
    emit(MatchState.reset);
  }
}

/// The states that the match can be in.
enum MatchState {
  /// The match is idle.
  idle,

  /// The match is started.
  started,

  /// The match is paused.
  paused,

  /// The match is resumed.
  resumed,

  /// The match is ended.
  ended,

  /// The match is reset.
  reset,
}

/// .when extension method for the match state.
extension MatchStateX on MatchState {
  /// The when method for the match state.
  T when<T>({
    required T Function() idle,
    required T Function() started,
    required T Function() paused,
    required T Function() resumed,
    required T Function() ended,
    required T Function() reset,
  }) {
    switch (this) {
      case MatchState.idle:
        return idle();
      case MatchState.started:
        return started();
      case MatchState.paused:
        return paused();
      case MatchState.resumed:
        return resumed();
      case MatchState.ended:
        return ended();
      case MatchState.reset:
        return reset();
    }
  }
}
