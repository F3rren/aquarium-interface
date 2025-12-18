class InhabitantsFilter {
  final String searchText;
  final String? difficultyFilter; // Facile, Intermedio, Difficile
  final DateFilterType? dateFilter; // Prima di, Dopo una data
  final DateTime? dateValue;
  final SortType sortBy;
  final bool sortAscending;

  InhabitantsFilter({
    this.searchText = '',
    this.difficultyFilter,
    this.dateFilter,
    this.dateValue,
    this.sortBy = SortType.name,
    this.sortAscending = true,
  });

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

  bool get hasActiveFilters {
    return searchText.isNotEmpty ||
        difficultyFilter != null ||
        (dateFilter != null && dateValue != null);
  }

  int get activeFilterCount {
    int count = 0;
    if (searchText.isNotEmpty) count++;
    if (difficultyFilter != null) count++;
    if (dateFilter != null && dateValue != null) count++;
    return count;
  }

  InhabitantsFilter clearAll() {
    return InhabitantsFilter(sortBy: sortBy, sortAscending: sortAscending);
  }
}

enum DateFilterType {
  before, // Prima di
  after, // Dopo
}

enum SortType { name, dateAdded, size, difficulty }

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
