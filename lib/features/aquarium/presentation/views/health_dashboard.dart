/// Real-time health dashboard showing parameter status and alert history.
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/features/settings/data/alert_manager.dart';
import 'package:acquariumfe/features/settings/data/notification_preferences_service.dart';
import 'package:acquariumfe/features/settings/domain/models/notification_settings.dart';
import 'package:acquariumfe/features/parameters/presentation/providers/parameters_provider.dart';
import 'package:acquariumfe/core/widgets/responsive_builder.dart';
import 'package:acquariumfe/core/utils/responsive_breakpoints.dart';
import 'package:acquariumfe/core/theme/app_semantic_colors.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';

/// A single parameter reading paired with its healthy [ParameterThresholds].
///
/// Used by the deficiency list to show which parameters are out of range, in
/// which direction (too high / too low), and what the healthy band is.
class _ParamReading {
  const _ParamReading(
    this.label,
    this.value,
    this.threshold,
    this.icon,
    this.unit,
    this.decimals,
  );

  final String label;
  final double value;
  final ParameterThresholds threshold;
  final IconData icon;
  final String unit;
  final int decimals;

  bool get isLow => threshold.enabled && value < threshold.min;
  bool get isHigh => threshold.enabled && value > threshold.max;
  bool get isOut => isLow || isHigh;

  String get valueText => '${value.toStringAsFixed(decimals)}$unit';
  String get minText => threshold.min.toStringAsFixed(decimals);
  String get maxText => threshold.max.toStringAsFixed(decimals);
}

/// Dashboard screen that displays the current health status of the active
/// aquarium with real-time parameter cards and a recent alert log.
///
/// **Auto-refresh:** [currentParametersProvider] is invalidated every 5 seconds
/// via a [Timer], triggering a re-fetch and re-render of all parameter cards.
///
/// **Alert card:** reads from [AlertManager.getAlertHistory] and renders the
/// most-recent alerts grouped by [AlertSeverity].
///
/// **Settings:** loaded from [NotificationPreferencesService] at startup to
/// keep [AlertManager] in sync with the latest user preferences.
///
/// Uses [ResponsiveBuilder] to switch between a single-column and two-column
/// grid layout based on [ResponsiveBreakpoints].
class HealthDashboard extends ConsumerStatefulWidget {
  const HealthDashboard({super.key});

  @override
  ConsumerState<HealthDashboard> createState() => _HealthDashboardState();
}

