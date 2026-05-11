/// Generic empty-state widget and domain-specific convenience variants.
library;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';

/// A centred empty-state illustration with title, message, and optional CTA.
///
/// The icon bounces in via an elasticOut tween (800 ms); the title and message
/// fade + slide up (600 ms each).  If both [actionLabel] and [onAction] are
/// provided an ElevatedButton scales in below the message.
///
/// Convenience subclasses pre-configure icon, colours, and localised strings
/// for the most common empty states in the app:
/// [NoAquariumsEmptyState], [NoFishEmptyState], [NoCoralsEmptyState],
/// [NoHistoryEmptyState], [NoMaintenanceTasksEmptyState],
/// [NoAlertsEmptyState], [NoSearchResultsEmptyState],
/// [ErrorEmptyState], [OfflineEmptyState].
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;
  final double iconSize;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.iconSize = 80,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon con animazione
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: (iconColor ?? theme.primaryColor).withValues(
                    alpha: isDark ? 0.15 : 0.1,
                  ),
                  shape: BoxShape.circle,
                ),
                child: FaIcon(
                  icon,
                  size: iconSize,
                  color: iconColor ?? theme.primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Title con fade-in
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Text(title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 12),

            // Message con fade-in ritardato
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Text(message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 32),

              // Button con animazione
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: child,
                    ),
                  );
                },
                child: ElevatedButton.icon(
                  onPressed: onAction,
                  icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
                  label: Text(actionLabel!),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state shown when the user has no aquariums configured yet.
class NoAquariumsEmptyState extends StatelessWidget {
  final VoidCallback? onAddAquarium;

  const NoAquariumsEmptyState({super.key, this.onAddAquarium});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: FontAwesomeIcons.fishFins,
      title: l10n.noAquarium,
      message: l10n.noAquariumDescription,
      actionLabel: l10n.createAquarium,
      onAction: onAddAquarium,
      iconColor: const Color(0xFF3b82f6),
    );
  }
}

/// Empty state shown when the fish list for an aquarium is empty.
class NoFishEmptyState extends StatelessWidget {
  final VoidCallback? onAddFish;

  const NoFishEmptyState({super.key, this.onAddFish});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: FontAwesomeIcons.fish,
      title: l10n.noFish,
      message: l10n.noFishDescription,
      actionLabel: l10n.addFish,
      onAction: onAddFish,
      iconColor: const Color(0xFF10b981),
    );
  }
}

/// Empty state shown when the coral list for an aquarium is empty.
class NoCoralsEmptyState extends StatelessWidget {
  final VoidCallback? onAddCoral;

  const NoCoralsEmptyState({super.key, this.onAddCoral});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: FontAwesomeIcons.tree,
      title: l10n.noCoral,
      message: l10n.noCoralDescription,
      actionLabel: l10n.addCoral,
      onAction: onAddCoral,
      iconColor: const Color(0xFFf59e0b),
    );
  }
}

/// Empty state shown when no parameter history is available.
class NoHistoryEmptyState extends StatelessWidget {
  const NoHistoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: FontAwesomeIcons.chartLine,
      title: l10n.noHistory,
      message: l10n.noHistoryDescription,
      iconColor: const Color(0xFF8b5cf6),
    );
  }
}

/// Empty state shown when an aquarium has no maintenance tasks.
class NoMaintenanceTasksEmptyState extends StatelessWidget {
  final VoidCallback? onAddTask;

  const NoMaintenanceTasksEmptyState({super.key, this.onAddTask});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: FontAwesomeIcons.screwdriverWrench,
      title: l10n.noTasks,
      message: l10n.noTasksDescription,
      actionLabel: l10n.createTask,
      onAction: onAddTask,
      iconColor: const Color(0xFFec4899),
    );
  }
}

/// Empty state shown in the alerts tab when all parameters are within range.
class NoAlertsEmptyState extends StatelessWidget {
  const NoAlertsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: FontAwesomeIcons.bellSlash,
      title: l10n.allOk,
      message: l10n.allOkDescription,
      iconColor: const Color(0xFF10b981),
    );
  }
}

/// Empty state shown when a search query returns no matching results.
class NoSearchResultsEmptyState extends StatelessWidget {
  final String searchQuery;

  const NoSearchResultsEmptyState({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: FontAwesomeIcons.magnifyingGlass,
      title: l10n.noResults,
      message: l10n.noResultsDescription(searchQuery),
      iconColor: const Color(0xFF6b7280),
    );
  }
}

/// Empty state for generic error conditions with an optional retry action.
class ErrorEmptyState extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const ErrorEmptyState({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: FontAwesomeIcons.triangleExclamation,
      title: l10n.errorTitle,
      message: message ?? l10n.errorDescription,
      actionLabel: onRetry != null ? l10n.retry : null,
      onAction: onRetry,
      iconColor: const Color(0xFFef4444),
    );
  }
}

/// Empty state displayed when the device appears to be offline.
class OfflineEmptyState extends StatelessWidget {
  final VoidCallback? onRetry;

  const OfflineEmptyState({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: FontAwesomeIcons.wifi,
      title: l10n.offline,
      message: l10n.offlineDescription,
      actionLabel: onRetry != null ? l10n.retry : null,
      onAction: onRetry,
      iconColor: const Color(0xFF6b7280),
    );
  }
}
