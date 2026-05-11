/// Compile-time constants for all named routes in the ReefLife app.
///
/// Use these constants with [Navigator.pushNamed] or [RouteSettings.name]
/// instead of raw strings to avoid typos and ease refactoring.
library;

/// Holds every named route path used across the app.
class RouteNames {
  /// Home screen — list of all registered aquariums.
  static const home = '/';

  /// Aquarium detail screen. Expects an `int?` aquariumId as argument.
  static const details = '/details';

  /// Screen for creating a new aquarium.
  static const addAquarium = '/add_aquarium';

  /// Screen for editing an existing aquarium's properties.
  static const editAquarium = '/edit_aquarium';

  /// Confirmation screen for deleting an aquarium.
  static const deleteAquarium = '/delete_aquarium';

  /// App settings screen (reserved for future use).
  static const settings = '/settings';

  /// Maintenance task list for a specific aquarium.
  /// Expects an `int?` aquariumId as argument.
  static const maintenance = '/maintenance';
}
