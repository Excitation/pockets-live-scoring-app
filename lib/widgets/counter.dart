import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocketslivescoringapp/utils/toast_utils.dart';

/// counter widget to display the count value
class Counter extends StatefulWidget {
  /// The constructor of the class.
  const Counter({
    super.key,
    required this.onValueChanged,
    this.maxCount = 7,
  });

  /// on value change callback
  /// [int] the new value of the counter
  final void Function(int) onValueChanged;

  /// max value for the counter
  final int maxCount;

  @override
  State<Counter> createState() => _CounterState();
}

/// State class for counter
class _CounterState extends State<Counter> {
  int _count = 0;

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
            color: Colors.green,
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
            color: Colors.red,
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
    if (_count == widget.maxCount - 1) {
      _count++;
      ToastUtils.showSuccessToast(context, 'Jitis mula');

      return;
    } else if (_count < 7) {
      setState(() {
        _count++;
      });
      return widget.onValueChanged(_count);
    }
    ToastUtils.showSuccessToast(context, 'Jitis mula');
  }

  /// method to update the count by -1
  void _substractCount() {
    if (_count > 0) {
      setState(() {
        _count--;
      });
      return widget.onValueChanged(_count);
    }
    ToastUtils.showWarningToast(context, 'Yo bhanda kati ghatauxas');
  }
}
