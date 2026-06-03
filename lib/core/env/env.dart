/// Compile-time backend configuration for the ReefLife app.
///
/// Values are injected at build time with `--dart-define` /
/// `--dart-define-from-file`, paired with the matching flavor entry point:
///
/// ```bash
/// flutter run   --flavor dev     -t lib/main_dev.dart     --dart-define-from-file=.env.dev
/// flutter run   --flavor staging -t lib/main_staging.dart --dart-define-from-file=.env.staging
/// flutter build apk --flavor prod -t lib/main_prod.dart   --dart-define-from-file=.env.prod
/// ```
///
/// The defaults target the Android emulator loopback (`http://10.0.2.2:8080`)
/// so that `flutter analyze`, `flutter test`, and a bare `flutter run` work
/// without any extra flags.
///
/// **Security note:** the API base URL is *not* a secret — it is visible in
/// every TLS handshake and packet capture, and any client-side "obfuscation"
/// of it is trivially reversible (the key ships next to the data). Do not treat
/// build-time injection as a secrecy mechanism. The only real secret — the JWT
/// — lives at runtime in `flutter_secure_storage`, never baked into the binary.
library;

/// Static holder for compile-time environment configuration.
///
/// Access the values through the static fields, e.g.:
/// ```dart
/// final host = Env.apiHost;
/// final port = Env.apiPort;
/// ```
abstract class Env {
  /// Backend host including scheme, e.g. `https://api.reeflife.com`.
  ///
  /// Overridden at build time via `--dart-define=API_HOST=...`.
  static const String apiHost =
      String.fromEnvironment('API_HOST', defaultValue: 'http://10.0.2.2');

  /// Backend port, e.g. `8080` (dev) or `443` (prod).
  ///
  /// Overridden at build time via `--dart-define=API_PORT=...`.
  static const String apiPort =
      String.fromEnvironment('API_PORT', defaultValue: '8080');
}
