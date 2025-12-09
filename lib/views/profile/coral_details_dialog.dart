import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/coral.dart';

class CoralDetailsDialog extends StatelessWidget {
  final Coral coral;

  const CoralDetailsDialog({super.key, required this.coral});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color typeColor;
    switch (coral.type) {
      case 'SPS':
        typeColor = Colors.pink;
        break;
      case 'LPS':
        typeColor = theme.colorScheme.primary;
        break;
      default:
        typeColor = theme.colorScheme.secondary;
    }

    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header con Hero animation
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [typeColor, typeColor.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coral.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            coral.type,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.xmark,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Contenuto
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome scientifico con bordo colorato
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF34d399).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF34d399).withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF34d399,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.dna,
                              color: Color(0xFF34d399),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nome Scientifico',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  coral.species,
                                  style: const TextStyle(
                                    color: Color(0xFF34d399),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Descrizione (se presente)
                    if (coral.description != null &&
                        coral.description!.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF60a5fa,
                                ).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.circleInfo,
                                color: Color(0xFF60a5fa),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Descrizione',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    coral.description!,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                      fontSize: 12,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Griglia caratteristiche principali
                    if (coral.difficulty != null ||
                        coral.lightRequirement != null ||
                        coral.flowRequirement != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              typeColor.withValues(alpha: 0.1),
                              typeColor.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: typeColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: typeColor.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: FaIcon(
                                    FontAwesomeIcons.gaugeHigh,
                                    color: typeColor,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Requisiti',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Lista verticale per mostrare tutto il testo
                            if (coral.difficulty != null)
                              _buildRequirementRow(
                                theme: theme,
                                icon: FontAwesomeIcons.graduationCap,
                                label: 'Difficoltà',
                                value: _translateDifficulty(coral.difficulty!),
                                color: _getDifficultyColor(coral.difficulty!),
                              ),
                            if (coral.difficulty != null &&
                                coral.lightRequirement != null)
                              const SizedBox(height: 8),
                            if (coral.lightRequirement != null)
                              _buildRequirementRow(
                                theme: theme,
                                icon: FontAwesomeIcons.lightbulb,
                                label: 'Luce',
                                value: _translateRequirement(
                                  coral.lightRequirement!,
                                ),
                                color: const Color(0xFFfbbf24),
                              ),
                            if (coral.lightRequirement != null &&
                                coral.flowRequirement != null)
                              const SizedBox(height: 8),
                            if (coral.flowRequirement != null)
                              _buildRequirementRow(
                                theme: theme,
                                icon: FontAwesomeIcons.water,
                                label: 'Flusso',
                                value: _translateRequirement(
                                  coral.flowRequirement!,
                                ),
                                color: const Color(0xFF60a5fa),
                              ),
                            if (coral.flowRequirement != null &&
                                coral.feeding != null)
                              const SizedBox(height: 8),
                            if (coral.feeding != null)
                              _buildRequirementRow(
                                theme: theme,
                                icon: FontAwesomeIcons.utensils,
                                label: 'Alimentazione',
                                value: coral.feeding!,
                                color: const Color(0xFFec4899),
                              ),
                            if (coral.feeding != null && coral.maxSize != null)
                              const SizedBox(height: 8),
                            if (coral.maxSize != null)
                              _buildRequirementRow(
                                theme: theme,
                                icon: FontAwesomeIcons.arrowsUpDownLeftRight,
                                label: 'Dimensione massima',
                                value: '${coral.maxSize} cm',
                                color: const Color(0xFF8b5cf6),
                              ),
                            if (coral.maxSize != null &&
                                coral.aggressive != null)
                              const SizedBox(height: 8),
                            if (coral.aggressive != null)
                              _buildRequirementRow(
                                theme: theme,
                                icon: coral.aggressive == true
                                    ? FontAwesomeIcons.skullCrossbones
                                    : FontAwesomeIcons.handsPraying,
                                label: 'Comportamento',
                                value: coral.aggressive == true
                                    ? 'Aggressivo'
                                    : 'Pacifico',
                                color: coral.aggressive == true
                                    ? const Color(0xFFef4444)
                                    : const Color(0xFF34d399),
                              ),
                            if (coral.aggressive != null &&
                                coral.minTankSize != null)
                              const SizedBox(height: 8),
                            if (coral.minTankSize != null)
                              _buildRequirementRow(
                                theme: theme,
                                icon: FontAwesomeIcons.fish,
                                label: 'Vasca minima',
                                value: '${coral.minTankSize}L',
                                color: const Color(0xFF06b6d4),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Data aggiunta e giorni in vasca
                    _buildDetailCard(
                      theme: theme,
                      icon: FontAwesomeIcons.calendar,
                      iconColor: const Color(0xFF8b5cf6),
                      title: 'Aggiunto il',
                      content: _formatDate(coral.addedDate),

                      fontSize: 13,
                    ),

                    // Note personali (se presenti)
                    if (coral.notes != null && coral.notes!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildDetailCard(
                        theme: theme,
                        icon: FontAwesomeIcons.noteSticky,
                        iconColor: const Color(0xFFec4899),
                        title: 'Note',
                        content: coral.notes!,
                        fontSize: 12,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required ThemeData theme,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
    String? subtitle,
    double fontSize = 14,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            iconColor.withValues(alpha: 0.1),
            iconColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FaIcon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Gennaio',
      'Febbraio',
      'Marzo',
      'Aprile',
      'Maggio',
      'Giugno',
      'Luglio',
      'Agosto',
      'Settembre',
      'Ottobre',
      'Novembre',
      'Dicembre',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildRequirementRow({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: FaIcon(icon, color: color, size: 14),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _translateDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'facile':
      case 'beginner':
        return 'Facile';
      case 'medio':
      case 'intermediate':
        return 'Medio';
      case 'difficile':
      case 'expert':
        return 'Difficile';
      default:
        return difficulty;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'facile':
      case 'beginner':
        return const Color(0xFF34d399);
      case 'medio':
      case 'intermediate':
        return const Color(0xFFfbbf24);
      case 'difficile':
      case 'expert':
        return const Color(0xFFef4444);
      default:
        return const Color(0xFF60a5fa);
    }
  }

  String _translateRequirement(String requirement) {
    switch (requirement.toLowerCase()) {
      case 'basso':
      case 'low':
        return 'Basso';
      case 'medio':
      case 'medium':
        return 'Medio';
      case 'alto':
      case 'high':
        return 'Alto';
      default:
        return requirement;
    }
  }
}