class _HealthDashboardState extends ConsumerState<HealthDashboard> {
  final AlertManager _alertManager = AlertManager();
  final NotificationPreferencesService _prefsService =
      NotificationPreferencesService();
  NotificationSettings _settings = NotificationSettings();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    // Polling ogni 5 secondi per aggiornare i parametri in tempo reale
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        ref.invalidate(currentParametersProvider);
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final settings = await _prefsService.loadSettings();
    _alertManager.updateSettings(settings);
    if (mounted) {
      setState(() {
        _settings = settings;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final parametersAsync = ref.watch(currentParametersProvider);

    return parametersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(
              FontAwesomeIcons.circleExclamation,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(l10n.errorLoadingParameters,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(currentParametersProvider.notifier).refresh(),
              icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 16),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
      data: (currentParams) {
        // Usa dati di fallback se non ancora caricati
        final currentTemperature = currentParams?.temperature ?? 25.0;
        final currentPh = currentParams?.ph ?? 8.2;
        final currentSalinity = currentParams?.salinity ?? 35.0;
        final currentOrp = currentParams?.orp ?? 350.0;
        final calcium = currentParams?.calcium ?? 420.0;
        final magnesium = currentParams?.magnesium ?? 1280.0;
        final kh = currentParams?.kh ?? 9.0;
        final nitrate = currentParams?.nitrate ?? 5.0;
        final phosphate = currentParams?.phosphate ?? 0.03;

        final alerts = _alertManager.getAlertHistory();
        final recentAlerts = alerts.take(3).toList();

        // Usa impostazioni di default per i range
        final settings = NotificationSettings();
        int parametersInRange = 0;
        int totalParameters = 9;

        if (!settings.temperature.isOutOfRange(currentTemperature)) parametersInRange++;
        if (!settings.ph.isOutOfRange(currentPh)) parametersInRange++;
        if (!settings.salinity.isOutOfRange(currentSalinity)) parametersInRange++;
        if (!settings.orp.isOutOfRange(currentOrp)) parametersInRange++;
        if (!settings.calcium.isOutOfRange(calcium)) parametersInRange++;
        if (!settings.magnesium.isOutOfRange(magnesium)) parametersInRange++;
        if (!settings.kh.isOutOfRange(kh)) parametersInRange++;
        if (!settings.nitrate.isOutOfRange(nitrate)) parametersInRange++;
        if (!settings.phosphate.isOutOfRange(phosphate)) parametersInRange++;

        final healthScore = ((parametersInRange / totalParameters) * 100)
            .round();
        final statusMessage = healthScore >= 80
            ? l10n.allOk
            : healthScore >= 60
            ? l10n.warning
            : l10n.critical;
        final c = context.semantic;
        final statusColor = healthScore >= 80
            ? c.statusOptimal
            : healthScore >= 60
            ? c.statusWarning
            : c.statusError;

        final readings = <_ParamReading>[
          _ParamReading(l10n.temperature, currentTemperature,
              settings.temperature, FontAwesomeIcons.temperatureHalf, ' °C', 1),
          _ParamReading(
              l10n.ph, currentPh, settings.ph, FontAwesomeIcons.flask, '', 2),
          _ParamReading(l10n.salinity, currentSalinity, settings.salinity,
              FontAwesomeIcons.water, ' PPT', 0),
          _ParamReading(l10n.orp, currentOrp, settings.orp,
              FontAwesomeIcons.bolt, ' mV', 0),
          _ParamReading(l10n.calcium, calcium, settings.calcium,
              FontAwesomeIcons.flask, ' mg/L', 0),
          _ParamReading(l10n.magnesium, magnesium, settings.magnesium,
              FontAwesomeIcons.flask, ' mg/L', 0),
          _ParamReading(
              l10n.kh, kh, settings.kh, FontAwesomeIcons.flask, ' dKH', 1),
          _ParamReading(l10n.nitratesNO3, nitrate, settings.nitrate,
              FontAwesomeIcons.flask, ' mg/L', 1),
          _ParamReading(l10n.phosphatesPO4, phosphate, settings.phosphate,
              FontAwesomeIcons.flask, ' mg/L', 2),
        ];

        return ResponsiveBuilder(
          builder: (context, info) {
            final screenWidth = MediaQuery.of(context).size.width;
            final padding = ResponsiveBreakpoints.horizontalPadding(
              screenWidth,
            );

            return SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hero Card - Check Status
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          statusColor.withValues(alpha: 0.3),
                          theme.colorScheme.surface,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(l10n.aquariumStatus,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(statusMessage,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(l10n.updatedNow(parametersInRange, totalParameters),
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Carenze: ogni parametro fuori range (tutti e 9), con
                  // direzione (alto/basso), valore e range ottimale.
                  _buildDeficiencies(readings, c),
                  const SizedBox(height: 16),

                  // Parametri principali - Grid responsive
                  GridView.count(
                    crossAxisCount: info.value(
                      mobile: 2,
                      tablet: 4,
                      desktop: 4,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 19,
                    mainAxisSpacing: 12,
                    childAspectRatio: info.value(
                      mobile: 1.8,
                      tablet: 1.8,
                      desktop: 2.0,
                    ),
                    children: [
                      _buildParamCard(
                        l10n.temperature,
                        '$currentTemperature °C',
                        FontAwesomeIcons.temperatureHalf,
                        c.temperatureAccent,
                        settings.temperature.isOutOfRange(currentTemperature),
                      ),
                      _buildParamCard(
                        l10n.ph,
                        currentPh.toString(),
                        FontAwesomeIcons.flask,
                        c.phAccent,
                        settings.ph.isOutOfRange(currentPh),
                      ),
                      _buildParamCard(
                        l10n.salinity,
                        '${currentSalinity.toInt()} PPT',
                        FontAwesomeIcons.water,
                        c.salinityAccent,
                        settings.salinity.isOutOfRange(currentSalinity),
                      ),
                      _buildParamCard(
                        l10n.orp,
                        '${currentOrp.toInt()} mV',
                        FontAwesomeIcons.bolt,
                        c.statusWarning,
                        settings.orp.isOutOfRange(currentOrp),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  _buildHealthScore(
                    healthScore,
                    parametersInRange,
                    totalParameters,
                  ),
                  const SizedBox(height: 20),
                  _buildQuickStats(
                    parametersInRange,
                    totalParameters - parametersInRange,
                    recentAlerts.length,
                  ),

                  // Alert critici
                  if (recentAlerts.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildCriticalAlerts(recentAlerts),
                  ],

                  const SizedBox(height: 24),
                  _buildMaintenanceReminders(),
                  const SizedBox(height: 24),
                  _buildRecommendations(healthScore, parametersInRange),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildParamCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isOutOfRange,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOutOfRange
              ? theme.colorScheme.error
              : theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(label,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              if (isOutOfRange)
                FaIcon(
                  FontAwesomeIcons.triangleExclamation,
                  color: theme.colorScheme.error,
                  size: 16,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
            style: TextStyle(
              color: isOutOfRange
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Highlights every out-of-range parameter as a scannable card (direction,
  /// current value, healthy range), or a single positive card when all 9
  /// parameters are within range.
  Widget _buildDeficiencies(List<_ParamReading> readings, AppSemanticColors c) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final issues = readings.where((r) => r.isOut).toList();

    if (issues.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              c.statusOptimal.withValues(alpha: 0.18),
              theme.colorScheme.surface,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.statusOptimal.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: c.statusOptimal.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: FaIcon(
                FontAwesomeIcons.circleCheck,
                color: c.statusOptimal,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.allOk,
                    style: TextStyle(
                      color: c.statusOptimal,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(l10n.allOkDescription,
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.statusError.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.triangleExclamation,
                color: c.statusError,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(l10n.parametersNeedAttention(issues.length),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...issues.map((r) {
            final dir = r.isHigh ? c.statusError : c.statusLow;
            final dirIcon = r.isHigh
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded;
            final dirLabel = r.isHigh ? l10n.high : l10n.low;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: dir.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FaIcon(r.icon, color: dir, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.label,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${l10n.optimal} '
                          '${l10n.minMaxRange(r.minText, r.maxText, r.unit)}',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(r.valueText,
                        style: TextStyle(
                          color: dir,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(dirIcon, color: dir, size: 12),
                          const SizedBox(width: 4),
                          Text(dirLabel,
                            style: TextStyle(
                              color: dir,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHealthScore(int score, int okParams, int totalParams) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final c = context.semantic;
    final color = score >= 80
        ? c.statusOptimal
        : score >= 60
        ? c.statusWarning
        : theme.colorScheme.error;
    final label = score >= 80
        ? l10n.excellent
        : score >= 60
        ? l10n.good
        : l10n.critical;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surfaceContainerHighest,
            theme.colorScheme.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 8,
                    backgroundColor: theme.colorScheme.onSurface.withValues(
                      alpha: 0.1,
                    ),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                Center(
                  child: Text('$score',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.healthScore,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(label,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(l10n.parametersInOptimalRange(okParams, totalParams),
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(int okParams, int criticalParams, int alerts) {
    final l10n = AppLocalizations.of(context)!;
    final c = context.semantic;
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            l10n.parametersOk,
            '$okParams',
            FontAwesomeIcons.circleCheck,
            c.statusOptimal,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            l10n.critical,
            '$criticalParams',
            FontAwesomeIcons.triangleExclamation,
            c.statusError,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            l10n.alerts,
            '$alerts',
            FontAwesomeIcons.bell,
            c.statusWarning,
          ),
        ),
      ],
    );
  }

  Widget _buildCriticalAlerts(List alerts) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final c = context.semantic;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: c.statusError.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.triangleExclamation,
                color: c.statusError,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.recentAlerts,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...alerts.map(
            (alert) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: c.statusError,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(alert.title,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(alert.message,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceReminders() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final c = context.semantic;
    final reminders = [
      {
        'title': l10n.waterChange,
        'days': _settings.maintenanceReminders.waterChange.frequencyDays,
        'icon': FontAwesomeIcons.droplet,
      },
      {
        'title': l10n.filterCleaning,
        'days': _settings.maintenanceReminders.filterCleaning.frequencyDays,
        'icon': FontAwesomeIcons.filter,
      },
      {
        'title': l10n.parameterTesting,
        'days': _settings.maintenanceReminders.parameterTesting.frequencyDays,
        'icon': FontAwesomeIcons.flask,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.calendar,
                color: c.statusLow,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(l10n.upcomingReminders,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...reminders.map(
            (reminder) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: c.statusLow.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      reminder['icon'] as IconData,
                      color: c.statusLow,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(reminder['title'] as String,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: c.statusLow.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('${reminder['days']} ${l10n.days}',
                      style: TextStyle(
                        color: c.statusLow,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(label,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations(int healthScore, int parametersInRange) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final c = context.semantic;
    final recommendations = <Map<String, dynamic>>[];

    if (healthScore < 80) {
      recommendations.add({
        'title': l10n.checkOutOfRangeParameters,
        'desc': l10n.parametersNeedAttention(9 - parametersInRange),
        'icon': FontAwesomeIcons.triangleExclamation,
        'urgent': true,
      });
    }

    recommendations.addAll([
      {
        'title': l10n.checkSkimmer,
        'desc': l10n.weeklyCleaningRecommended,
        'icon': FontAwesomeIcons.broom,
        'urgent': false,
      },
      {
        'title': l10n.khTest,
        'desc': l10n.lastTest3DaysAgo,
        'icon': FontAwesomeIcons.flask,
        'urgent': false,
      },
    ]);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.recommendations,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...recommendations.map(
            (rec) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          (rec['urgent'] as bool
                                  ? c.statusWarning
                                  : c.statusLow)
                              .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      rec['icon'] as IconData,
                      color: rec['urgent'] as bool
                          ? c.statusWarning
                          : c.statusLow,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rec['title'] as String,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(rec['desc'] as String,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
