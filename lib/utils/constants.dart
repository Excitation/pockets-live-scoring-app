import 'package:flutter/foundation.dart';

/// A constans class that holds all the constants used in the app.
/// Like API endpoints, colors, Key Strings, etc.
class AppConstants {
  /// The base URL of the API.
  static const String baseUrl = kDebugMode
      ? 'http://localhost:3000'
      : 'https://lionfish-app-y27fn.ondigitalocean.app';

  /// Login endpoint.
  static const String loginEndpoint = '/auth/match/';

  /// Logout endpoint.
  static const String logoutEndpoint = '/logout';

  /// Tables endpoint.
  static const String matchesEndpoint = '/matches/active';

  /// Start match endpoint.
  static const String startMatchEndpoint = '/matches/start';

  /// Update score endpoint.
  static const String updateScoreEndpoint = '/matches/update_score';

  /// End match endpoint.
  static const String endMatchEndpoint = '/matches/end';

  /// The key for the token in the shared preferences.
  static const String tokenKey = 'token';

  /// The key for the login state in the shared preferences.
  static const String loginStateKey = 'loginState';
}

/// Route constants class
class RouteConstants {
  /// The home route.
  static const String home = '/home';

  /// The login route.
  static const String login = '/login';
}
