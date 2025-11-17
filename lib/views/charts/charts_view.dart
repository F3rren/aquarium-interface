import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:acquariumfe/services/chart_data_service.dart';
import 'package:acquariumfe/models/parameter_data_point.dart';

class ChartsView extends StatefulWidget {
  const ChartsView({super.key});

  @override
  State<ChartsView> createState() => _ChartsViewState();
}

class _ChartsViewState extends State<ChartsView> with SingleTickerProviderStateMixin {
  final ChartDataService _chartService = ChartDataService();
  Timer? _refreshTimer;
  int _selectedHours = 24;
  String _selectedParameter = 'Temperatura';
  List<ParameterDataPoint> _chartData = [];
  Map<String, double> _stats = {};
  bool _isLoading = true;
  
  // Controller per animazioni
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    
    // Inizializza animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _loadChartData();
    // Auto-refresh ogni 30 secondi
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _loadChartData();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadChartData() async {
    // Non mostrare loading se è solo un cambio di filtro
    final wasEmpty = _chartData.isEmpty;
    if (wasEmpty) {
      setState(() => _isLoading = true);
    }
    
    final data = await _chartService.loadHistoricalData(
      parameter: _selectedParameter,
      hours: _selectedHours,
    );
    
    final stats = _chartService.calculateStats(data);
    
    setState(() {
      _chartData = data;
      _stats = stats;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHistoryChart(),
        ],
      ),
    );
  }

  Widget _buildHistoryChart() {
    final theme = Theme.of(context);
    
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(60),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: CircularProgressIndicator(color: theme.colorScheme.primary)),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(FontAwesomeIcons.chartLine, color: _getParameterColor(_selectedParameter), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Storico $_selectedParameter',
                      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Row(
              key: ValueKey('stats_${_selectedParameter}_$_selectedHours'),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: _buildStatChip('Min', _stats['min']?.toStringAsFixed(1) ?? '-', Colors.blue)),
                const SizedBox(width: 4),
                Flexible(child: _buildStatChip('Avg', _stats['avg']?.toStringAsFixed(1) ?? '-', Colors.green)),
                const SizedBox(width: 4),
                Flexible(child: _buildStatChip('Max', _stats['max']?.toStringAsFixed(1) ?? '-', Colors.red)),
                const SizedBox(width: 4),
                Flexible(child: _buildStatChip('Now', _stats['current']?.toStringAsFixed(1) ?? '-', _getParameterColor(_selectedParameter))),
              ],
            ),
          ),

          const SizedBox(height: 20),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                  child: child,
                ),
              );
            },
            child: SizedBox(
              key: ValueKey('${_selectedParameter}_$_selectedHours'),
              height: 200,
              child: _chartData.isEmpty
                  ? Center(child: Text('Nessun dato disponibile', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)))
                  : LineChart(_buildLineChartData(_chartData, theme)),
            ),
          ),

          const SizedBox(height: 12),
          
          // Legenda zone di sicurezza
          _buildSafetyZonesLegend(theme),
          
          const SizedBox(height: 12),
          
          // Statistiche avanzate
          _buildAdvancedStats(theme),

          const SizedBox(height: 16),

          _buildPeriodTabBar(),

          const SizedBox(height: 12),

          _buildParameterSegmentedButton(),
        ],
      ),
    );
  }
  
  Widget _buildSafetyZonesLegend(ThemeData theme) {
    final ranges = _getParameterRanges(_selectedParameter);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem(
            icon: FontAwesomeIcons.circleCheck,
            color: const Color(0xFF10b981),
            label: 'Ideale',
            value: '${ranges['ideal_min']!.toStringAsFixed(1)} - ${ranges['ideal_max']!.toStringAsFixed(1)}',
            theme: theme,
          ),
          _buildLegendItem(
            icon: FontAwesomeIcons.triangleExclamation,
            color: const Color(0xFFfbbf24),
            label: 'Avviso',
            value: '${ranges['warning_min']!.toStringAsFixed(1)} - ${ranges['warning_max']!.toStringAsFixed(1)}',
            theme: theme,
          ),
        ],
      ),
    );
  }
  
  Widget _buildLegendItem({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildAdvancedStats(ThemeData theme) {
    if (_chartData.isEmpty) return const SizedBox();
    
    final trend = _calculateTrend();
    final stability = _calculateStability();
    final advice = _getAdvice(trend, stability);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surfaceContainerHighest,
            theme.colorScheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getParameterColor(_selectedParameter).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.chartLine,
                color: _getParameterColor(_selectedParameter),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Analisi Avanzata',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAnalysisItem(
                  icon: trend['icon'] as IconData,
                  label: 'Trend',
                  value: trend['text'] as String,
                  color: trend['color'] as Color,
                  theme: theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnalysisItem(
                  icon: FontAwesomeIcons.chartLine,
                  label: 'Stabilità',
                  value: stability['text'] as String,
                  color: stability['color'] as Color,
                  theme: theme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: advice['color'].withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: advice['color'].withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  advice['icon'] as IconData,
                  color: advice['color'] as Color,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    advice['text'] as String,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnalysisItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Map<String, dynamic> _calculateTrend() {
    if (_chartData.length < 2) {
      return {
        'icon': FontAwesomeIcons.arrowRight,
        'text': 'Stabile',
        'color': const Color(0xFF6b7280),
      };
    }
    
    // Calcola trend tra prima metà e seconda metà dei dati
    final midPoint = _chartData.length ~/ 2;
    final firstHalfAvg = _chartData.sublist(0, midPoint).map((e) => e.value).reduce((a, b) => a + b) / midPoint;
    final secondHalfAvg = _chartData.sublist(midPoint).map((e) => e.value).reduce((a, b) => a + b) / (_chartData.length - midPoint);
    
    final diff = secondHalfAvg - firstHalfAvg;
    final diffPercent = (diff / firstHalfAvg * 100).abs();
    
    if (diffPercent < 1) {
      return {
        'icon': FontAwesomeIcons.arrowRight,
        'text': 'Stabile',
        'color': const Color(0xFF10b981),
      };
    } else if (diff > 0) {
      return {
        'icon': FontAwesomeIcons.arrowTrendUp,
        'text': 'In aumento',
        'color': const Color(0xFFef4444),
      };
    } else {
      return {
        'icon': FontAwesomeIcons.arrowTrendDown,
        'text': 'In calo',
        'color': const Color(0xFF3b82f6),
      };
    }
  }
  
  Map<String, dynamic> _calculateStability() {
    if (_chartData.isEmpty) return {'text': '-', 'color': const Color(0xFF6b7280)};
    
    final values = _chartData.map((e) => e.value).toList();
    final avg = values.reduce((a, b) => a + b) / values.length;
    
    // Calcola deviazione standard
    final variance = values.map((v) => (v - avg) * (v - avg)).reduce((a, b) => a + b) / values.length;
    final stdDev = variance > 0 ? (variance).abs().toDouble() : 0.0;
    
    // Determina stabilità basata su deviazione standard relativa
    final relativeStdDev = (stdDev / avg * 100).abs();
    
    if (relativeStdDev < 2) {
      return {
        'text': 'Ottima',
        'color': const Color(0xFF10b981),
      };
    } else if (relativeStdDev < 5) {
      return {
        'text': 'Buona',
        'color': const Color(0xFF22c55e),
      };
    } else if (relativeStdDev < 10) {
      return {
        'text': 'Media',
        'color': const Color(0xFFfbbf24),
      };
    } else {
      return {
        'text': 'Bassa',
        'color': const Color(0xFFef4444),
      };
    }
  }
  
  Map<String, dynamic> _getAdvice(Map<String, dynamic> trend, Map<String, dynamic> stability) {
    final ranges = _getParameterRanges(_selectedParameter);
    final current = _stats['current'] ?? 0.0;
    
    // Controlla se fuori range critico
    if (current < ranges['warning_min']! || current > ranges['warning_max']!) {
      return {
        'icon': FontAwesomeIcons.triangleExclamation,
        'text': 'Attenzione: $_selectedParameter fuori range. Controlla subito e correggi.',
        'color': const Color(0xFFef4444),
      };
    }
    
    // Controlla se fuori range ideale
    if (current < ranges['ideal_min']! || current > ranges['ideal_max']!) {
      return {
        'icon': FontAwesomeIcons.circleInfo,
        'text': 'Parametro accettabile ma non ideale. Monitora attentamente.',
        'color': const Color(0xFFfbbf24),
      };
    }
    
    // Controlla stabilità
    final stabilityText = stability['text'] as String;
    if (stabilityText.contains('Bassa')) {
      return {
        'icon': FontAwesomeIcons.lightbulb,
        'text': 'Parametro instabile. Verifica cambio acqua e dosaggi additivi.',
        'color': const Color(0xFFfbbf24),
      };
    }
    
    // Controlla trend
    final trendIcon = trend['icon'] as IconData;
    if (trendIcon == FontAwesomeIcons.arrowTrendUp && _selectedParameter == 'Temperatura') {
      return {
        'icon': FontAwesomeIcons.snowflake,
        'text': 'Temperatura in aumento. Verifica raffreddamento e ventilazione.',
        'color': const Color(0xFF3b82f6),
      };
    }
    
    // Tutto ok
    return {
      'icon': FontAwesomeIcons.circleCheck,
      'text': 'Parametro ottimale e stabile.',
      'color': const Color(0xFF10b981),
    };
  }

  Widget _buildParameterSegmentedButton() {
    final theme = Theme.of(context);
    final parameters = [
      {'name': 'Temperatura', 'icon': FontAwesomeIcons.temperatureHalf, 'color': const Color(0xFFef4444)},
      {'name': 'pH', 'icon': FontAwesomeIcons.flask, 'color': const Color(0xFF60a5fa)},
      {'name': 'Salinità', 'icon': FontAwesomeIcons.water, 'color': const Color(0xFF2dd4bf)},
      {'name': 'ORP', 'icon': FontAwesomeIcons.bolt, 'color': const Color(0xFFfbbf24)},
    ];
    
    final selectedIndex = parameters.indexWhere((p) => p['name'] == _selectedParameter);
    
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          // Indicator animato
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            alignment: selectedIndex == 0 
                ? Alignment.centerLeft
                : selectedIndex == 1
                    ? const Alignment(-0.33, 0)
                    : selectedIndex == 2
                        ? const Alignment(0.33, 0)
                        : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 1 / 4,
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (parameters[selectedIndex]['color'] as Color).withValues(alpha: 0.8),
                      (parameters[selectedIndex]['color'] as Color),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (parameters[selectedIndex]['color'] as Color).withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Pulsanti
          Row(
            children: parameters.map((param) {
              final name = param['name'] as String;
              final icon = param['icon'] as IconData;
              final isSelected = _selectedParameter == name;
              
              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (_selectedParameter != name) {
                        setState(() => _selectedParameter = name);
                        _loadChartData();
                      }
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            child: Icon(
                              icon,
                              color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
                              size: isSelected ? 22 : 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            style: TextStyle(
                              color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontSize: 11,
                            ),
                            child: Text(name),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 10)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Text(
            value,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodTabBar() {
    final theme = Theme.of(context);
    final periods = [
      {'label': '24 ore', 'hours': 24},
      {'label': '7 giorni', 'hours': 168},
      {'label': '30 giorni', 'hours': 720},
    ];
    
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Indicator animato
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            alignment: _selectedHours == 24 
                ? Alignment.centerLeft
                : _selectedHours == 168
                    ? Alignment.center
                    : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 1 / 3,
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Pulsanti
          Row(
            children: periods.map((period) {
              final hours = period['hours'] as int;
              final isSelected = _selectedHours == hours;
              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (_selectedHours != hours) {
                        setState(() => _selectedHours = hours);
                        _loadChartData();
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      alignment: Alignment.center,
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        style: TextStyle(
                          color: isSelected 
                              ? Colors.white 
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 14,
                        ),
                        child: Text(period['label'] as String),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  LineChartData _buildLineChartData(List<ParameterDataPoint> data, ThemeData theme) {
    // Se non ci sono dati, crea un grafico vuoto
    if (data.isEmpty) {
      return LineChartData(
        lineBarsData: [],
        minY: 0,
        maxY: 10,
        minX: 0,
        maxX: 1,
      );
    }

    final spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();
    
    // Ottieni i range per il parametro selezionato
    final ranges = _getParameterRanges(_selectedParameter);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) => FlLine(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          strokeWidth: 1,
        ),
      ),
      // Aggiungi zone di sicurezza
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          // Zona ideale (verde)
          HorizontalLine(
            y: ranges['ideal_min']!,
            color: const Color(0xFF10b981).withValues(alpha: 0.3),
            strokeWidth: 0,
            label: HorizontalLineLabel(
              show: true,
              alignment: Alignment.topRight,
              padding: const EdgeInsets.only(right: 4, bottom: 2),
              style: TextStyle(
                color: const Color(0xFF10b981),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              labelResolver: (line) => 'Ideale',
            ),
          ),
          // Linea warning superiore
          HorizontalLine(
            y: ranges['warning_max']!,
            color: const Color(0xFFfbbf24).withValues(alpha: 0.6),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
          // Linea warning inferiore
          HorizontalLine(
            y: ranges['warning_min']!,
            color: const Color(0xFFfbbf24).withValues(alpha: 0.6),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ],
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              if (data.isEmpty || value.toInt() >= data.length) return const SizedBox();
              final interval = data.length > 6 ? (data.length ~/ 6) : 1;
              if (value.toInt() % interval != 0) return const SizedBox();
              final point = data[value.toInt()];
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${point.timestamp.hour}:${point.timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 10),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) => Text(
              value.toStringAsFixed(1),
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 10),
            ),
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              if (spot.x.toInt() >= data.length) return null;
              final point = data[spot.x.toInt()];
              return LineTooltipItem(
                '${point.value}\n${point.timestamp.hour}:${point.timestamp.minute.toString().padLeft(2, '0')}',
                TextStyle(color: theme.colorScheme.onSurface, fontSize: 12),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        // Area di sfondo per zona ideale
        LineChartBarData(
          spots: [
            FlSpot(0, ranges['ideal_min']!),
            FlSpot(spots.length.toDouble() - 1, ranges['ideal_min']!),
          ],
          isCurved: false,
          color: Colors.transparent,
          barWidth: 0,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xFF10b981).withValues(alpha: 0.08),
            cutOffY: ranges['ideal_max']!,
            applyCutOffY: true,
          ),
        ),
        // Linea dati principale
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: _getParameterColor(_selectedParameter),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: _getParameterColor(_selectedParameter).withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  Color _getParameterColor(String parameter) {
    switch (parameter) {
      case 'Temperatura':
        return const Color(0xFFef4444);
      case 'pH':
        return const Color(0xFF60a5fa);
      case 'Salinità':
        return const Color(0xFF2dd4bf);
      case 'ORP':
        return const Color(0xFFfbbf24);
      default:
        return const Color(0xFF60a5fa);
    }
  }
  
  /// Restituisce i range ideali e di warning per ogni parametro
  Map<String, double> _getParameterRanges(String parameter) {
    switch (parameter) {
      case 'Temperatura':
        return {
          'ideal_min': 24.0,
          'ideal_max': 27.0,
          'warning_min': 23.0,
          'warning_max': 28.0,
          'critical_min': 22.0,
          'critical_max': 29.0,
        };
      case 'pH':
        return {
          'ideal_min': 8.0,
          'ideal_max': 8.3,
          'warning_min': 7.8,
          'warning_max': 8.4,
          'critical_min': 7.6,
          'critical_max': 8.6,
        };
      case 'Salinità':
        return {
          'ideal_min': 1023.0,
          'ideal_max': 1026.0,
          'warning_min': 1021.0,
          'warning_max': 1027.0,
          'critical_min': 1019.0,
          'critical_max': 1029.0,
        };
      case 'ORP':
        return {
          'ideal_min': 300.0,
          'ideal_max': 400.0,
          'warning_min': 250.0,
          'warning_max': 450.0,
          'critical_min': 200.0,
          'critical_max': 500.0,
        };
      default:
        return {
          'ideal_min': 0.0,
          'ideal_max': 10.0,
          'warning_min': 0.0,
          'warning_max': 10.0,
          'critical_min': 0.0,
          'critical_max': 10.0,
        };
    }
  }
}

