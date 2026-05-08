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
/// final baseUrl = Env.apiBaseUrl;
/// ```
@Envied(path: '.env')
abstract class Env {
  /// Base URL of the Spring Boot backend (AWS ALB endpoint or custom domain).
  ///
  /// Annotated with `obfuscate: true` so that the value is XOR-encoded in the
  /// compiled output, reducing the risk of accidental exposure in distributed
  /// binaries.  The generated `_Env.apiBaseUrl` getter performs the decoding
  /// at runtime.
  @EnviedField(varName: 'API_BASE_URL', obfuscate: true)
  static final String apiBaseUrl = _Env.apiBaseUrl;
}
