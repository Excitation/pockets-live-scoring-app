import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// counter widget to display the count value
class Counter extends StatefulWidget {
  /// The constructor of the class.
  const Counter({
    super.key,
    required this.onValueChanged,
    this.maxCount = 7,
    this.disabled = false,
    this.initialValue = 0,
  });

  /// on value change callback
  /// [int] the new value of the counter
  final void Function(int) onValueChanged;

  /// max value for the counter
  final int maxCount;

  /// if the counter is disabled
  final bool disabled;

  /// initial value for the counter
  final int initialValue;

  @override
  State<Counter> createState() => _CounterState();
}

/// State class for counter
class _CounterState extends State<Counter> {
  late int _count = 0;
  bool _isDisabled = false;

  @override
  void initState() {
    super.initState();
    _isDisabled = widget.disabled;
    _count = widget.initialValue;
  }

  @override
  void didUpdateWidget(Counter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.disabled != widget.disabled) {
      _isDisabled = widget.disabled;
    }

    if (oldWidget.initialValue != widget.initialValue) {
      _count = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMinusButton(),
        _buildCountText(),
        _buildPlusButton(),
      ],
    );
  }

  /// builds the counter plus button
  Widget _buildPlusButton() => GestureDetector(
        onTap: _addCount,
        child: Container(
          width: 70,
          height: 70,
          margin: const EdgeInsets.only(left: 32),
          decoration: BoxDecoration(
            color: _isDisabled ? Colors.grey : Colors.green,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            CupertinoIcons.add,
            size: 35,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      );

  /// builds the counter minus button
  Widget _buildMinusButton() => GestureDetector(
        onTap: _substractCount,
        child: Container(
          width: 70,
          height: 70,
          margin: const EdgeInsets.only(right: 32),
          decoration: BoxDecoration(
            color: _isDisabled ? Colors.grey : Colors.red,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            CupertinoIcons.minus,
            size: 35,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      );

  /// builds the counter text
  Widget _buildCountText() => SizedBox(
        width: MediaQuery.of(context).size.width * 0.16,
        height: MediaQuery.of(context).size.height * 0.16,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Text(
            '0$_count',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
      );

  /// method to update the count by 1
  void _addCount() {
    if (_isDisabled) {
      return;
    }
    if (_count < 7) {
      setState(() {
        _count++;
      });
      return widget.onValueChanged(_count);
    }
  }

  /// method to update the count by -1
  void _substractCount() {
    if (_isDisabled) {
      return;
    }
    if (_count > 0) {
      setState(() {
        _count--;
      });
      return widget.onValueChanged(_count);
    }
  }
}
