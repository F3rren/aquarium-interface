import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/inhabitants_filter.dart';

class InhabitantsFilterPanel extends StatefulWidget {
  final InhabitantsFilter currentFilter;
  final Function(InhabitantsFilter) onFilterChanged;
  final VoidCallback onClose;

  const InhabitantsFilterPanel({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
    required this.onClose,
  });

  @override
  State<InhabitantsFilterPanel> createState() => _InhabitantsFilterPanelState();
}

class _InhabitantsFilterPanelState extends State<InhabitantsFilterPanel> {
  late InhabitantsFilter _filter;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter;
    _searchController.text = _filter.searchText;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilter(InhabitantsFilter newFilter) {
    setState(() {
      _filter = newFilter;
    });
    widget.onFilterChanged(newFilter);
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _filter.dateValue ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              surface: theme.colorScheme.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _updateFilter(_filter.copyWith(dateValue: picked));
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.filter,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Filtri e Ricerca',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (_filter.hasActiveFilters)
                  TextButton.icon(
                    onPressed: () {
                      _searchController.clear();
                      _updateFilter(_filter.clearAll());
                    },
                    icon: const FaIcon(FontAwesomeIcons.xmark, size: 14),
                    label: const Text('Cancella tutto'),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                  ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.xmark),
                  onPressed: widget.onClose,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barra di ricerca
                  _buildSectionTitle('Ricerca per nome', theme),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cerca per nome...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: theme.colorScheme.primary,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _updateFilter(_filter.copyWith(searchText: ''));
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      _updateFilter(_filter.copyWith(searchText: value));
                    },
                  ),

                  const SizedBox(height: 24),

                  // Filtro difficoltà
                  _buildSectionTitle('Difficoltà', theme),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterChip(
                        label: 'Facile',
                        selected: _filter.difficultyFilter == 'Facile',
                        onSelected: (selected) {
                          _updateFilter(
                            _filter.copyWith(
                              difficultyFilter: selected ? 'Facile' : null,
                              clearDifficulty: !selected,
                            ),
                          );
                        },
                        theme: theme,
                        color: const Color(0xFF34d399),
                      ),
                      _buildFilterChip(
                        label: 'Intermedio',
                        selected: _filter.difficultyFilter == 'Intermedio',
                        onSelected: (selected) {
                          _updateFilter(
                            _filter.copyWith(
                              difficultyFilter: selected ? 'Intermedio' : null,
                              clearDifficulty: !selected,
                            ),
                          );
                        },
                        theme: theme,
                        color: const Color(0xFFf59e0b),
                      ),
                      _buildFilterChip(
                        label: 'Difficile',
                        selected: _filter.difficultyFilter == 'Difficile',
                        onSelected: (selected) {
                          _updateFilter(
                            _filter.copyWith(
                              difficultyFilter: selected ? 'Difficile' : null,
                              clearDifficulty: !selected,
                            ),
                          );
                        },
                        theme: theme,
                        color: const Color(0xFFef4444),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Filtro data inserimento
                  _buildSectionTitle('Data inserimento in vasca', theme),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<DateFilterType>(
                          value: _filter.dateFilter,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          hint: Text(
                            'Seleziona tipo',
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          items: DateFilterType.values.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type.label),
                            );
                          }).toList(),
                          onChanged: (value) {
                            _updateFilter(
                              _filter.copyWith(
                                dateFilter: value,
                                clearDate: value == null,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: _filter.dateFilter != null
                              ? () => _selectDate(context)
                              : null,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: _filter.dateFilter != null
                                  ? theme.colorScheme.surfaceContainerHighest
                                        .withValues(alpha: 0.3)
                                  : theme.colorScheme.surfaceContainerHighest
                                        .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.calendar,
                                  size: 16,
                                  color: _filter.dateFilter != null
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant
                                            .withValues(alpha: 0.5),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _filter.dateValue != null
                                        ? _formatDate(_filter.dateValue!)
                                        : 'Seleziona data',
                                    style: TextStyle(
                                      color: _filter.dateFilter != null
                                          ? theme.colorScheme.onSurface
                                          : theme.colorScheme.onSurfaceVariant
                                                .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_filter.dateFilter != null && _filter.dateValue != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextButton.icon(
                        onPressed: () {
                          _updateFilter(_filter.copyWith(clearDate: true));
                        },
                        icon: const FaIcon(FontAwesomeIcons.xmark, size: 12),
                        label: const Text('Rimuovi filtro data'),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.error,
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Ordinamento
                  _buildSectionTitle('Ordinamento', theme),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ...SortType.values.map((type) {
                          final isLast = type == SortType.values.last;
                          return Column(
                            children: [
                              RadioListTile<SortType>(
                                title: Text(type.label),
                                value: type,
                                groupValue: _filter.sortBy,
                                onChanged: (value) {
                                  if (value != null) {
                                    _updateFilter(
                                      _filter.copyWith(sortBy: value),
                                    );
                                  }
                                },
                                activeColor: theme.colorScheme.primary,
                              ),
                              if (!isLast)
                                Divider(
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  color: theme.dividerColor.withValues(
                                    alpha: 0.1,
                                  ),
                                ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Direzione ordinamento
                  SwitchListTile(
                    title: Text(
                      'Ordine crescente',
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    subtitle: Text(
                      _filter.sortAscending ? 'A → Z / 0 → 9' : 'Z → A / 9 → 0',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    value: _filter.sortAscending,
                    onChanged: (value) {
                      _updateFilter(_filter.copyWith(sortAscending: value));
                    },
                    activeColor: theme.colorScheme.primary,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),

                  SizedBox(height: 16 + bottomPadding),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required Function(bool) onSelected,
    required ThemeData theme,
    required Color color,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: color.withValues(alpha: 0.2),
      checkmarkColor: color,
      labelStyle: TextStyle(
        color: selected ? color : theme.colorScheme.onSurfaceVariant,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: selected ? color : theme.dividerColor.withValues(alpha: 0.2),
        width: selected ? 2 : 1,
      ),
      backgroundColor: theme.colorScheme.surface,
    );
  }
}
