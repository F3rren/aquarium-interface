import 'package:flutter/material.dart';

class CalculatorsPage extends StatefulWidget {
  const CalculatorsPage({super.key});

  @override
  State<CalculatorsPage> createState() => _CalculatorsPageState();
}

class _CalculatorsPageState extends State<CalculatorsPage> {
  // Calcolo Volume
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  double? _volumeResult;

  // Calcolo Dosaggio Additivi
  final TextEditingController _tankVolumeController = TextEditingController();
  final TextEditingController _currentValueController = TextEditingController();
  final TextEditingController _targetValueController = TextEditingController();
  String _selectedAdditive = 'Calcio';
  double? _additiveResult;
  String _resultUnit = 'g';

  // Calcolo Cambio Acqua
  final TextEditingController _tankVolumeWaterController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController();
  double? _waterChangeResult;
  double? _saltNeeded;

  // Calcolo Densità/Salinità
  final TextEditingController _densityController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  double? _salinityPPT;
  double? _salinityPPM;
  double? _specificGravity;
  String _conversionMode = 'density_to_salinity'; // density_to_salinity | salinity_to_density

  // Calcolo Illuminazione
  final TextEditingController _lightVolumeController = TextEditingController();
  final TextEditingController _wattsController = TextEditingController();
  String _tankType = 'Solo Pesci';
  double? _wattsPerLiter;
  String? _lightRecommendation;

  @override
  void dispose() {
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _tankVolumeController.dispose();
    _currentValueController.dispose();
    _targetValueController.dispose();
    _tankVolumeWaterController.dispose();
    _percentageController.dispose();
    _densityController.dispose();
    _temperatureController.dispose();
    _lightVolumeController.dispose();
    _wattsController.dispose();
    super.dispose();
  }

  void _calculateVolume() {
    final length = double.tryParse(_lengthController.text);
    final width = double.tryParse(_widthController.text);
    final height = double.tryParse(_heightController.text);

    if (length != null && width != null && height != null) {
      setState(() {
        // Formula: L x W x H (in cm) / 1000 = litri
        _volumeResult = (length * width * height) / 1000;
      });
    }
  }

  void _calculateAdditive() {
    final volume = double.tryParse(_tankVolumeController.text);
    final current = double.tryParse(_currentValueController.text);
    final target = double.tryParse(_targetValueController.text);

    if (volume != null && current != null && target != null) {
      setState(() {
        final difference = (current - target).abs();
        final isReduction = _selectedAdditive.contains('NO3') || 
                           _selectedAdditive.contains('PO4') || 
                           _selectedAdditive.contains('Carbonio');
        
        // Se è riduzione e target >= current, non calcolare
        if (isReduction && target >= current) {
          _additiveResult = null;
          return;
        }
        
        // Se è dosaggio e target <= current, non calcolare
        if (!isReduction && target <= current) {
          _additiveResult = null;
          return;
        }
        
        // Formula semplificata: dipende dal prodotto, qui uso coefficienti medi
        double coefficient;
        
        switch (_selectedAdditive) {
          case 'Calcio':
            coefficient = 0.05; // grammi per litro per 1 mg/L di aumento
            _resultUnit = 'g';
            break;
          case 'Magnesio':
            coefficient = 0.08;
            _resultUnit = 'g';
            break;
          case 'KH':
            coefficient = 0.3;
            _resultUnit = 'g';
            break;
          case 'Iodio':
            coefficient = 0.01;
            _resultUnit = 'g';
            break;
          case 'Stronzio':
            coefficient = 0.02;
            _resultUnit = 'g';
            break;
          case 'Nitrati (NO3)':
          case 'Fosfati (PO4)':
            coefficient = 0.0; // Mostrerà solo consigli
            break;
          case 'NO3:PO4-X (Red Sea)':
            // Red Sea NO3:PO4-X: 1 ml per 25L riduce ~0.5 ppm NO3
            coefficient = volume / 25.0; // ml per ppm di riduzione
            _resultUnit = 'ml';
            break;
          case 'Carbonio Attivo':
            // Carbonio liquido: ~2 ml per 50L riducono ~1 ppm NO3
            coefficient = (volume / 50.0) * 2;
            _resultUnit = 'ml';
            break;
          default:
            coefficient = 0.05;
            _resultUnit = 'g';
        }
        
        if (coefficient > 0) {
          _additiveResult = difference * coefficient;
        } else {
          _additiveResult = null; // Per parametri che mostrano solo consigli
        }
      });
    }
  }

