/// Centralised API endpoint definitions for the ReefLife backend.
///
/// All path strings live here so that renaming a backend route requires
/// exactly one change. Use static factory methods for parameterised paths.
library;

/// Namespace for every REST endpoint consumed by the app.
abstract final class ApiEndpoints {
  // ── Aquariums ─────────────────────────────────────────────────────────────

  /// `GET /aquariums` — list all aquariums for the authenticated user.
  static const String aquariums = '/aquariums';

  /// `GET /aquariums/{id}` — fetch a single aquarium.
  static String aquarium(int id) => '/aquariums/$id';

  // ── Parameters ────────────────────────────────────────────────────────────

  /// `GET /aquariums/{id}/parameters` — latest sensor snapshot.
  static String parameters(int id) => '/aquariums/$id/parameters';

  /// `GET /aquariums/{id}/parameters/history` — historical readings.
  static String parameterHistory(int id) => '/aquariums/$id/parameters/history';

  /// `POST /parameters` — submit a new parameter reading.
  static const String submitParameters = '/parameters';

  // ── Manual parameters ────────────────────────────────────────────────────

  /// `GET/POST /aquariums/{id}/parameters/manual` — manual readings.
  static String manualParameters(int id) => '/aquariums/$id/parameters/manual';

  // ── Maintenance tasks ────────────────────────────────────────────────────

  /// `GET/POST /aquariums/{id}/tasks` — task list or create.
  static String tasks(int id) => '/aquariums/$id/tasks';

  /// `PUT/DELETE /aquariums/{id}/tasks/{taskId}` — update or remove a task.
  static String task(int aquariumId, String taskId) =>
      '/aquariums/$aquariumId/tasks/$taskId';

  /// `POST /aquariums/{id}/tasks/{taskId}/complete` — mark task complete.
  static String completeTask(int aquariumId, String taskId) =>
      '/aquariums/$aquariumId/tasks/$taskId/complete';

  /// `GET /aquariums/{id}/maintenance` — aggregated maintenance summary.
  static String maintenance(int id) => '/aquariums/$id/maintenance';

  // ── Inhabitants ───────────────────────────────────────────────────────────

  /// `GET/POST /aquariums/{id}/inhabitants` — list or add inhabitants.
  static String inhabitants(int id) => '/aquariums/$id/inhabitants';

  /// `PUT/DELETE /aquariums/{id}/inhabitants/{inhabitantId}`.
  static String inhabitant(int aquariumId, int inhabitantId) =>
      '/aquariums/$aquariumId/inhabitants/$inhabitantId';

  // ── Species database ─────────────────────────────────────────────────────

  /// `GET /species/fishs` — fish species catalogue.
  static const String fishSpecies = '/species/fishs';

  /// `GET /species/corals` — coral species catalogue.
  static const String coralSpecies = '/species/corals';

  // ── Products ─────────────────────────────────────────────────────────────

  /// `GET/POST /products` — product list or create.
  static const String products = '/products';

  /// `GET/PUT/DELETE /products/{id}`.
  static String product(Object id) => '/products/$id';

  /// `PATCH /products/{id}/mark-used`.
  static String markProductUsed(Object id) => '/products/$id/mark-used';

  /// `PATCH /products/{id}/quantity`.
  static String productQuantity(Object id) => '/products/$id/quantity';

  /// `PATCH /products/{id}/toggle-favorite`.
  static String toggleProductFavorite(Object id) =>
      '/products/$id/toggle-favorite';

  // ── Settings ─────────────────────────────────────────────────────────────

  /// `GET/POST /aquariums/{id}/settings/targets` — target parameter values.
  static String targetSettings(int id) => '/aquariums/$id/settings/targets';

  /// `GET/POST /aquariums/{id}/settings/notifications` — notification prefs.
  static String notificationSettings(int id) =>
      '/aquariums/$id/settings/notifications';
}
