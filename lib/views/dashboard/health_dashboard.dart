import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/services/alert_manager.dart';
import 'package:acquariumfe/services/notification_preferences_service.dart';
import 'package:acquariumfe/models/notification_settings.dart';
import 'package:acquariumfe/providers/parameters_provider.dart';
import 'package:acquariumfe/widgets/responsive_builder.dart';
import 'package:acquariumfe/utils/responsive_breakpoints.dart';
import 'package:acquariumfe/l10n/app_localizations.dart';

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
        final currentSalinity = currentParams?.salinity ?? 1024.0;
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

        if (!settings.temperature.isOutOfRange(currentTemperature))
          parametersInRange++;
        if (!settings.ph.isOutOfRange(currentPh)) parametersInRange++;
        if (!settings.salinity.isOutOfRange(currentSalinity))
          parametersInRange++;
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
        final statusColor = healthScore >= 80
            ? const Color(0xFF34d399)
            : healthScore >= 60
            ? const Color(0xFFfbbf24)
            : const Color(0xFFef4444);

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
                        const Color(0xFFef4444),
                        settings.temperature.isOutOfRange(currentTemperature),
                      ),
                      _buildParamCard(
                        l10n.ph,
                        currentPh.toString(),
                        FontAwesomeIcons.flask,
                        const Color(0xFF60a5fa),
                        settings.ph.isOutOfRange(currentPh),
                      ),
                      _buildParamCard(
                        l10n.salinity,
                        '${currentSalinity.toInt()} PPT',
                        FontAwesomeIcons.water,
                        const Color(0xFF2dd4bf),
                        settings.salinity.isOutOfRange(currentSalinity),
                      ),
                      _buildParamCard(
                        l10n.orp,
                        '${currentOrp.toInt()} mV',
                        FontAwesomeIcons.bolt,
                        const Color(0xFFfbbf24),
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

  Widget _buildHealthScore(int score, int okParams, int totalParams) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final color = score >= 80
        ? const Color(0xFF34d399)
        : score >= 60
        ? const Color(0xFFfbbf24)
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
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            l10n.parametersOk,
            '$okParams',
            FontAwesomeIcons.circleCheck,
            const Color(0xFF34d399),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            l10n.critical,
            '$criticalParams',
            FontAwesomeIcons.triangleExclamation,
            const Color(0xFFef4444),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            l10n.alerts,
            '$alerts',
            FontAwesomeIcons.bell,
            const Color(0xFFfbbf24),
          ),
        ),
      ],
    );
  }

  Widget _buildCriticalAlerts(List alerts) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFef4444).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.triangleExclamation,
                color: Color(0xFFef4444),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text('Alert Recenti',
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
                    decoration: const BoxDecoration(
                      color: Color(0xFFef4444),
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
              const FaIcon(
                FontAwesomeIcons.calendar,
                color: Color(0xFF60a5fa),
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
                      color: const Color(0xFF60a5fa).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      reminder['icon'] as IconData,
                      color: const Color(0xFF60a5fa),
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
                      color: const Color(0xFF60a5fa).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('${reminder['days']} ${l10n.days}',
                      style: const TextStyle(
                        color: Color(0xFF60a5fa),
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
                                  ? const Color(0xFFfbbf24)
                                  : const Color(0xFF60a5fa))
                              .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      rec['icon'] as IconData,
                      color: rec['urgent'] as bool
                          ? const Color(0xFFfbbf24)
                          : const Color(0xFF60a5fa),
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
