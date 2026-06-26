/// Common interface for filterable and sortable inhabitant entities.
library;

/// Exposes the fields required by [applyInhabitantsFilter].
///
/// Both [Fish] and [Coral] mix in this, allowing the filter and sort
/// logic to be implemented once in a single generic function.
mixin Filterable {
  String get name;
  String get species;
  String? get difficulty;
  DateTime get addedDate;
  double get size;
}
