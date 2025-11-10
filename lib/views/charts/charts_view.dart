import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:acquariumfe/services/parameter_history_service.dart';
import 'package:acquariumfe/models/parameter_data_point.dart';

class ChartsView extends StatefulWidget {
  const ChartsView({super.key});

  @override
  State<ChartsView> createState() => _ChartsViewState();
}

class _ChartsViewState extends State<ChartsView> {
  final ParameterHistoryService _historyService = ParameterHistoryService();
  int _selectedHours = 24;
  String _selectedParameter = 'Temperatura';

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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4a4a4a), Color(0xFF3a3a3a)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF60a5fa).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.analytics, color: Color(0xFF60a5fa), size: 32),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Grafici Storici', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Analisi andamento parametri nel tempo', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryChart() {
    final history = _historyService.getAllParametersHistory(hours: _selectedHours);
    final selectedData = history[_selectedParameter] ?? [];
    final stats = _historyService.calculateStats(selectedData);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4a4a4a), Color(0xFF3a3a3a)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
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
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${stats.trend.emoji} ${stats.trend.label} • ${stats.dataPoints} punti',
                      style: TextStyle(color: _getParameterColor(_selectedParameter).withValues(alpha: 0.8), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatChip('Min', stats.min.toString(), Colors.blue),
              _buildStatChip('Avg', stats.average.toString(), Colors.green),
              _buildStatChip('Max', stats.max.toString(), Colors.red),
              _buildStatChip('Now', stats.current.toString(), _getParameterColor(_selectedParameter)),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 200,
            child: selectedData.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : LineChart(_buildLineChartData(selectedData)),
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
        Text(label, style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 11)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Text(
            value,
            style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodButton(String label, int hours) {
    final isSelected = _selectedHours == hours;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedHours = hours;
        _historyService.clearCache();
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF60a5fa) : const Color(0xFF3a3a3a),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF60a5fa) : Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white60,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParameterChip(String name, IconData icon, Color color) {
    final isSelected = _selectedParameter == name;
    return GestureDetector(
      onTap: () => setState(() => _selectedParameter = name),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.3) : const Color(0xFF3a3a3a),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? color : Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? color : Colors.white60, size: 18),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                color: isSelected ? color : Colors.white60,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildLineChartData(List<ParameterDataPoint> data) {
    final spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.white.withValues(alpha: 0.1),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= data.length) return const SizedBox();
              if (value.toInt() % (data.length ~/ 6) != 0) return const SizedBox();
              final point = data[value.toInt()];
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${point.timestamp.hour}:${point.timestamp.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.white60, fontSize: 10),
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
              style: const TextStyle(color: Colors.white60, fontSize: 10),
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
                const TextStyle(color: Colors.white, fontSize: 12),
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
