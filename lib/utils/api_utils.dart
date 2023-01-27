import 'package:pocketslivescoringapp/utils/constants.dart';

/// Class API Utils with utilities for API calls.

class ApiUtils {
  /// Get the URL for the given [endpoint].
  static Uri getUrl(String endpoint) {
    return Uri.parse(AppConstants.baseUrl + endpoint);
  }
}
