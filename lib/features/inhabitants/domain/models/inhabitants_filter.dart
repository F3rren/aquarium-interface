/// Filter and sort state model for the inhabitants list screen.
library;

/// Immutable filter configuration for the fish and coral inhabitants list.
///
/// Passed to service methods to filter and sort the displayed list.
/// Use [copyWith] to produce a new instance with one or more fields updated;
/// the boolean clear-flags ([clearDifficulty], [clearDate]) allow resetting
/// optional filters to `null` without ambiguity.
class InhabitantsFilter {
  /// Free-text search string matched against name and species fields.
  final String searchText;

  /// Optional difficulty filter value (e.g. `'Facile'`, `'Intermedio'`).
  /// `null` means no difficulty filter is active.
  final String? difficultyFilter;

  /// Determines whether [dateValue] is a "before" or "after" boundary.
  /// `null` means no date filter is active.
  final DateFilterType? dateFilter;

  /// The reference date used with [dateFilter]. Ignored when [dateFilter] is
  /// `null`.
  final DateTime? dateValue;

  /// The field by which the list is currently sorted.
  final SortType sortBy;

  /// Sort direction: `true` for ascending, `false` for descending.
  final bool sortAscending;

  const InhabitantsFilter({
    this.searchText = '',
    this.difficultyFilter,
    this.dateFilter,
    this.dateValue,
    this.sortBy = SortType.name,
    this.sortAscending = true,
  });

  /// Returns a copy with the specified fields replaced.
  ///
  /// Use [clearDifficulty] = `true` to explicitly set [difficultyFilter] to
  /// `null`, and [clearDate] = `true` to reset both [dateFilter] and
  /// [dateValue] to `null`. These flags are necessary because Dart's optional
  /// parameters cannot distinguish "not provided" from "explicitly null".
  InhabitantsFilter copyWith({
    String? searchText,
    String? difficultyFilter,
    DateFilterType? dateFilter,
    DateTime? dateValue,
    SortType? sortBy,
    bool? sortAscending,
    bool clearDifficulty = false,
    bool clearDate = false,
  }) {
    return InhabitantsFilter(
      searchText: searchText ?? this.searchText,
      difficultyFilter: clearDifficulty
          ? null
          : (difficultyFilter ?? this.difficultyFilter),
      dateFilter: clearDate ? null : (dateFilter ?? this.dateFilter),
      dateValue: clearDate ? null : (dateValue ?? this.dateValue),
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  /// Returns `true` when at least one filter criterion is active.
  bool get hasActiveFilters {
    return searchText.isNotEmpty ||
        difficultyFilter != null ||
        (dateFilter != null && dateValue != null);
  }

  /// Returns the number of currently active filter criteria (0–3).
  int get activeFilterCount {
    int count = 0;
    if (searchText.isNotEmpty) count++;
    if (difficultyFilter != null) count++;
    if (dateFilter != null && dateValue != null) count++;
    return count;
  }

  /// Returns a new [InhabitantsFilter] with all criteria cleared, preserving
  /// the current [sortBy] and [sortAscending] settings.
  InhabitantsFilter clearAll() {
    return InhabitantsFilter(sortBy: sortBy, sortAscending: sortAscending);
  }
}

/// Specifies whether a date filter selects items before or after a given date.
enum DateFilterType {
  /// Include items whose date is strictly before [InhabitantsFilter.dateValue].
  before,

  /// Include items whose date is strictly after [InhabitantsFilter.dateValue].
  after,
}

/// Available sort keys for the inhabitants list.
enum SortType {
  /// Sort alphabetically by display name.
  name,

  /// Sort by the date the inhabitant was added to the tank.
  dateAdded,

  /// Sort by size in centimetres.
  size,

  /// Sort by care difficulty level.
  difficulty,
}

/// Adds a human-readable [label] to [DateFilterType].
extension DateFilterTypeExtension on DateFilterType {
  String get label {
    switch (this) {
      case DateFilterType.before:
        return 'Prima di';
      case DateFilterType.after:
        return 'Dopo';
    }
  }
}

/// Adds a human-readable [label] to [SortType].
extension SortTypeExtension on SortType {
  String get label {
    switch (this) {
      case SortType.name:
        return 'Nome';
      case SortType.dateAdded:
        return 'Data inserimento';
      case SortType.size:
        return 'Dimensione';
      case SortType.difficulty:
        return 'Difficoltà';
    }
  }
}
