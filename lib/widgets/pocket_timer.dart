import 'dart:async';

import 'package:flutter/material.dart';

/// PocketTimer is a widget that displays a timer that can be started, paused,
/// and reset.
/// It also has different callbacks for when the timer is started, paused,
/// reset, and when the timer is finished.
///

class PocketTimer extends StatefulWidget {
  /// The constructor of the class.
  const PocketTimer({
    super.key,
    required this.duration,
    this.onStart,
    this.onPause,
    this.onReset,
    this.onFinish,
    this.onResume,
    this.onUpdate,
    required this.controller,
  });

  /// The duration of the timer.
  final Duration duration;

  /// The callback that is called when the timer is started.
  final VoidCallback? onStart;

  /// The callback that is called when the timer is paused.
  final VoidCallback? onPause;

  /// The callback that is called when the timer is reset.
  final VoidCallback? onReset;

  /// The callback that is called when the timer is finished.
  final VoidCallback? onFinish;

  /// The callback that is called when the timer is resumed.
  final VoidCallback? onResume;

  /// The callback that is called when the timer is updated.
  final ValueChanged<Duration>? onUpdate;

  /// The controller of the timer.
  /// The controller is used to start, pause, reset, and resume the timer.
  final TimerController controller;

  @override
  State<PocketTimer> createState() => _PocketTimerState();
}

class _PocketTimerState extends State<PocketTimer> {
  late Duration _duration;
  late Timer _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _duration = widget.duration;
    widget.controller.addListener(_onControllerEvent);
  }

  @override
  void dispose() {
    _timer.cancel();
    widget.controller.removeListener(_onControllerEvent);
    super.dispose();
  }

  void _onControllerEvent() {
    switch (widget.controller.event) {
      case TimerEvent.started:
        start();
        break;
      case TimerEvent.paused:
        pause();
        break;
      case TimerEvent.reset:
        reset();
        break;
      case TimerEvent.resumed:
        resume();
        break;
      case TimerEvent.idling:
        break;
    }
  }

  /// Starts the timer.
  void start() {
    if (_isRunning) {
      return;
    }
    if (_duration.inSeconds == 0) {
      reset();
    }
    setup();
    _isRunning = true;
    widget.onStart?.call();
  }

  /// Pauses the timer.
  void pause() {
    if (!_isRunning) {
      return;
    }
    _isRunning = false;
    _timer.cancel();
    widget.onPause?.call();
  }

  /// Resets the timer.
  void reset() {
    if (_isRunning) {
      _timer.cancel();
    }
    _duration = widget.duration;
    widget.onReset?.call();
    setState(() {});
  }

  /// setup the timer.
  void setup() {
    if (_isRunning) {
      _timer.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds == 0) {
        _timer.cancel();
        widget.onFinish?.call();
        return;
      }
      _duration -= const Duration(seconds: 1);
      widget.onUpdate?.call(_duration);
      setState(() {});
    });
  }

  /// Resumes the timer.
  void resume() {
    if (_isRunning) {
      return;
    }
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds == 0) {
        _timer.cancel();
        widget.onFinish?.call();
        return;
      }
      _duration -= const Duration(seconds: 1);
      widget.onUpdate?.call(_duration);
      setState(() {});
    });
    widget.onResume?.call();
  }

  /// Builds the widget.
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // The minutes.
        Text(
          _duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.displayMedium?.fontSize,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(width: 10),
        // The seconds.
        Text(
          _duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.displayMedium?.fontSize,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }
}

/// the controller of the timer.
class TimerController extends ChangeNotifier {
  /// The constructor of the class.
  TimerController();

  /// This constructor creates a controller for the timer.
  /// The states are TimerState.idle, TimerState.running, and TimerState.paused.
  /// The events are TimerEvent.start, TimerEvent.pause, TimerEvent.reset, and
  /// TimerEvent.resume.

  /// The state of the timer.
  TimerEvent _event = TimerEvent.idling;

  /// Starts the timer.
  void start() {
    _event = TimerEvent.started;
    notifyListeners();
  }

  /// Pauses the timer.
  void pause() {
    _event = TimerEvent.paused;
    notifyListeners();
  }

  /// Resets the timer.
  void reset() {
    _event = TimerEvent.reset;
    notifyListeners();
  }

  /// Resumes the timer.
  void resume() {
    _event = TimerEvent.resumed;
    notifyListeners();
  }

  /// The getter for the state of the timer.
  TimerEvent get event => _event;
}

/// The events that the timer can receive.
enum TimerEvent {
  /// The timer is idle.
  idling,

  /// The timer is started.
  started,

  /// The timer is paused.
  paused,

  /// The timer is reset.
  reset,

  /// The timer is resumed.
  resumed,
}
