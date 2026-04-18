abstract final class AuthConfig {
  /// Web OAuth client from Firebase / Google Cloud.
  ///
  /// Keeping this explicit makes Google Sign-In on Android more reliable with
  /// google_sign_in 7.x, and gives us one clear place to update it later.
  static const String googleServerClientId =
      '380167775107-psuoit4rjin8d5fvsruh6jmk8cnsjjh5.apps.googleusercontent.com';
}
