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

class _ChartsViewState extends State<ChartsView> {
  final ChartDataService _chartService = ChartDataService();
  Timer? _refreshTimer;
  int _selectedHours = 24;
  String _selectedParameter = 'Temperatura';
  List<ParameterDataPoint> _chartData = [];
  Map<String, double> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChartData();
    // Auto-refresh ogni 30 secondi
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _loadChartData();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadChartData() async {
    setState(() => _isLoading = true);
    
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

          Row(
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

          const SizedBox(height: 20),

          SizedBox(
            height: 200,
            child: _chartData.isEmpty
                ? Center(child: Text('Nessun dato disponibile', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)))
                : LineChart(_buildLineChartData(_chartData, theme)),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: _buildPeriodButton('24h', 24)),
              const SizedBox(width: 8),
              Expanded(child: _buildPeriodButton('7gg', 168)),
              const SizedBox(width: 8),
              Expanded(child: _buildPeriodButton('30gg', 720)),
            ],
          ),

          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildParameterChip('Temperatura', Icons.thermostat, const Color(0xFFef4444)),
                const SizedBox(width: 8),
                _buildParameterChip('pH', Icons.science_outlined, const Color(0xFF60a5fa)),
                const SizedBox(width: 8),
                _buildParameterChip('Salinità', Icons.water_outlined, const Color(0xFF2dd4bf)),
                const SizedBox(width: 8),
                _buildParameterChip('ORP', Icons.bolt, const Color(0xFFfbbf24)),
              ],
            ),
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

  Widget _buildPeriodButton(String label, int hours) {
    final theme = Theme.of(context);
    final isSelected = _selectedHours == hours;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedHours = hours);
        _loadChartData();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParameterChip(String name, IconData icon, Color color) {
    final theme = Theme.of(context);
    final isSelected = _selectedParameter == name;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedParameter = name);
        _loadChartData();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.3) : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? color : theme.colorScheme.onSurface.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? color : theme.colorScheme.onSurfaceVariant, size: 18),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                color: isSelected ? color : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
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