  void _calculateWaterChange() {
    final volume = double.tryParse(_tankVolumeWaterController.text);
    final percentage = double.tryParse(_percentageController.text);

    if (volume != null && percentage != null && percentage > 0 && percentage <= 100) {
      setState(() {
        _waterChangeResult = (volume * percentage) / 100;
        // Sale necessario: ~35g/L per salinità 1.025
        _saltNeeded = _waterChangeResult! * 35;
      });
    }
  }

  void _calculateDensitySalinity() {
    final temp = double.tryParse(_temperatureController.text) ?? 25.0;
    
    if (_conversionMode == 'density_to_salinity') {
      final density = double.tryParse(_densityController.text);
      if (density != null && density >= 1.020 && density <= 1.030) {
        setState(() {
          // Formula approssimata: Salinità (ppt) = (Densità - 1) * 1000 * 1.3
          _salinityPPT = (density - 1.0) * 1300;
          _salinityPPM = _salinityPPT! * 1000;
          _specificGravity = density;
        });
      }
    } else {
      // salinity_to_density
      final salinity = double.tryParse(_densityController.text);
      if (salinity != null && salinity >= 30 && salinity <= 40) {
        setState(() {
          _salinityPPT = salinity;
          _salinityPPM = salinity * 1000;
          // Formula inversa: Densità = (Salinità / 1300) + 1
          _specificGravity = (salinity / 1300) + 1.0;
        });
      }
    }
  }

