import 'package:pocketslivescoringapp/main.dart';
import 'package:pocketslivescoringapp/utils/constants.dart';

/// Class API Utils with utilities for API calls.

class ApiUtils {
  /// Get the URL for the given [endpoint].
  static Uri getUrl(String endpoint) {
    return Uri.parse(
      // ignore: use_if_null_to_convert_nulls_to_bools
      (baseUrl == null || baseUrl?.isEmpty == true
              ? AppConstants.baseUrl
              : baseUrl ?? '') +
          endpoint,
    );
  }
}
