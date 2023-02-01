import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

/// gametime cubit class
class GameTimeCubit extends Cubit<int> {
  /// The constructor of the class.
  GameTimeCubit() : super(60);
  Timer? _timer;
  int _remaining = 60;
  final int _duration = 60;

  /// Starts the timer.
  Future<void> start() async {
    if (_remaining == 0) return;
    _timer ??= createTimer();
  }

  /// Pauses the timer.
  void pause() {
    _timer?.cancel();
    _timer = null;
    emit(_remaining);
  }

  /// Resumes the timer.
  void resume() {
    if (_remaining == 0) return;
    _timer ??= createTimer();
  }

  /// Resets the timer.
  void reset() {
    _timer?.cancel();
    _timer = null;
    _remaining = _duration;
    emit(_remaining);
  }

  /// Creates the timer.
  Timer createTimer() {
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      _remaining = _duration - timer.tick;
      if (_remaining == 0) {
        _timer?.cancel();
        return emit(_remaining);
      }
      emit(_remaining);
    });
  }

  /// check if the timer is idle
  bool get isIdle => _timer == null;

  /// check if the timer is running
  bool get isRunning => _timer?.isActive ?? false;

  /// check if the timer is not started
  bool get isNotStarted => _remaining == _duration;
}