  void _calculateLighting() {
    final volume = double.tryParse(_lightVolumeController.text);
    final watts = double.tryParse(_wattsController.text);

    if (volume != null && watts != null && volume > 0) {
      setState(() {
        _wattsPerLiter = watts / volume;
        
        // Raccomandazioni basate sul tipo di vasca
        if (_tankType == 'Solo Pesci') {
          if (_wattsPerLiter! < 0.25) {
            _lightRecommendation = 'Insufficiente - Minimo 0.25 W/L per pesci';
          } else if (_wattsPerLiter! <= 0.5) {
            _lightRecommendation = 'Ottimale per vasca di soli pesci';
          } else {
            _lightRecommendation = 'Eccessivo - Rischio alghe';
          }
        } else if (_tankType == 'Pesci + Coralli Molli') {
          if (_wattsPerLiter! < 0.5) {
            _lightRecommendation = 'Insufficiente - Minimo 0.5 W/L';
          } else if (_wattsPerLiter! <= 1.0) {
            _lightRecommendation = 'Ottimale per coralli molli (LPS)';
          } else {
            _lightRecommendation = 'Molto buono - Adatto anche SPS';
          }
        } else {
          // Coralli SPS
          if (_wattsPerLiter! < 1.0) {
            _lightRecommendation = 'Insufficiente - Minimo 1.0 W/L per SPS';
          } else if (_wattsPerLiter! <= 1.5) {
            _lightRecommendation = 'Ottimale per coralli SPS';
          } else {
            _lightRecommendation = 'Molto potente - Ottimo per SPS esigenti';
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Calcolatori', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),
          
          // CALCOLO VOLUME
          _buildCalculatorCard(
            title: 'Calcolo Volume Acquario',
            icon: Icons.square_foot,
            color: theme.colorScheme.primary,
            child: Column(
              children: [
                Text(
                  'Inserisci le dimensioni dell\'acquario in centimetri',
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _buildInputField('Lunghezza (cm)', _lengthController, Icons.straighten),
                const SizedBox(height: 12),
                _buildInputField('Larghezza (cm)', _widthController, Icons.straighten),
                const SizedBox(height: 12),
                _buildInputField('Altezza (cm)', _heightController, Icons.height),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateVolume,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Calcola Volume', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
                if (_volumeResult != null) ...[
                  const SizedBox(height: 20),
                  _buildResult(
                    'Volume Totale',
                    '${_volumeResult!.toStringAsFixed(1)} L',
                    theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Volume netto stimato: ${(_volumeResult! * 0.85).toStringAsFixed(1)} L',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '(considerando rocce e substrato)',
                    style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.4), fontSize: 11, fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // CALCOLO DOSAGGIO ADDITIVI
          _buildCalculatorCard(
            title: 'Calcolo Dosaggio Additivi',
            icon: Icons.science,
            color: theme.colorScheme.tertiary,
            child: Column(
              children: [
                Text(
                  'Calcola la quantità di additivo da dosare',
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedAdditive,
                      isExpanded: true,
                      dropdownColor: theme.colorScheme.surfaceContainerHighest,
                      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 15),
                      items: [
                        DropdownMenuItem(
                          enabled: false,
                          child: Text('── DOSAGGIO ──', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
                        ),
                        ...['Calcio', 'Magnesio', 'KH', 'Iodio', 'Stronzio'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(value),
                            ),
                          );
                        }),
                        DropdownMenuItem(
                          enabled: false,
                          child: Text('── RIDUZIONE ──', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
                        ),
                        ...['Nitrati (NO3)', 'Fosfati (PO4)', 'NO3:PO4-X (Red Sea)', 'Carbonio Attivo'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(value, style: const TextStyle(fontSize: 14)),
                            ),
                          );
                        }),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedAdditive = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildInputField('Volume acquario (L)', _tankVolumeController, Icons.water),
                const SizedBox(height: 12),
                _buildInputField(
                  'Valore attuale (${_getUnit()})',
                  _currentValueController,
                  Icons.show_chart,
                ),
                const SizedBox(height: 12),
                _buildInputField(
                  'Valore target (${_getUnit()})',
                  _targetValueController,
                  Icons.flag,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateAdditive,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Calcola Dosaggio', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
                if (_additiveResult != null) ...[
                  const SizedBox(height: 20),
                  _buildResult(
                    _selectedAdditive.contains('NO3:PO4-X') || _selectedAdditive.contains('Carbonio')
                        ? 'Quantità da dosare (riduzione)'
                        : 'Quantità da dosare',
                    '${_additiveResult!.toStringAsFixed(2)} $_resultUnit',
                    theme.colorScheme.tertiary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '⚠️ Valori indicativi: verifica le istruzioni del produttore',
                    style: TextStyle(color: Colors.orange, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ] else if (_selectedAdditive == 'Nitrati (NO3)' || _selectedAdditive == 'Fosfati (PO4)') ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.orange, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          _selectedAdditive == 'Nitrati (NO3)' 
                            ? 'Per ridurre i Nitrati:\n• Cambio acqua regolare (20% settimanale)\n• Skimmer efficiente\n• Refill osmosi\n• Carbonio attivo liquido\n• NO3:PO4-X (Red Sea)'
                            : 'Per ridurre i Fosfati:\n• Resine anti-fosfati (GFO)\n• Skimmer efficiente\n• Cambio acqua regolare\n• NO3:PO4-X (Red Sea)\n• Evitare sovralimentazione',
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // CALCOLO CAMBIO ACQUA
          _buildCalculatorCard(
            title: 'Calcolo Cambio Acqua',
            icon: Icons.water_drop,
            color: theme.colorScheme.secondary,
            child: Column(
              children: [
                Text(
                  'Calcola litri e sale necessario per il cambio acqua',
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _buildInputField('Volume acquario (L)', _tankVolumeWaterController, Icons.water),
                const SizedBox(height: 12),
                _buildInputField('Percentuale cambio (%)', _percentageController, Icons.percent),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateWaterChange,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Calcola', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
                if (_waterChangeResult != null) ...[
                  const SizedBox(height: 20),
                  _buildResult(
                    'Acqua da cambiare',
                    '${_waterChangeResult!.toStringAsFixed(1)} L',
                    theme.colorScheme.secondary,
                  ),
                  const SizedBox(height: 12),
                  _buildResult(
                    'Sale necessario',
                    '${_saltNeeded!.toStringAsFixed(0)} g',
                    theme.colorScheme.secondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Calcolato per salinità 1.025 (35g/L)',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // CALCOLO DENSITÀ/SALINITÀ
          _buildCalculatorCard(
            title: 'Conversione Densità/Salinità',
            icon: Icons.science,
            color: theme.colorScheme.tertiary,
            child: Column(
              children: [
                Text(
                  'Converti tra densità e salinità',
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Selettore modalità
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.tertiary.withValues(alpha: 0.3)),
                  ),
                  child: DropdownButton<String>(
                    value: _conversionMode,
                    isExpanded: true,
                    dropdownColor: theme.colorScheme.surfaceContainerHighest,
                    underline: const SizedBox(),
                    style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 15),
                    items: const [
                      DropdownMenuItem(
                        value: 'density_to_salinity',
                        child: Text('Da Densità (g/cm³) a Salinità (ppt)'),
                      ),
                      DropdownMenuItem(
                        value: 'salinity_to_density',
                        child: Text('Da Salinità (ppt) a Densità (g/cm³)'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _conversionMode = value!;
                        _densityController.clear();
                        _salinityPPT = null;
                        _salinityPPM = null;
                        _specificGravity = null;
                      });
                    },
                  ),
                ),
                
                const SizedBox(height: 12),
                _buildInputField(
                  _conversionMode == 'density_to_salinity' 
                    ? 'Densità (es: 1.025)' 
                    : 'Salinità (ppt, es: 35)',
                  _densityController,
                  Icons.water,
                ),
                const SizedBox(height: 12),
                _buildInputField('Temperatura (°C)', _temperatureController, Icons.thermostat),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateDensitySalinity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Converti', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
                if (_salinityPPT != null) ...[
                  const SizedBox(height: 20),
                  _buildResult(
                    'Salinità',
                    '${_salinityPPT!.toStringAsFixed(2)} ppt',
                    theme.colorScheme.tertiary,
                  ),
                  const SizedBox(height: 12),
                  _buildResult(
                    'Salinità (ppm)',
                    '${_salinityPPM!.toStringAsFixed(0)} ppm',
                    theme.colorScheme.tertiary,
                  ),
                  const SizedBox(height: 12),
                  _buildResult(
                    'Densità',
                    '${_specificGravity!.toStringAsFixed(4)} g/cm³',
                    theme.colorScheme.tertiary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Valori indicativi - Usare rifrattometro per misure precise',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // CALCOLO ILLUMINAZIONE
          _buildCalculatorCard(
            title: 'Calcolo Illuminazione',
            icon: Icons.light_mode,
            color: Colors.amber,
            child: Column(
              children: [
                Text(
                  'Calcola il rapporto watt/litro ottimale',
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Selettore tipo vasca
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                  ),
                  child: DropdownButton<String>(
                    value: _tankType,
                    isExpanded: true,
                    dropdownColor: theme.colorScheme.surfaceContainerHighest,
                    underline: const SizedBox(),
                    style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 15),
                    items: const [
                      DropdownMenuItem(value: 'Solo Pesci', child: Text('Solo Pesci')),
                      DropdownMenuItem(value: 'Pesci + Coralli Molli', child: Text('Pesci + Coralli Molli (LPS)')),
                      DropdownMenuItem(value: 'Coralli SPS', child: Text('Coralli SPS')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _tankType = value!;
                        _wattsPerLiter = null;
                        _lightRecommendation = null;
                      });
                    },
                  ),
                ),
                
                const SizedBox(height: 12),
                _buildInputField('Volume acquario (L)', _lightVolumeController, Icons.water),
                const SizedBox(height: 12),
                _buildInputField('Potenza luci (W)', _wattsController, Icons.bolt),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateLighting,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Calcola', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
                if (_wattsPerLiter != null) ...[
                  const SizedBox(height: 20),
                  _buildResult(
                    'Watt per Litro',
                    '${_wattsPerLiter!.toStringAsFixed(2)} W/L',
                    Colors.amber,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      _lightRecommendation!,
                      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fotoperiodo consigliato: 8-10 ore/giorno',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),


        ],
      ),
    );
  }

  String _getUnit() {
    switch (_selectedAdditive) {
      case 'Calcio':
        return 'mg/L';
      case 'Magnesio':
        return 'mg/L';
      case 'KH':
        return 'dKH';
      case 'Nitrati':
        return 'ppm';
      case 'Fosfati':
        return 'ppm';
      case 'Iodio':
        return 'µg/L';
      case 'Stronzio':
        return 'mg/L';
      default:
        return '';
    }
  }

  Widget _buildCalculatorCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon) {
    final theme = Theme.of(context);
    
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        prefixIcon: Icon(icon, color: theme.colorScheme.onSurfaceVariant, size: 20),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.primary),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildResult(String label, String value, Color color) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
