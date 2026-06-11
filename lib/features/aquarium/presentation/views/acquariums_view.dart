/// Home-tab view listing all of the user's aquariums.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/core/widgets/animated_value.dart';
import 'package:acquariumfe/core/routing/custom_page_route.dart';
import 'package:acquariumfe/core/utils/task_localizer.dart';
import 'package:acquariumfe/core/utils/exception_localizer.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';
import 'package:acquariumfe/features/aquarium/presentation/views/aquarium_details.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';
import 'package:acquariumfe/core/widgets/skeleton_loader.dart';
import 'package:acquariumfe/core/widgets/empty_state.dart';
import 'package:acquariumfe/features/aquarium/presentation/providers/aquarium_providers.dart';
import 'package:acquariumfe/core/widgets/responsive_builder.dart';
import 'package:acquariumfe/core/utils/responsive_breakpoints.dart';

/// Scrollable list of the user's aquariums, each shown as a card with its
/// name, type, volume, and current water parameters.
///
/// Pulls data from [aquariumsProvider] and shows:
/// - **Loading state** — three [AquariumCardSkeleton] placeholders
/// - **Error state** — error message with a retry button
/// - **Empty state** — [EmptyState] widget prompting the user to add an aquarium
/// - **Data state** — animated fade + slide-up list of aquarium cards
///
/// Tapping a card navigates to [AquariumDetails] using a [CustomPageRoute].
/// Pull-to-refresh calls `aquariumsProvider.notifier.refresh()`.
class AquariumView extends ConsumerStatefulWidget {
  const AquariumView({super.key});

  @override
  ConsumerState<AquariumView> createState() => _AquariumViewState();
}

class _AquariumViewState extends ConsumerState<AquariumView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final aquariumsAsync = ref.watch(aquariumsProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(aquariumsProvider.notifier).refresh(),
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,
      child: aquariumsAsync.when(
        loading: () => ListView(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          children: List.generate(3, (index) => const AquariumCardSkeleton()),
        ),
        error: (error, stack) => ListView(
          padding: const EdgeInsets.only(top: 20),
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.circleExclamation,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.loadingError,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error is AppException
                        ? ExceptionLocalizer.getLocalizedMessage(context, error)
                        : error.toString(),
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () =>
                        ref.read(aquariumsProvider.notifier).refresh(),
                    icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 16),
                    label: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            ),
          ],
        ),
        data: (aquariumsWithParams) {
          // Avvia animazioni se non già partite
          if (aquariumsWithParams.isNotEmpty &&
              aquariumsWithParams.first.aquarium.id != null) {
            if (_controller.status == AnimationStatus.dismissed) {
              _controller.forward();
            }
          }

          if (aquariumsWithParams.isEmpty) {
            return const NoAquariumsEmptyState();
          }

          return ResponsiveBuilder(
            builder: (context, info) {
              final padding = ResponsiveBreakpoints.horizontalPadding(
                info.screenWidth,
              );
              final columns = info.value(mobile: 1, tablet: 2, desktop: 3);

              // Per mobile usa ListView, per tablet/desktop usa GridView
              if (info.isMobile) {
                return ListView.builder(
                  padding: EdgeInsets.all(padding),
                  itemCount: aquariumsWithParams.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _buildAquariumCard(
                            context,
                            aquariumsWithParams[index],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }

              // Grid view per tablet e desktop
              return GridView.builder(
                padding: EdgeInsets.all(padding),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: info.value(
                    mobile: 1.0,
                    tablet: 1.2,
                    desktop: 1.3,
                  ),
                ),
                itemCount: aquariumsWithParams.length,
                itemBuilder: (context, index) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildAquariumCard(
                        context,
                        aquariumsWithParams[index],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAquariumCard(
    BuildContext context,
    AquariumWithParams aquariumData,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final aquarium = aquariumData.aquarium;
    final params = aquariumData.parameters;

    // Usa parametri reali o valori di fallback
    final temp = params?.temperature ?? 0.0;
    final ph = params?.ph ?? 0.0;
    final salinity = params?.salinity ?? 0.0;
    final hasData = params != null;

    return BounceButton(
      onTap: () {
        Navigator.push(
          context,
          CustomPageRoute(
            page: AquariumDetails(aquariumId: aquarium.id!),
            transitionType: PageTransitionType.fadeSlide,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1e293b), const Color(0xFF0f172a)]
                : [const Color(0xFFffffff), const Color(0xFFf1f5f9)],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: const Color(0xFF34d399).withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF34d399).withValues(alpha: 0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "aquarium_card_${aquarium.id}",
              child: Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(
                                    0xFF60a5fa,
                                  ).withValues(alpha: 0.2),
                                  const Color(
                                    0xFF2dd4bf,
                                  ).withValues(alpha: 0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(
                                  0xFF60a5fa,
                                ).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Icon(
                              aquarium.type == 'saltwater'
                                  ? FontAwesomeIcons.droplet
                                  : FontAwesomeIcons.water,
                              color: const Color(0xFF60a5fa),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(aquarium.name,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.droplet,
                                      size: 11,
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                                    const SizedBox(width: 4),
                                    Text("${aquarium.volume.toInt()} L • ${localizedAquariumType(aquarium.type, l10n)}",
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Timestamp ultimo aggiornamento
            // if (aquariumData.lastUpdate != null)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 4),
            //     child: Row(
            //       children: [
            //         Icon(
            //           FontAwesomeIcons.arrowsRotate,
            //           size: 12,
            //           color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            //         ),
            //         const SizedBox(width: 4),
            //         Text(l10n.updated(_formatRelativeTime(aquariumData.lastUpdate!)),
            //           style: TextStyle(
            //             color: theme.colorScheme.onSurface.withValues(
            //               alpha: 0.4,
            //             ),
            //             fontSize: 10,
            //             fontStyle: FontStyle.italic,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            const SizedBox(height: 16),
            // Parametri principali con card separate
            Row(
              children: [
                Expanded(
                  child: _buildParameterCard(
                    theme,
                    FontAwesomeIcons.temperatureHalf,
                    l10n.temperatureShort,
                    hasData ? temp.toStringAsFixed(1) : '--',
                    '°C',
                    const Color(0xFFef4444),
                    hasData,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildParameterCard(
                    theme,
                    FontAwesomeIcons.flask,
                    'pH',
                    hasData ? ph.toStringAsFixed(1) : '--',
                    '',
                    const Color(0xFF60a5fa),
                    hasData,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildParameterCard(
                    theme,
                    FontAwesomeIcons.water,
                    l10n.salinityShort,
                    hasData ? salinity.toStringAsFixed(0) : '--',
                    l10n.pptUnit,
                    const Color(0xFF2dd4bf),
                    hasData,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterCard(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
    String unit,
    Color color,
    bool hasData,
  ) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)]
              : [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasData
              ? color.withValues(alpha: 0.3)
              : theme.colorScheme.onSurface.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: hasData
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 22,
            color: hasData
                ? color
                : theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 6),
          Text(label,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(value,
                  style: TextStyle(
                    color: hasData
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Text(unit,
                  style: TextStyle(
                    color: hasData
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
                        : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
