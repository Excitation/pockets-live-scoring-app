/// A constans class that holds all the constants used in the app.
/// Like API endpoints, colors, Key Strings, etc.
class AppConstants {
  /// The base URL of the API.
  static const String baseUrl = 'http://localhost:3000';

  /// Login endpoint.
  static const String loginEndpoint = '/login';

  /// Logout endpoint.
  static const String logoutEndpoint = '/logout';

  /// Tables endpoint.
  static const String tablesEndpoint = '/tournament/tables';

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
