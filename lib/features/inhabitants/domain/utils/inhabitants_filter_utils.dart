/// Generic filter and sort utility for [Filterable] inhabitants.
library;

import 'package:acquariumfe/features/inhabitants/domain/models/filterable.dart';
import 'package:acquariumfe/features/inhabitants/domain/models/inhabitants_filter.dart';

const Map<String, int> _difficultyOrder = {
  'Facile': 1,
  'Intermedio': 2,
  'Difficile': 3,
};

/// Applies [filter] to [items] and returns a new filtered and sorted list.
///
/// Does not mutate the original list.
List<T> applyInhabitantsFilter<T extends Filterable>(
  List<T> items,
  InhabitantsFilter filter,
) {
  List<T> result = items;

  if (filter.searchText.isNotEmpty) {
    final query = filter.searchText.toLowerCase();
    result = result.where((item) {
      return item.name.toLowerCase().contains(query) ||
          item.species.toLowerCase().contains(query);
    }).toList();
  }

  if (filter.difficultyFilter != null) {
    result = result
        .where((item) => item.difficulty == filter.difficultyFilter)
        .toList();
  }

  if (filter.dateFilter != null && filter.dateValue != null) {
    result = result.where((item) {
      return filter.dateFilter == DateFilterType.before
          ? item.addedDate.isBefore(filter.dateValue!)
          : item.addedDate.isAfter(filter.dateValue!);
    }).toList();
  }

  return [...result]..sort((a, b) {
      int comparison;
      switch (filter.sortBy) {
        case SortType.name:
          comparison = a.name.compareTo(b.name);
        case SortType.dateAdded:
          comparison = a.addedDate.compareTo(b.addedDate);
        case SortType.size:
          comparison = a.size.compareTo(b.size);
        case SortType.difficulty:
          final aVal = _difficultyOrder[a.difficulty] ?? 0;
          final bVal = _difficultyOrder[b.difficulty] ?? 0;
          comparison = aVal.compareTo(bVal);
      }
      return filter.sortAscending ? comparison : -comparison;
    });
}
