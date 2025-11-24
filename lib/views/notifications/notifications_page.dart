import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/models/notification_settings.dart';
import 'package:acquariumfe/services/alert_manager.dart';
import 'package:acquariumfe/services/notification_preferences_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final AlertManager _alertManager = AlertManager();
  final NotificationPreferencesService _prefsService = NotificationPreferencesService();
  NotificationSettings _settings = NotificationSettings();
  
  late Animation<double> _fadeAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _animationController.forward();
    _loadSettings();
  }

  /// Carica le impostazioni salvate all'avvio
  Future<void> _loadSettings() async {
    final settings = await _prefsService.loadSettings();
    setState(() {
      _settings = settings;
    });
    _alertManager.updateSettings(_settings);
  }

  /// Salva le impostazioni correnti
  Future<void> _saveSettings() async {
    await _prefsService.saveSettings(_settings);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text('Impostazioni salvate'),
            ],
          ),
          backgroundColor: const Color(0xFF34d399),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Notifiche', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          tabs: const [
            Tab(text: 'Impostazioni'),
            Tab(text: 'Soglie'),
            Tab(text: 'Storico'),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildSettingsTab(bottomPadding),
            _buildThresholdsTab(bottomPadding),
            _buildHistoryTab(bottomPadding),
          ],
        ),
      ),
    );
  }

  // TAB 1: IMPOSTAZIONI GENERALI
  Widget _buildSettingsTab(double bottomPadding) {
    final theme = Theme.of(context);
    
    return ListView(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20 + bottomPadding),
      children: [
        
        // Alert Parametri
        _buildSwitchCard(
          title: 'Alert Parametri',
          subtitle: 'Notifiche quando i parametri sono fuori range',
          icon: FontAwesomeIcons.triangleExclamation,
          color: const Color(0xFFef4444),
          value: _settings.enabledAlerts,
          onChanged: (value) {
            setState(() {
              _settings = _settings.copyWith(enabledAlerts: value);
              _alertManager.updateSettings(_settings);
            });
          },
        ),
        const SizedBox(height: 12),
        
        // Promemoria Manutenzione
        _buildSwitchCard(
          title: 'Promemoria Manutenzione',
          subtitle: 'Notifiche per cambio acqua, pulizia filtro, ecc.',
          icon: FontAwesomeIcons.wrench,
          color: const Color(0xFF34d399),
          value: _settings.enabledMaintenance,
          onChanged: (value) {
            setState(() {
              _settings = _settings.copyWith(enabledMaintenance: value);
              _alertManager.updateSettings(_settings);
            });
          },
        ),
        const SizedBox(height: 12),
        
        // Riepilogo Giornaliero
        _buildSwitchCard(
          title: 'Riepilogo Giornaliero',
          subtitle: 'Notifica giornaliera con stato acquario',
          icon: FontAwesomeIcons.calendarDay,
          color: const Color(0xFF60a5fa),
          value: _settings.enabledDaily,
          onChanged: (value) {
            setState(() {
              _settings = _settings.copyWith(enabledDaily: value);
            });
          },
        ),
        
        const SizedBox(height: 32),
        _buildSectionTitle('Frequenza Manutenzione'),
        const SizedBox(height: 12),
        
        // Cambio Acqua
        _buildMaintenanceCard(
          title: 'Cambio Acqua',
          icon: FontAwesomeIcons.droplet,
          color: const Color(0xFF60a5fa),
          schedule: _settings.maintenanceReminders.waterChange,
          onToggle: (enabled) {
            setState(() {
              _settings = _settings.copyWith(
                maintenanceReminders: _settings.maintenanceReminders.copyWith(
                  waterChange: _settings.maintenanceReminders.waterChange.copyWith(enabled: enabled),
                ),
              );
            });
          },
          onFrequencyChanged: (days) {
            setState(() {
              _settings = _settings.copyWith(
                maintenanceReminders: _settings.maintenanceReminders.copyWith(
                  waterChange: _settings.maintenanceReminders.waterChange.copyWith(frequencyDays: days),
                ),
              );
            });
          },
        ),
        const SizedBox(height: 12),
        
        // Pulizia Filtro
        _buildMaintenanceCard(
          title: 'Pulizia Filtro',
          icon: FontAwesomeIcons.filter,
          color: const Color(0xFF34d399),
          schedule: _settings.maintenanceReminders.filterCleaning,
          onToggle: (enabled) {
            setState(() {
              _settings = _settings.copyWith(
                maintenanceReminders: _settings.maintenanceReminders.copyWith(
                  filterCleaning: _settings.maintenanceReminders.filterCleaning.copyWith(enabled: enabled),
                ),
              );
            });
          },
          onFrequencyChanged: (days) {
            setState(() {
              _settings = _settings.copyWith(
                maintenanceReminders: _settings.maintenanceReminders.copyWith(
                  filterCleaning: _settings.maintenanceReminders.filterCleaning.copyWith(frequencyDays: days),
                ),
              );
            });
          },
        ),
        const SizedBox(height: 12),
        
        // Test Parametri
        _buildMaintenanceCard(
          title: 'Test Parametri',
          icon: FontAwesomeIcons.flask,
          color: const Color(0xFFa855f7),
          schedule: _settings.maintenanceReminders.parameterTesting,
          onToggle: (enabled) {
            setState(() {
              _settings = _settings.copyWith(
                maintenanceReminders: _settings.maintenanceReminders.copyWith(
                  parameterTesting: _settings.maintenanceReminders.parameterTesting.copyWith(enabled: enabled),
                ),
              );
            });
          },
          onFrequencyChanged: (days) {
            setState(() {
              _settings = _settings.copyWith(
                maintenanceReminders: _settings.maintenanceReminders.copyWith(
                  parameterTesting: _settings.maintenanceReminders.parameterTesting.copyWith(frequencyDays: days),
                ),
              );
            });
          },
        ),
        
        const SizedBox(height: 32),
        // Pulsante Salva
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              await _alertManager.scheduleMaintenanceReminders();
              await _saveSettings(); // Salva persistenza
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.floppyDisk),
                SizedBox(width: 8),
                Text('Salva Impostazioni', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // TAB 2: SOGLIE PARAMETRI
  Widget _buildThresholdsTab(double bottomPadding) {
    return ListView(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20 + bottomPadding),
      children: [
        _buildThresholdCard('Temperatura', '°C', _settings.temperature, FontAwesomeIcons.temperatureHalf, const Color(0xFFef4444)),
        const SizedBox(height: 12),
        _buildThresholdCard('pH', '', _settings.ph, FontAwesomeIcons.flask, const Color(0xFF60a5fa)),
        const SizedBox(height: 12),
        _buildThresholdCard('Salinità', '', _settings.salinity, FontAwesomeIcons.water, const Color(0xFF2dd4bf)),
        const SizedBox(height: 12),
        _buildThresholdCard('ORP', ' mV', _settings.orp, FontAwesomeIcons.bolt, const Color(0xFFfbbf24)),
        const SizedBox(height: 12),
        _buildThresholdCard('Calcio', ' mg/L', _settings.calcium, FontAwesomeIcons.cubesStacked, const Color(0xFFa855f7)),
        const SizedBox(height: 12),
        _buildThresholdCard('Magnesio', ' mg/L', _settings.magnesium, FontAwesomeIcons.atom, const Color(0xFFec4899)),
        const SizedBox(height: 12),
        _buildThresholdCard('KH', ' dKH', _settings.kh, FontAwesomeIcons.chartLine, const Color(0xFF34d399)),
        const SizedBox(height: 12),
        _buildThresholdCard('Nitrati', ' mg/L', _settings.nitrate, FontAwesomeIcons.seedling, const Color(0xFF10b981)),
        const SizedBox(height: 12),
        _buildThresholdCard('Fosfati', ' mg/L', _settings.phosphate, FontAwesomeIcons.droplet, const Color(0xFF8b5cf6)),
        
        const SizedBox(height: 32),
        // Pulsante Ripristina Predefiniti
        SizedBox(
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () => _showResetDialog(),
            icon: const FaIcon(FontAwesomeIcons.arrowRotateRight),
            label: const Text('Ripristina Valori Predefiniti', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFfbbf24),
              side: const BorderSide(color: Color(0xFFfbbf24), width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  // TAB 3: STORICO ALERT
  Widget _buildHistoryTab(double bottomPadding) {
    final history = _alertManager.getAlertHistory(limit: 50);
    
    return history.isEmpty
        ? _buildEmptyState()
        : ListView(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20 + bottomPadding),
            children: [
              _buildHeader(
                icon: FontAwesomeIcons.clockRotateLeft,
                title: 'Storico Alert',
                subtitle: '${history.length} notifiche recenti',
              ),
              const SizedBox(height: 20),
              ...history.map((alert) => _buildAlertCard(alert)),
            ],
          );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: FaIcon(FontAwesomeIcons.bellSlash, color: theme.colorScheme.onSurface.withValues(alpha: 0.3), size: 64),
          ),
          const SizedBox(height: 20),
          Text(
            'Nessun Alert',
            style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Gli alert appariranno qui',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({required IconData icon, required String title, required String subtitle}) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);
    
    return Text(
      title,
      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSwitchCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha:0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: color,
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceCard({
    required String title,
    required IconData icon,
    required Color color,
    required ReminderSchedule schedule,
    required ValueChanged<bool> onToggle,
    required ValueChanged<int> onFrequencyChanged,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha:0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(title, style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 15, fontWeight: FontWeight.w600)),
              ),
              Switch(
                value: schedule.enabled,
                onChanged: onToggle,
                activeThumbColor: color,
              ),
            ],
          ),
          if (schedule.enabled) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Ogni', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
                const SizedBox(width: 12),
                Expanded(
                  child: Slider(
                    value: schedule.frequencyDays.toDouble(),
                    min: 1,
                    max: 90,
                    divisions: 89,
                    activeColor: color,
                    label: '${schedule.frequencyDays} giorni',
                    onChanged: (value) => onFrequencyChanged(value.toInt()),
                  ),
                ),
                Text('${schedule.frequencyDays}d', style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildThresholdCard(String name, String unit, ParameterThresholds thresholds, IconData icon, Color color) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () => _showEditThresholdDialog(name, unit, thresholds, color),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha:0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(name, style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.w600)),
                const Spacer(),
                FaIcon(FontAwesomeIcons.pen, color: theme.colorScheme.onSurfaceVariant, size: 18),
                const SizedBox(width: 4),
                Text('${thresholds.min} - ${thresholds.max}$unit', style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Min', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text('${thresholds.min}$unit', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Max', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text('${thresholds.max}$unit', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Switch(
                  value: thresholds.enabled,
                  onChanged: (value) {
                    setState(() {
                      _updateThresholdEnabled(name, value);
                    });
                  },
                  activeThumbColor: color,
                ),
                const SizedBox(width: 8),
                Text(
                  thresholds.enabled ? 'Notifiche Attive' : 'Notifiche Disattivate',
                  style: TextStyle(
                    color: thresholds.enabled ? color : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(AlertLog alert) {
    final theme = Theme.of(context);
    
    Color severityColor;
    IconData severityIcon;

    switch (alert.severity) {
      case AlertSeverity.critical:
        severityColor = const Color(0xFFef4444);
        severityIcon = FontAwesomeIcons.circleExclamation;
        break;
      case AlertSeverity.high:
        severityColor = const Color(0xFFfbbf24);
        severityIcon = FontAwesomeIcons.triangleExclamation;
        break;
      case AlertSeverity.medium:
        severityColor = const Color(0xFF60a5fa);
        severityIcon = FontAwesomeIcons.circleInfo;
        break;
      case AlertSeverity.low:
        severityColor = const Color(0xFF34d399);
        severityIcon = FontAwesomeIcons.circleCheck;
        break;
    }

    // Determina se è un alert "TROPPO BASSO" o "TROPPO ALTO"
    Widget? directionIndicator;
    if (alert.message.contains('TROPPO BASSO')) {
      directionIndicator = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF60a5fa).withValues(alpha:0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF60a5fa), width: 1),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(FontAwesomeIcons.arrowDown, color: Color(0xFF60a5fa), size: 12),
            SizedBox(width: 4),
            Text('BASSO', style: TextStyle(color: Color(0xFF60a5fa), fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    } else if (alert.message.contains('TROPPO ALTO')) {
      directionIndicator = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFef4444).withValues(alpha:0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFef4444), width: 1),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(FontAwesomeIcons.arrowUp, color: Color(0xFFef4444), size: 12),
            SizedBox(width: 4),
            Text('ALTO', style: TextStyle(color: Color(0xFFef4444), fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: severityColor.withValues(alpha:0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(severityIcon, color: severityColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        alert.title,
                        style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (directionIndicator != null) ...[
                      const SizedBox(width: 8),
                      directionIndicator,
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(alert.message, style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12)),
                const SizedBox(height: 6),
                Text(
                  _formatTimestamp(alert.timestamp),
                  style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.3), fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'Ora';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m fa';
    if (difference.inHours < 24) return '${difference.inHours}h fa';
    if (difference.inDays < 7) return '${difference.inDays}g fa';
    
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  // Dialog per modificare le soglie
  void _showEditThresholdDialog(String name, String unit, ParameterThresholds currentThresholds, Color color) {
    final theme = Theme.of(context);
    final minController = TextEditingController(text: currentThresholds.min.toString());
    final maxController = TextEditingController(text: currentThresholds.max.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Row(
          children: [
            FaIcon(FontAwesomeIcons.sliders, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Modifica Soglie - $name',
                style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 17),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: minController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: 'Valore Minimo',
                labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                suffixText: unit,
                suffixStyle: TextStyle(color: color),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha:0.2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: color),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: maxController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: 'Valore Massimo',
                labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                suffixText: unit,
                suffixStyle: TextStyle(color: color),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha:0.2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: color),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withValues(alpha:0.3)),
              ),
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.circleInfo, color: color, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Riceverai notifiche quando il valore esce da questo range',
                      style: TextStyle(color: color, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            onPressed: () async {
              final newMin = double.tryParse(minController.text);
              final newMax = double.tryParse(maxController.text);

              if (newMin == null || newMax == null) {
                
                return;
              }

              if (newMin >= newMax) {
                
                return;
              }

              setState(() {
                _updateThresholds(name, newMin, newMax);
              });

              Navigator.pop(context);
             
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
            ),
            child: const Text('Salva'),
          ),
        ],
      ),
    );
  }

  // Aggiorna le soglie nel modello settings
  void _updateThresholds(String parameterName, double min, double max) {
    switch (parameterName) {
      case 'Temperatura':
        _settings = _settings.copyWith(
          temperature: ParameterThresholds(min: min, max: max, enabled: _settings.temperature.enabled),
        );
        break;
      case 'pH':
        _settings = _settings.copyWith(
          ph: ParameterThresholds(min: min, max: max, enabled: _settings.ph.enabled),
        );
        break;
      case 'Salinità':
        _settings = _settings.copyWith(
          salinity: ParameterThresholds(min: min, max: max, enabled: _settings.salinity.enabled),
        );
        break;
      case 'ORP':
        _settings = _settings.copyWith(
          orp: ParameterThresholds(min: min, max: max, enabled: _settings.orp.enabled),
        );
        break;
      case 'Calcio':
        _settings = _settings.copyWith(
          calcium: ParameterThresholds(min: min, max: max, enabled: _settings.calcium.enabled),
        );
        break;
      case 'Magnesio':
        _settings = _settings.copyWith(
          magnesium: ParameterThresholds(min: min, max: max, enabled: _settings.magnesium.enabled),
        );
        break;
      case 'KH':
        _settings = _settings.copyWith(
          kh: ParameterThresholds(min: min, max: max, enabled: _settings.kh.enabled),
        );
        break;
      case 'Nitrati':
        _settings = _settings.copyWith(
          nitrate: ParameterThresholds(min: min, max: max, enabled: _settings.nitrate.enabled),
        );
        break;
      case 'Fosfati':
        _settings = _settings.copyWith(
          phosphate: ParameterThresholds(min: min, max: max, enabled: _settings.phosphate.enabled),
        );
        break;
    }
    _alertManager.updateSettings(_settings);
  }

  // Abilita/disabilita notifiche per un parametro
  void _updateThresholdEnabled(String parameterName, bool enabled) {
    switch (parameterName) {
      case 'Temperatura':
        _settings = _settings.copyWith(
          temperature: ParameterThresholds(
            min: _settings.temperature.min,
            max: _settings.temperature.max,
            enabled: enabled,
          ),
        );
        break;
      case 'pH':
        _settings = _settings.copyWith(
          ph: ParameterThresholds(
            min: _settings.ph.min,
            max: _settings.ph.max,
            enabled: enabled,
          ),
        );
        break;
      case 'Salinità':
        _settings = _settings.copyWith(
          salinity: ParameterThresholds(
            min: _settings.salinity.min,
            max: _settings.salinity.max,
            enabled: enabled,
          ),
        );
        break;
      case 'ORP':
        _settings = _settings.copyWith(
          orp: ParameterThresholds(
            min: _settings.orp.min,
            max: _settings.orp.max,
            enabled: enabled,
          ),
        );
        break;
      case 'Calcio':
        _settings = _settings.copyWith(
          calcium: ParameterThresholds(
            min: _settings.calcium.min,
            max: _settings.calcium.max,
            enabled: enabled,
          ),
        );
        break;
      case 'Magnesio':
        _settings = _settings.copyWith(
          magnesium: ParameterThresholds(
            min: _settings.magnesium.min,
            max: _settings.magnesium.max,
            enabled: enabled,
          ),
        );
        break;
      case 'KH':
        _settings = _settings.copyWith(
          kh: ParameterThresholds(
            min: _settings.kh.min,
            max: _settings.kh.max,
            enabled: enabled,
          ),
        );
        break;
      case 'Nitrati':
        _settings = _settings.copyWith(
          nitrate: ParameterThresholds(
            min: _settings.nitrate.min,
            max: _settings.nitrate.max,
            enabled: enabled,
          ),
        );
        break;
      case 'Fosfati':
        _settings = _settings.copyWith(
          phosphate: ParameterThresholds(
            min: _settings.phosphate.min,
            max: _settings.phosphate.max,
            enabled: enabled,
          ),
        );
        break;
    }
    _alertManager.updateSettings(_settings);
  }

  /// Mostra dialog di conferma per ripristino valori predefiniti
  void _showResetDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Row(
          children: [
            const FaIcon(FontAwesomeIcons.triangleExclamation, color: Color(0xFFfbbf24), size: 28),
            const SizedBox(width: 12),
            //Text('Ripristinare Valori Predefiniti?', style: TextStyle(color: Colors.white, fontSize: 18)),
            Text(
                'Ripristinare Predefiniti?',
                style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 17),
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Questa azione resetterà tutte le soglie personalizzate ai valori di default:',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text('• Temperatura: 24-26°C', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12)),
            Text('• pH: 8.0-8.4', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12)),
            Text('• Salinità: 1020-1028', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12)),
            Text('• E tutti gli altri parametri...', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12)),
            const SizedBox(height: 16),
            const Text(
              'Le modifiche verranno salvate immediatamente.',
              style: TextStyle(color: Color(0xFFfbbf24), fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annulla', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _settings = NotificationSettings(); // Reset a default
              });
              _alertManager.updateSettings(_settings);
              await _prefsService.resetToDefaults();
              
              Navigator.pop(context);
              
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFfbbf24),
              foregroundColor: Colors.black,
            ),
            child: const Text('Ripristina'),
          ),
        ],
      ),
    );
  }
}


