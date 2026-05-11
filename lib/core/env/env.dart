/// Compile-time environment variable bindings for the ReefLife app.
///
/// Values are injected at build time from a `.env` file (local development) or
/// from OS-level environment variables / `--dart-define` flags (CI/CD and
/// release builds).  The companion generated file `env.g.dart` is produced by
/// running:
///
/// ```bash
/// flutter pub run build_runner build --delete-conflicting-outputs
/// ```
///
/// **Security note:** Every field annotated with `obfuscate: true` is
/// XOR-obfuscated in the compiled binary, making trivial string-scanning
/// attacks (e.g. `strings` on the APK/IPA) ineffective.  Do **not** commit
/// the `.env` file to version control — use `.env.example` as a template.
library;

import 'package:envied/envied.dart';

part 'env.g.dart';

/// Static container for all compile-time environment variables.
///
/// Access individual variables through their static fields, e.g.:
/// ```dart
/// final host = Env.apiHost;
/// final port = Env.apiPort;
/// ```
@Envied(path: '.env')
abstract class Env {
  /// Hostname (with protocol) of the Spring Boot backend.
  /// Examples: `http://192.168.178.146` (dev), `https://api.reeflife.com` (prod).
  @EnviedField(varName: 'API_HOST', obfuscate: true)
  static final String apiHost = _Env.apiHost;

  /// Port of the Spring Boot backend, e.g. `8080` (dev) or `443` (prod).
  @EnviedField(varName: 'API_PORT', obfuscate: true)
  static final String apiPort = _Env.apiPort;
}
