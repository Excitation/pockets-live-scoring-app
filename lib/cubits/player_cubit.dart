import 'package:flutter_bloc/flutter_bloc.dart';

/// Player cubit class
/// This cubit is used to manage the time of the player
/// The time has states idle, started, ended.
/// The events are start, reset
/// When the player starts the timer, the timer starts
/// When the player resets the timer, the timer resets

class PlayerCubit extends Cubit<PlayerState> {
  /// The constructor of the class.
  PlayerCubit() : super(PlayerState.idle);

  /// Starts the timer.
  void start() {
    emit(PlayerState.started);
  }

  /// Resets the timer.
  void reset() {
    emit(PlayerState.reset);
  }
}

/// The states that the timer can be in.
enum PlayerState {
  /// The timer is idle.
  idle,

  /// The timer is started.
  started,

  /// The timer is reset.
  reset,
}

/// .when extension method for the timer state.
extension PlayerStateX on PlayerState {
  /// The when method for the timer state.
  T when<T>({
    required T Function() idle,
    required T Function() started,
    required T Function() reset,
  }) {
    switch (this) {
      case PlayerState.idle:
        return idle();
      case PlayerState.started:
        return started();
      case PlayerState.reset:
        return reset();
    }
  }
}
