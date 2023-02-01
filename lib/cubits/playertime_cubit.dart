import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Countdown cubit class
class PlayerTimeCubit extends Cubit<int> {
  /// The constructor of the class.
  PlayerTimeCubit() : super(30);

  /// The subscription of the stream.
  StreamSubscription<int>? _subscription;

  /// The remaining time.
  int _remaining = 30;

  /// The duration of the timer.
  final int _duration = 30;

  /// Starts the timer.
  void start() {
    final stream = Stream<int>.periodic(const Duration(seconds: 1), (tick) {
      _remaining = _duration - tick;
      debugPrint('Remaining: $_remaining');
      if (_remaining == 0) {
        reset();
        return 0;
      }
      return _remaining;
    });

    _subscription = stream.listen(emit);
  }

  /// Resets the timer.
  void reset() {
    _subscription?.cancel();
    _subscription = null;
    _remaining = _duration;
    emit(_duration);
  }

  /// check if the timer is active
  bool get isIdle => _subscription == null;

  /// check if the timer is running
  bool get isRunning => _subscription != null;
}
