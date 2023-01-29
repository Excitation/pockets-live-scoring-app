import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Theme provider
/// This provider is used to manage the theme of the app.
final themeProvider = Provider<AppTheme>((ref) {
  return AppTheme.dark;
});

/// The theme of the app.
enum AppTheme {
  /// The dark theme of the app.
  dark,

  /// The light theme of the app.
  light,
}
