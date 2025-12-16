import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/fish.dart';

class FishDetailsDialog extends StatelessWidget {
  final Fish fish;

  const FishDetailsDialog({super.key, required this.fish});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header con gradient
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.7),
                  ],
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
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.fish,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(fish.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(fish.species,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
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
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Contenuto scrollabile
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Famiglia (se presente)
                    if (fish.family != null) ...[
                      _buildDetailCard(
                        theme: theme,
                        icon: FontAwesomeIcons.dna,
                        iconColor: const Color(0xFF10b981),
                        title: 'Famiglia',
                        content: fish.family!,
                        fontSize: 13,
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Descrizione (se presente)
                    if (fish.description != null &&
                        fish.description!.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                              theme.colorScheme.primary.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.circleInfo,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Descrizione',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(fish.description!,
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

                    // Requisiti
                    if (fish.difficulty != null ||
                        fish.temperament != null ||
                        fish.diet != null ||
                        fish.reefSafe != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                              theme.colorScheme.primary.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
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
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: FaIcon(
                                    FontAwesomeIcons.gaugeHigh,
                                    color: theme.colorScheme.primary,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text('Requisiti',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (fish.difficulty != null)
                              _buildRequirementRow(
                                theme: theme,
                                icon: FontAwesomeIcons.graduationCap,
                                label: 'Difficoltà',
                                value: _translateDifficulty(fish.difficulty!),
                                color: _getDifficultyColor(fish.difficulty!),
                              ),
                            if (fish.difficulty != null &&
                                fish.temperament != null)
                              const SizedBox(height: 8),
                            if (fish.temperament != null)
                              _buildRequirementRow(
                                theme: theme,
                                icon: FontAwesomeIcons.heart,
                                label: 'Temperamento',
                                value: fish.temperament!,
                                color: const Color(0xFFec4899),
                              ),
                            if (fish.temperament != null && fish.diet != null)
                              const SizedBox(height: 8),
                            if (fish.diet != null)
                              _buildRequirementRow(
                                theme: theme,
                                icon: FontAwesomeIcons.utensils,
                                label: 'Dieta',
                                value: fish.diet!,
                                color: const Color(0xFF10b981),
                              ),
                            if (fish.diet != null && fish.reefSafe != null)
                              const SizedBox(height: 8),
                            if (fish.reefSafe != null)
                              _buildRequirementRow(
                                theme: theme,
                                icon: fish.reefSafe == true
                                    ? FontAwesomeIcons.circleCheck
                                    : FontAwesomeIcons.triangleExclamation,
                                label: 'Sicuro per reef',
                                value: fish.reefSafe == true ? 'Sì' : 'No',
                                color: fish.reefSafe == true
                                    ? const Color(0xFF34d399)
                                    : const Color(0xFFef4444),
                              ),
                            if (fish.reefSafe != null && fish.maxSize != null)
                              const SizedBox(height: 8),
                            if (fish.maxSize != null)
                              _buildRequirementRow(
                                theme: theme,
                                icon: FontAwesomeIcons.arrowsUpDownLeftRight,
                                label: 'Dimensione massima',
                                value: '${fish.maxSize} cm',
                                color: const Color(0xFF8b5cf6),
                              ),
                            if (fish.maxSize != null &&
                                fish.minTankSize != null)
                              const SizedBox(height: 8),
                            if (fish.minTankSize != null)
                              _buildRequirementRow(
                                theme: theme,
                                icon: FontAwesomeIcons.fish,
                                label: 'Vasca minima',
                                value: '${fish.minTankSize}L',
                                color: const Color(0xFF06b6d4),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Dimensione attuale
                    _buildDetailCard(
                      theme: theme,
                      icon: FontAwesomeIcons.ruler,
                      iconColor: const Color(0xFF8b5cf6),
                      title: 'Dimensione attuale',
                      content: '${fish.size.toStringAsFixed(1)} cm',
                      fontSize: 13,
                    ),
                    const SizedBox(height: 12),

                    // Data aggiunta
                    _buildDetailCard(
                      theme: theme,
                      icon: FontAwesomeIcons.calendar,
                      iconColor: const Color(0xFF06b6d4),
                      title: 'Aggiunto il',
                      content: _formatDate(fish.addedDate),
                      fontSize: 13,
                    ),

                    // Note personali (se presenti)
                    if (fish.notes != null && fish.notes!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildDetailCard(
                        theme: theme,
                        icon: FontAwesomeIcons.noteSticky,
                        iconColor: const Color(0xFFec4899),
                        title: 'Note',
                        content: fish.notes!,
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
    required double fontSize,
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
        border: Border.all(color: iconColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FaIcon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(content,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: fontSize,
                    height: 1.5,
                  ),
                ),
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          FaIcon(icon, color: color, size: 16),
          const SizedBox(width: 10),
          Text('$label: ',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(value,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
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
}
