import 'dart:async';
import 'package:flutter/material.dart';
import 'package:acquariumfe/services/alert_manager.dart';
import 'package:acquariumfe/services/parameter_service.dart';
import 'package:acquariumfe/services/notification_preferences_service.dart';
import 'package:acquariumfe/models/aquarium_parameters.dart';
import 'package:acquariumfe/models/notification_settings.dart';

class HealthDashboard extends StatefulWidget {
  const HealthDashboard({super.key});

  @override
  State<HealthDashboard> createState() => _HealthDashboardState();
}

class _HealthDashboardState extends State<HealthDashboard> {
  final AlertManager _alertManager = AlertManager();
  final ParameterService _parameterService = ParameterService();
  final NotificationPreferencesService _prefsService = NotificationPreferencesService();
  Timer? _refreshTimer;
  AquariumParameters? _currentParams;
  NotificationSettings _settings = NotificationSettings();
  
  @override
  void initState() {
    super.initState();
    _loadParameters();
    _loadSettings();
    // Avvia auto-refresh se non già attivo
    if (!_parameterService.isAutoRefreshEnabled) {
      _parameterService.startAutoRefresh(interval: const Duration(seconds: 10));
    }
    // Auto-refresh UI ogni 3 secondi
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _loadParameters();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadParameters() async {
    final params = await _parameterService.getCurrentParameters(useMock: false);
    setState(() {
      _currentParams = params;
    });
  }
  
  Future<void> _loadSettings() async {
    final settings = await _prefsService.loadSettings();
    setState(() {
      _settings = settings;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Usa dati di fallback se non ancora caricati
    final currentTemperature = _currentParams?.temperature ?? 25.0;
    final currentPh = _currentParams?.ph ?? 8.2;
    final currentSalinity = _currentParams?.salinity ?? 1.024;
    final currentOrp = _currentParams?.orp ?? 350.0;
    final calcium = _currentParams?.calcium ?? 420.0;
    final magnesium = _currentParams?.magnesium ?? 1280.0;
    final kh = _currentParams?.kh ?? 9.0;
    final nitrate = _currentParams?.nitrate ?? 5.0;
    final phosphate = _currentParams?.phosphate ?? 0.03;
    
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
    
    final healthScore = ((parametersInRange / totalParameters) * 100).round();
    final statusMessage = healthScore >= 80 ? "TUTTO OK" : healthScore >= 60 ? "ATTENZIONE" : "CRITICO";
    final statusColor = healthScore >= 80 ? const Color(0xFF34d399) : healthScore >= 60 ? const Color(0xFFfbbf24) : const Color(0xFFef4444);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Card - Check Status
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [statusColor.withValues(alpha:0.3), const Color(0xFF3a3a3a)]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withValues(alpha:0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Stato Acquario',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  statusMessage,
                  style: TextStyle(color: statusColor, fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'Aggiornato ora • $parametersInRange/$totalParameters parametri OK',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Parametri principali
          Row(
            children: [
              Expanded(child: _buildParamCard('Temperatura', '$currentTemperature°C', Icons.thermostat, 
                const Color(0xFFef4444), settings.temperature.isOutOfRange(currentTemperature))),
              const SizedBox(width: 12),
              Expanded(child: _buildParamCard('pH', currentPh.toString(), Icons.science_outlined, 
                const Color(0xFF60a5fa), settings.ph.isOutOfRange(currentPh))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildParamCard('Salinità', currentSalinity.toString(), Icons.water_outlined, 
                const Color(0xFF2dd4bf), settings.salinity.isOutOfRange(currentSalinity))),
              const SizedBox(width: 12),
              Expanded(child: _buildParamCard('ORP', '${currentOrp.toInt()} mV', Icons.bolt, 
                const Color(0xFFfbbf24), settings.orp.isOutOfRange(currentOrp))),
            ],
          ),
          
          const SizedBox(height: 20),
          _buildHealthScore(healthScore, parametersInRange, totalParameters),
          const SizedBox(height: 20),
          _buildQuickStats(parametersInRange, totalParameters - parametersInRange, recentAlerts.length),
          
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
  }

  Widget _buildParamCard(String label, String value, IconData icon, Color color, bool isOutOfRange) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3a3a3a),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isOutOfRange ? const Color(0xFFef4444) : Colors.white.withValues(alpha:0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const Spacer(),
              if (isOutOfRange) const Icon(Icons.warning_amber, color: Color(0xFFef4444), size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: isOutOfRange ? const Color(0xFFef4444) : Colors.white, 
            fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildHealthScore(int score, int okParams, int totalParams) {
    final color = score >= 80 ? const Color(0xFF34d399) : score >= 60 ? const Color(0xFFfbbf24) : const Color(0xFFef4444);
    final label = score >= 80 ? 'Eccellente' : score >= 60 ? 'Buono' : 'Critico';
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF4a4a4a), Color(0xFF3a3a3a)]),
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
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                Center(
                  child: Text('$score', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Health Score', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(label, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('$okParams/$totalParams parametri nel range ottimale', 
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(int okParams, int criticalParams, int alerts) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Parametri OK', '$okParams', Icons.check_circle, const Color(0xFF34d399))),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Critici', '$criticalParams', Icons.warning_amber, const Color(0xFFef4444))),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Alert', '$alerts', Icons.notifications_active, const Color(0xFFfbbf24))),
      ],
    );
  }

  Widget _buildCriticalAlerts(List alerts) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3a3a3a),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFef4444).withValues(alpha:0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber, color: Color(0xFFef4444), size: 20),
              SizedBox(width: 8),
              Text('Alert Recenti', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          ...alerts.map((alert) => Padding(
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
                      Text(alert.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      Text(alert.message, style: const TextStyle(color: Colors.white60, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMaintenanceReminders() {
    final reminders = [
      {'title': 'Cambio Acqua', 'days': _settings.maintenanceReminders.waterChange.frequencyDays, 'icon': Icons.water_drop},
      {'title': 'Pulizia Filtro', 'days': _settings.maintenanceReminders.filterCleaning.frequencyDays, 'icon': Icons.filter_alt},
      {'title': 'Test Parametri', 'days': _settings.maintenanceReminders.parameterTesting.frequencyDays, 'icon': Icons.science},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3a3a3a),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha:0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_today, color: Color(0xFF60a5fa), size: 20),
              SizedBox(width: 8),
              Text('Prossimi Promemoria', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          ...reminders.map((reminder) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF60a5fa).withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(reminder['icon'] as IconData, color: const Color(0xFF60a5fa), size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(reminder['title'] as String, 
                    style: const TextStyle(color: Colors.white, fontSize: 13)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF60a5fa).withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('${reminder['days']} gg', 
                    style: const TextStyle(color: Color(0xFF60a5fa), fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3a3a3a),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildRecommendations(int healthScore, int parametersInRange) {
    final recommendations = <Map<String, dynamic>>[];
    
    if (healthScore < 80) {
      recommendations.add({
        'title': 'Controllare parametri fuori range',
        'desc': '${9 - parametersInRange} parametri necessitano attenzione',
        'icon': Icons.warning_amber,
        'urgent': true
      });
    }
    
    recommendations.addAll([
      {'title': 'Controllare skimmer', 'desc': 'Pulizia settimanale consigliata', 'icon': Icons.cleaning_services, 'urgent': false},
      {'title': 'Test KH', 'desc': 'Ultimo test: 3 giorni fa', 'icon': Icons.science, 'urgent': false},
    ]);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3a3a3a),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Raccomandazioni', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          ...recommendations.map((rec) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF2d2d2d),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (rec['urgent'] as bool ? const Color(0xFFfbbf24) : const Color(0xFF60a5fa)).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(rec['icon'] as IconData, color: rec['urgent'] as bool ? const Color(0xFFfbbf24) : const Color(0xFF60a5fa), size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rec['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(rec['desc'] as String, style: const TextStyle(color: Colors.white60, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
