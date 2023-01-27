import 'package:http/http.dart' as http;
import 'package:pocketslivescoringapp/utils/api_utils.dart';
import 'package:pocketslivescoringapp/utils/constants.dart';

/// A service class that handles all API calls to the backend.
/// This class is a singleton.
class ApiService {
  /// The private constructor.
  ApiService._();

  /// The static instance of the class.
  static final ApiService _instance = ApiService._();

  /// The static method that returns the instance of the class.
  static ApiService get instance => _instance;

  /// Logs in the user with the given [username] and [password].
  Future<bool> login(String username, String password) async {
    try {
      final result =
          await http.get(ApiUtils.getUrl(AppConstants.loginEndpoint));
      return result.statusCode == 200;
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  /// Logs out the user.
  Future<bool> logout() async {
    try {
      final result =
          await http.get(ApiUtils.getUrl(AppConstants.logoutEndpoint));
      return result.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
