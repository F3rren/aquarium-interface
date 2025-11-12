import 'dart:async';
import 'package:flutter/material.dart';
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
          const SizedBox(height: 20),
          _buildHeader(),
          const SizedBox(height: 20),
          _buildHistoryChart(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.surfaceContainerHighest, theme.colorScheme.surface],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.analytics, color: theme.colorScheme.primary, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Grafici Storici', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Analisi andamento parametri nel tempo', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
              ],
            ),
          ),
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
              Icon(Icons.show_chart, color: _getParameterColor(_selectedParameter), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Storico $_selectedParameter',
                      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_chartData.length} punti dati',
                      style: TextStyle(color: _getParameterColor(_selectedParameter).withValues(alpha: 0.8), fontSize: 12),
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
              key: ValueKey('stats_${_selectedParameter}_${_selectedHours}'),
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
              key: ValueKey('${_selectedParameter}_${_selectedHours}'),
              height: 200,
              child: _chartData.isEmpty
                  ? Center(child: Text('Nessun dato disponibile', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)))
                  : LineChart(_buildLineChartData(_chartData, theme)),
            ),
          ),

          const SizedBox(height: 16),

          _buildPeriodTabBar(),

          const SizedBox(height: 12),

          _buildParameterSegmentedButton(),
        ],
      ),
    );
  }

  Widget _buildParameterSegmentedButton() {
    final theme = Theme.of(context);
    final parameters = [
      {'name': 'Temperatura', 'icon': Icons.thermostat, 'color': const Color(0xFFef4444)},
      {'name': 'pH', 'icon': Icons.science_outlined, 'color': const Color(0xFF60a5fa)},
      {'name': 'Salinità', 'icon': Icons.water_outlined, 'color': const Color(0xFF2dd4bf)},
      {'name': 'ORP', 'icon': Icons.bolt, 'color': const Color(0xFFfbbf24)},
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
              final color = param['color'] as Color;
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
}
