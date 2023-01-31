import 'package:flutter/material.dart';

/// A button that shows a loading indicator when pressed.
class LoadingButton extends StatelessWidget {
  /// The constructor of the class.
  const LoadingButton({
    super.key,
    required this.child,
    required this.state,
    required this.onPressed,
  });

  /// The child of the button.
  final Widget child;

  /// The loading state of the button.
  final LoadingButtonState state;

  /// The callback function when the button is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: state == LoadingButtonState.loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (state == LoadingButtonState.loading)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          else
            child,
        ],
      ),
    );
  }
}

/// The state of the loading button.
enum LoadingButtonState {
  /// The button is idle.
  idle,

  /// The button is loading.
  loading,

  /// The button is done loading.
  done,
}
