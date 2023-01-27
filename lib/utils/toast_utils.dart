import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Toast utils
class ToastUtils {
  /// Shows a success toast with the given [message].
  static void showSuccessToast(BuildContext context, String message) =>
      FToast().init(context).showToast(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.green,
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            gravity: ToastGravity.BOTTOM,
          );

  /// Shows an error toast with the given [message].
  static void showErrorToast(BuildContext context, String message) =>
      FToast().init(context).showToast(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.red,
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            gravity: ToastGravity.BOTTOM,
          );

  /// Shows a warning toast with the given [message].
  static void showWarningToast(BuildContext context, String message) =>
      FToast().init(context).showToast(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.yellow,
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            gravity: ToastGravity.BOTTOM,
          );
}
