import 'package:flutter/material.dart';
import 'package:acquariumfe/models/notification_settings.dart';
import 'package:acquariumfe/services/alert_manager.dart';
import 'package:acquariumfe/services/mock_data_service.dart';
import 'package:acquariumfe/services/notification_service.dart';
import 'package:acquariumfe/services/notification_preferences_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final AlertManager _alertManager = AlertManager();
  final MockDataService _mockService = MockDataService();
  final NotificationPreferencesService _prefsService = NotificationPreferencesService();
  NotificationSettings _settings = NotificationSettings();
  
  late Animation<double> _fadeAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
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
    final success = await _prefsService.saveSettings(_settings);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Impostazioni salvate con successo'),
          duration: Duration(seconds: 2),
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
    return Scaffold(
      backgroundColor: const Color(0xFF2d2d2d),
      appBar: AppBar(
        title: const Text('Notifiche', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        backgroundColor: const Color(0xFF3a3a3a),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF60a5fa),
          labelColor: const Color(0xFF60a5fa),
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Impostazioni'),
            Tab(text: 'Soglie'),
            Tab(text: 'Storico'),
            Tab(text: 'Test'),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildSettingsTab(),
            _buildThresholdsTab(),
            _buildHistoryTab(),
            _buildTestTab(),
          ],
        ),
      ),
    );
  }

  // TAB 1: IMPOSTAZIONI GENERALI
  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeader(
          icon: Icons.notifications_active,
          title: 'Impostazioni Notifiche',
          subtitle: 'Configura quando ricevere le notifiche',
        ),
        const SizedBox(height: 20),
        
        // Alert Parametri
        _buildSwitchCard(
          title: 'Alert Parametri',
          subtitle: 'Notifiche quando i parametri sono fuori range',
          icon: Icons.warning_amber,
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
          icon: Icons.build,
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
          icon: Icons.today,
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
          icon: Icons.water_drop,
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
          icon: Icons.filter_alt,
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
          icon: Icons.science,
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
              backgroundColor: const Color(0xFF60a5fa),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save),
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
  Widget _buildThresholdsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeader(
          icon: Icons.tune,
          title: 'Soglie Parametri',
          subtitle: 'Configura i valori min/max per gli alert',
        ),
        const SizedBox(height: 20),
        
        _buildThresholdCard('Temperatura', '°C', _settings.temperature, Icons.thermostat, const Color(0xFFef4444)),
        const SizedBox(height: 12),
        _buildThresholdCard('pH', '', _settings.ph, Icons.science_outlined, const Color(0xFF60a5fa)),
        const SizedBox(height: 12),
        _buildThresholdCard('Salinità', '', _settings.salinity, Icons.water_outlined, const Color(0xFF2dd4bf)),
        const SizedBox(height: 12),
        _buildThresholdCard('ORP', ' mV', _settings.orp, Icons.bolt, const Color(0xFFfbbf24)),
        const SizedBox(height: 12),
        _buildThresholdCard('Calcio', ' mg/L', _settings.calcium, Icons.analytics, const Color(0xFFa855f7)),
        const SizedBox(height: 12),
        _buildThresholdCard('Magnesio', ' mg/L', _settings.magnesium, Icons.bubble_chart, const Color(0xFFec4899)),
        const SizedBox(height: 12),
        _buildThresholdCard('KH', ' dKH', _settings.kh, Icons.show_chart, const Color(0xFF34d399)),
        
        const SizedBox(height: 32),
        // Pulsante Ripristina Predefiniti
        SizedBox(
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () => _showResetDialog(),
            icon: const Icon(Icons.restart_alt),
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
  Widget _buildHistoryTab() {
    final history = _alertManager.getAlertHistory(limit: 50);
    
    return history.isEmpty
        ? _buildEmptyState()
        : ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildHeader(
                icon: Icons.history,
                title: 'Storico Alert',
                subtitle: '${history.length} notifiche recenti',
              ),
              const SizedBox(height: 20),
              ...history.map((alert) => _buildAlertCard(alert)),
            ],
          );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF3a3a3a),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.notifications_off, color: Colors.white24, size: 64),
          ),
          const SizedBox(height: 20),
          const Text(
            'Nessun Alert',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Gli alert appariranno qui',
            style: TextStyle(color: Colors.white60, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({required IconData icon, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF4a4a4a), Color(0xFF3a3a3a)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF60a5fa).withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFF60a5fa), size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3a3a3a),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha:0.1)),
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
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 12)),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3a3a3a),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha:0.1)),
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
                child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
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
                const Text('Ogni', style: TextStyle(color: Colors.white70, fontSize: 13)),
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
    return GestureDetector(
      onTap: () => _showEditThresholdDialog(name, unit, thresholds, color),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF3a3a3a),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha:0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const Spacer(),
                const Icon(Icons.edit, color: Colors.white60, size: 18),
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
                      const Text('Min', style: TextStyle(color: Colors.white60, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text('${thresholds.min}$unit', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Max', style: TextStyle(color: Colors.white60, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text('${thresholds.max}$unit', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
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
                    color: thresholds.enabled ? color : Colors.white38,
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
    Color severityColor;
    IconData severityIcon;

    switch (alert.severity) {
      case AlertSeverity.critical:
        severityColor = const Color(0xFFef4444);
        severityIcon = Icons.error;
        break;
      case AlertSeverity.high:
        severityColor = const Color(0xFFfbbf24);
        severityIcon = Icons.warning;
        break;
      case AlertSeverity.medium:
        severityColor = const Color(0xFF60a5fa);
        severityIcon = Icons.info;
        break;
      case AlertSeverity.low:
        severityColor = const Color(0xFF34d399);
        severityIcon = Icons.check_circle;
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
            Icon(Icons.arrow_downward, color: Color(0xFF60a5fa), size: 12),
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
            Icon(Icons.arrow_upward, color: Color(0xFFef4444), size: 12),
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
        color: const Color(0xFF3a3a3a),
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
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (directionIndicator != null) ...[
                      const SizedBox(width: 8),
                      directionIndicator,
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(alert.message, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                const SizedBox(height: 6),
                Text(
                  _formatTimestamp(alert.timestamp),
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
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

  // TAB 4: TEST NOTIFICHE
  Widget _buildTestTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeader(
          icon: Icons.science,
          title: 'Test Notifiche',
          subtitle: 'Simula alert e notifiche con dati mock',
        ),
        const SizedBox(height: 20),
        
        // Sezione Test Notifica Reale
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF3a3a3a),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.notifications_active, color: Color(0xFF60a5fa), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Test Notifica Reale',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Invia una notifica vera sul dispositivo (apparirà nella barra notifiche)',
                style: TextStyle(color: Colors.white60, fontSize: 13),
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await NotificationService().showTestNotification();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✅ Notifica inviata! Controlla la barra notifiche'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Invia Notifica Reale'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF60a5fa),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Sezione Test Alert Parametri
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF3a3a3a),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.warning_amber, color: Color(0xFFef4444), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Test Alert Parametri',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Simula parametri TROPPO ALTI o TROPPO BASSI per testare le notifiche',
                style: TextStyle(color: Colors.white60, fontSize: 13),
              ),
              const SizedBox(height: 16),
              
              // Sezione Parametri TROPPO ALTI
              const Text(
                '⬆️ PARAMETRI TROPPO ALTI',
                style: TextStyle(
                  color: Color(0xFFef4444),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTestButton(
                    'Temp Alta',
                    Icons.thermostat,
                    const Color(0xFFef4444),
                    () async {
                      _mockService.simulateOutOfRangeParameter('temperature');
                      await _mockService.checkSingleParameter('temperature');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('🌡️ Alert: Temperatura TROPPO ALTA!')),
                        );
                        setState(() {});
                      }
                    },
                  ),
                  _buildTestButton(
                    'pH Alto',
                    Icons.water_drop,
                    const Color(0xFFef4444),
                    () async {
                      _mockService.simulateOutOfRangeParameter('ph');
                      await _mockService.checkSingleParameter('ph');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('💧 Alert: pH TROPPO ALTO!')),
                        );
                        setState(() {});
                      }
                    },
                  ),
                  _buildTestButton(
                    'Nitrati Alti',
                    Icons.science,
                    const Color(0xFFef4444),
                    () async {
                      _mockService.simulateOutOfRangeParameter('nitrate');
                      await _mockService.checkSingleParameter('nitrate');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('🔬 Alert: Nitrati TROPPO ALTI!')),
                        );
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Sezione Parametri TROPPO BASSI
              const Text(
                '⬇️ PARAMETRI TROPPO BASSI',
                style: TextStyle(
                  color: Color(0xFF60a5fa),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTestButton(
                    'Temp Bassa',
                    Icons.thermostat,
                    const Color(0xFF60a5fa),
                    () async {
                      _mockService.simulateLowParameter('temperature');
                      await _mockService.checkSingleParameter('temperature');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('🌡️ Alert: Temperatura TROPPO BASSA!')),
                        );
                        setState(() {});
                      }
                    },
                  ),
                  _buildTestButton(
                    'pH Basso',
                    Icons.water_drop,
                    const Color(0xFF60a5fa),
                    () async {
                      _mockService.simulateLowParameter('ph');
                      await _mockService.checkSingleParameter('ph');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('💧 Alert: pH TROPPO BASSO!')),
                        );
                        setState(() {});
                      }
                    },
                  ),
                  _buildTestButton(
                    'Calcio Basso',
                    Icons.science,
                    const Color(0xFF60a5fa),
                    () async {
                      _mockService.simulateLowParameter('calcium');
                      await _mockService.checkSingleParameter('calcium');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('🦴 Alert: Calcio TROPPO BASSO!')),
                        );
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Sezione Test Manutenzione
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF3a3a3a),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.build, color: Color(0xFF34d399), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Test Promemoria Manutenzione',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Testa le notifiche programmate di manutenzione',
                style: TextStyle(color: Colors.white60, fontSize: 13),
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await _mockService.testMaintenanceNotification();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Promemoria manutenzione programmati!'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.schedule),
                  label: const Text('Programma Promemoria'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF34d399),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Sezione Monitoraggio Automatico
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF3a3a3a),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _mockService.isMonitoring ? Icons.play_circle : Icons.pause_circle,
                    color: _mockService.isMonitoring ? const Color(0xFF34d399) : Colors.white60,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Monitoraggio Automatico',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _mockService.isMonitoring 
                    ? 'Il monitoraggio è attivo. I parametri vengono controllati ogni 30 secondi.'
                    : 'Avvia il monitoraggio automatico per simulare il controllo continuo dei parametri.',
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      if (_mockService.isMonitoring) {
                        _mockService.stopAutoMonitoring();
                      } else {
                        _mockService.startAutoMonitoring();
                      }
                    });
                  },
                  icon: Icon(_mockService.isMonitoring ? Icons.stop : Icons.play_arrow),
                  label: Text(_mockService.isMonitoring ? 'Ferma Monitoraggio' : 'Avvia Monitoraggio'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _mockService.isMonitoring 
                        ? const Color(0xFFef4444) 
                        : const Color(0xFF60a5fa),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Reset parametri
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              _mockService.resetToOptimalValues();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Parametri resettati ai valori ottimali')),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Parametri Ottimali'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white60,
              side: const BorderSide(color: Colors.white24),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Dialog per modificare le soglie
  void _showEditThresholdDialog(String name, String unit, ParameterThresholds currentThresholds, Color color) {
    final minController = TextEditingController(text: currentThresholds.min.toString());
    final maxController = TextEditingController(text: currentThresholds.max.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF3a3a3a),
        title: Row(
          children: [
            Icon(Icons.tune, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Modifica Soglie - $name',
                style: const TextStyle(color: Colors.white, fontSize: 17),
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
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Valore Minimo',
                labelStyle: const TextStyle(color: Colors.white60),
                suffixText: unit,
                suffixStyle: TextStyle(color: color),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withValues(alpha:0.2)),
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
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Valore Massimo',
                labelStyle: const TextStyle(color: Colors.white60),
                suffixText: unit,
                suffixStyle: TextStyle(color: color),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withValues(alpha:0.2)),
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
                  Icon(Icons.info_outline, color: color, size: 16),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('⚠️ Inserisci valori numerici validi')),
                );
                return;
              }

              if (newMin >= newMax) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('⚠️ Il minimo deve essere inferiore al massimo')),
                );
                return;
              }

              setState(() {
                _updateThresholds(name, newMin, newMax);
              });

              Navigator.pop(context);
              
              // Salva persistenza
              await _saveSettings();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('✅ Soglie $name aggiornate: $newMin-$newMax$unit')),
              );
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
    _saveSettings(); // Salva automaticamente quando si modifica lo switch
  }

  /// Mostra dialog di conferma per ripristino valori predefiniti
  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF3a3a3a),
        title: const Row(
          children: [
            Icon(Icons.warning_amber, color: Color(0xFFfbbf24), size: 28),
            SizedBox(width: 12),
            Text('Ripristinare Valori Predefiniti?', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Questa azione resetterà tutte le soglie personalizzate ai valori di default:',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 16),
            Text('• Temperatura: 24-26°C', style: TextStyle(color: Colors.white60, fontSize: 12)),
            Text('• pH: 8.0-8.4', style: TextStyle(color: Colors.white60, fontSize: 12)),
            Text('• Salinità: 1.023-1.025', style: TextStyle(color: Colors.white60, fontSize: 12)),
            Text('• E tutti gli altri parametri...', style: TextStyle(color: Colors.white60, fontSize: 12)),
            SizedBox(height: 16),
            Text(
              'Le modifiche verranno salvate immediatamente.',
              style: TextStyle(color: Color(0xFFfbbf24), fontSize: 12, fontWeight: FontWeight.bold),
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
              setState(() {
                _settings = NotificationSettings(); // Reset a default
              });
              _alertManager.updateSettings(_settings);
              await _prefsService.resetToDefaults();
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🔄 Impostazioni ripristinate ai valori predefiniti'),
                  backgroundColor: Color(0xFF34d399),
                ),
              );
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
