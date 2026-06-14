# ReefLife

![Flutter](https://img.shields.io/badge/flutter-3.x-blue.svg)
![Dart SDK](https://img.shields.io/badge/dart-%5E3.9.2-blue.svg)
[![CI](https://github.com/F3rren/aquarium-interface/actions/workflows/ci.yml/badge.svg)](https://github.com/F3rren/aquarium-interface/actions/workflows/ci.yml)
![Tests](https://img.shields.io/badge/tests-126%20passing-brightgreen.svg)
![Status](https://img.shields.io/badge/status-active-success.svg)
![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)
![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS-lightgrey.svg)

> **Prerequisite:**  
> This app requires the companion backend [Aquarium Monitor](https://github.com/F3rren/aquarium-monitor) to operate.  
> Without the backend, data persistence, authentication, and most features will not be available.

A cross-platform Flutter app for smart aquarium management. Track water parameters, manage tank inhabitants, schedule maintenance tasks, and keep a full activity history over time.

![Dashboard Demo](./assets/app.gif)
![Inhabitants Management Demo](./assets/inhabitant.gif)

---

## Features

- **Aquarium management** — Create, edit, and delete marine, freshwater, and reef tanks. Default maintenance tasks are automatically initialized based on the tank type.
- **Water parameters** — View temperature, pH, ORP, and salinity with interactive historical charts. Sensor integration (Arduino / Raspberry Pi) in progress.
- **Species database** — Fish and coral catalogue with filtering by water-type compatibility.
- **Maintenance** — Schedule and track recurring tasks (water change, filter cleaning, dosing, etc.) with persistent history and product inventory.
- **Notifications** — Local alerts when critical parameter thresholds are exceeded. User-configurable alert ranges per aquarium.
- **Multilingual** — Fully localized UI in 5 languages: Italian, English, German, Spanish, French. Default tasks are translated automatically based on device locale.
- **Theme** — Light and dark mode, user-selectable and persisted across sessions.
- **Design system** — All colours come from a single source of truth (`AppSemanticColors`, a Material `ThemeExtension`): a status palette (optimal / attention / out-of-range / low) plus per-parameter accents, calibrated separately for light and dark.
- **Health dashboard** — Tank health at a glance with an explicit "to fix" list: every out-of-range parameter is shown with its direction (too high / too low), current value, and healthy range.
- **Comfortable data entry** — Creation forms with live validation, autofocus and a Next → Done keyboard flow; swipeable, animated navigation between the aquarium detail tabs.
---

## Current Status

- Core features fully operational with complete database persistence.
- IoT sensor integration (Arduino + Raspberry Pi) in progress.
- Local notifications active; remote push notifications not yet implemented.

---

## Roadmap

- [ ] Arduino / Raspberry Pi integration for real-time sensor readings
- [ ] User authentication and profile management
- [ ] Remote push notifications for parameter alerts
- [ ] Data export and multi-parameter chart comparisons
- [ ] Cloud backup and cross-device sync
- [ ] Species database expansion (community contributions)
- [x] Feature-first architecture (`core/` + `features/`)
- [x] Dependency injection via Riverpod (`keepAlive` providers, constructor injection)
- [x] Comprehensive test suite (126 tests — unit, provider, widget)
- [x] Multilingual support (IT, EN, DE, ES, FR)
- [x] Default maintenance tasks differentiated by tank type
- [x] Light/dark theme
- [x] Multi-flavor builds (dev / staging / prod)
- [x] Design system: semantic colour tokens calibrated for light/dark, deficiency-focused dashboard, comfortable forms, swipe-based tab navigation
---

## Architecture

### Tech stack

| Layer | Technology |
|---|---|
| UI | Flutter 3.x + Material 3 |
| State management | Riverpod 2 (code-generated, `keepAlive` providers) |
| HTTP client | `package:http` with JWT, retry, and typed exceptions |
| Token storage | `flutter_secure_storage` (Android Keystore / iOS Keychain) |
| Local notifications | `flutter_local_notifications` |
| Charts | `fl_chart` |
| Icons | Font Awesome Flutter |
| Backend | Java (Spring Boot) on AWS |
| API contracts | Hand-written `fromJson` / `toJson` on each domain model |

### Key patterns

| Pattern | Where |
|---|---|
| **Feature-first** | `lib/core/` + `lib/features/<name>/{data,domain,presentation}` |
| **Dependency injection** | All data services wired via Riverpod `keepAlive` providers + constructor injection, sharing a single `ApiService` (one HTTP client + token cache) |
| **Result\<T\>** | `core/utils/result.dart` — `Ok`/`Err` sealed class, `guardResult()` helper |
| **ApiEndpoints** | `core/constants/api_endpoints.dart` — single source of truth for all URLs |
| **Retry policy** | `core/utils/retry_policy.dart` — exponential back-off, configurable per call |
| **Typed exceptions** | `core/utils/exceptions.dart` — `NetworkException`, `AuthException`, etc. |

---

## Project Structure

```
lib/
├── main.dart               # Entry point (delegates to bootstrap())
├── main_dev.dart           # Dev flavor
├── main_staging.dart       # Staging flavor
├── main_prod.dart          # Production flavor
│
├── core/                   # Shared across all features
│   ├── constants/          # ApiEndpoints, AppColors, notification texts
│   ├── env/                # Compile-time config via --dart-define (Env.apiHost/apiPort)
│   ├── l10n/               # ARB files + generated AppLocalizations
│   ├── network/            # ApiService — HTTP client with JWT + retry
│   ├── providers/          # service_providers.dart — Riverpod DI root
│   ├── routing/            # AppRoutes, route names, page transitions
│   ├── utils/              # exceptions, result, retry_policy, localizers
│   └── widgets/            # Shared widgets (SkeletonLoader, EmptyState, …)
│
└── features/
    ├── aquarium/           # Tank CRUD + dashboard
    │   ├── data/           # AquariumsService
    │   ├── domain/models/  # Aquarium
    │   └── presentation/   # providers/, views/
    ├── parameters/         # Water parameter readings + charts
    │   ├── data/           # ParameterService, TargetParametersService, …
    │   ├── domain/models/  # AquariumParameters, AquariumParameter, …
    │   └── presentation/   # providers/, views/, widgets/
    ├── charts/             # Historical data charts
    │   ├── data/           # ChartDataService
    │   └── presentation/   # views/
    ├── maintenance/        # Tasks + product inventory
    │   ├── data/           # MaintenanceTaskService, ProductService
    │   ├── domain/models/  # MaintenanceTask, Product, MaintenanceLog
    │   └── presentation/   # views/, widgets/
    ├── inhabitants/        # Fish + coral management
    │   ├── data/           # InhabitantsService, FishDatabaseService, …
    │   ├── domain/models/  # Fish, Coral, FishSpecies, CoralSpecies, …
    │   └── presentation/   # views/, widgets/
    └── settings/           # Theme, locale, notifications
        ├── data/           # AlertManager, NotificationService, …
        ├── domain/models/  # NotificationSettings
        └── presentation/   # providers/, views/
```

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.9.2`
- Dart SDK `^3.9.2`
- [Aquarium Monitor](https://github.com/F3rren/aquarium-monitor) backend running

### Installation

```bash
git clone https://github.com/F3rren/aquarium-interface.git
cd aquarium-interface
flutter pub get
```

### Environment configuration

The backend URL is injected at **build time** via `--dart-define` (or
`--dart-define-from-file=<file>`), paired with the matching flavor entry point.
There is no runtime `.env`; if you omit the flags the app falls back to the dev
defaults in `core/env/env.dart` (`http://10.0.2.2:8080`, the Android-emulator
loopback). To use a file instead of inline flags, copy the template:

```bash
cp .env.example .env.dev   # edit API_HOST / API_PORT, then pass --dart-define-from-file=.env.dev
```

Run with the values inline (or via the file above):

```bash
# Development — plain HTTP (physical device or emulator)
flutter run \
  --flavor dev \
  --target lib/main_dev.dart \
  --dart-define=API_HOST=http://<IP> \
  --dart-define=API_PORT=<PORT>

# Staging
flutter run \
  --flavor staging \
  --target lib/main_staging.dart \
  --dart-define=API_HOST=https://staging.example.com \
  --dart-define=API_PORT=443

# Production release build
flutter build apk \
  --flavor prod \
  --target lib/main_prod.dart \
  --dart-define=API_HOST=https://api.example.com \
  --dart-define=API_PORT=443
```

> **Android plain HTTP:** For non-HTTPS connections the IP/domain must be listed in  
> `android/app/src/main/res/xml/network_security_config.xml`.

### Run on a physical device

```bash
flutter devices          # list connected devices
flutter run --flavor dev --target lib/main_dev.dart -d <device-id>
```

---

## Testing

The project has **126 tests** covering unit, provider, and widget layers.

```
test/
├── helpers/
│   ├── mocks.dart             # MockApiService + service mocks (mocktail)
│   ├── fixtures.dart          # Reusable domain objects + JSON payloads
│   └── provider_container.dart # makeContainer() with auto-dispose
│
├── core/utils/
│   ├── result_test.dart       # Ok, Err, guardResult, map, fold
│   ├── exceptions_test.dart   # Exception hierarchy + userMessage
│   └── retry_policy_test.dart # Retry behavior, shouldRetry, presets
│
└── features/
    ├── aquarium/
    │   ├── data/              # AquariumsService CRUD + error paths
    │   ├── domain/            # Aquarium fromJson/toJson/copyWith roundtrip
    │   └── presentation/      # aquariumsProvider states, AquariumView UI
    ├── parameters/
    │   ├── data/              # TargetParametersService cache + persistence
    │   ├── domain/            # AquariumParameters fromJson/toJson/toMap
    │   └── presentation/      # Thermometer widget rendering
    └── settings/
        └── presentation/      # AppThemeMode toggle + SharedPreferences
```

### Run the tests

```bash
# Full suite
flutter test

# Single feature
flutter test test/features/aquarium/

# With coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html   # macOS / Linux
```

### Add a new test

Follow the existing pattern: place the test file at the same path as its source file, replacing `lib/` with `test/`. Use `makeContainer()` from `test/helpers/provider_container.dart` for Riverpod tests and `MockApiService` from `test/helpers/mocks.dart` for service tests.

---

## Code generation

Riverpod providers use code generation (`*.g.dart`). Re-run after modifying any `@riverpod` annotation:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for details.
