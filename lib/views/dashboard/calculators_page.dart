import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/l10n/app_localizations.dart';

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
  String? _selectedAdditive;
  double? _additiveResult;
  String _resultUnit = 'g';

  // Calcolo Cambio Acqua
  final TextEditingController _tankVolumeWaterController =
      TextEditingController();
  final TextEditingController _percentageController = TextEditingController();
  double? _waterChangeResult;
  double? _saltNeeded;

  // Calcolo Densità/Salinità
  final TextEditingController _densityController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  double? _salinityPPT;
  double? _salinityPPM;
  double? _specificGravity;
  String _conversionMode =
      'density_to_salinity'; // density_to_salinity | salinity_to_density

  // Calcolo Illuminazione
  final TextEditingController _lightVolumeController = TextEditingController();
  final TextEditingController _wattsController = TextEditingController();
  String? _tankType;
  double? _wattsPerLiter;
  String? _lightRecommendation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    // Inizializza solo la prima volta
    _selectedAdditive ??= l10n.calcium;
    _tankType ??= l10n.fishOnly;
  }

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
        final isReduction =
            _selectedAdditive?.contains('NO3') == true ||
            _selectedAdditive?.contains('PO4') == true ||
            _selectedAdditive?.contains('Carbonio') == true;

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

    if (volume != null &&
        percentage != null &&
        percentage > 0 &&
        percentage <= 100) {
      setState(() {
        _waterChangeResult = (volume * percentage) / 100;
        // Sale necessario: ~35g/L per salinità 1.025
        _saltNeeded = _waterChangeResult! * 35;
      });
    }
  }

  void _calculateDensitySalinity() {
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
        final l10n = AppLocalizations.of(context)!;

        // Raccomandazioni basate sul tipo di vasca
        if (_tankType == l10n.fishOnly) {
          if (_wattsPerLiter! < 0.25) {
            _lightRecommendation = l10n.lightInsufficientFishOnly;
          } else if (_wattsPerLiter! <= 0.5) {
            _lightRecommendation = l10n.lightOptimalFishOnly;
          } else {
            _lightRecommendation = l10n.lightExcessiveAlgaeRisk;
          }
        } else if (_tankType == l10n.fishAndSoftCorals) {
          if (_wattsPerLiter! < 0.5) {
            _lightRecommendation = l10n.lightInsufficientSoftCorals;
          } else if (_wattsPerLiter! <= 1.0) {
            _lightRecommendation = l10n.lightOptimalSoftCorals;
          } else {
            _lightRecommendation = l10n.lightVeryGoodSPS;
          }
        } else {
          // Coralli SPS
          if (_wattsPerLiter! < 1.0) {
            _lightRecommendation = l10n.lightInsufficientSPS;
          } else if (_wattsPerLiter! <= 1.5) {
            _lightRecommendation = l10n.lightOptimalSPS;
          } else {
            _lightRecommendation = l10n.lightVeryPowerfulSPS;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.calculators,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
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
            title: l10n.volumeCalculation,
            icon: FontAwesomeIcons.rulerCombined,
            color: theme.colorScheme.primary,
            child: Column(
              children: [
                Text(l10n.enterAquariumDimensions,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  l10n.length,
                  _lengthController,
                  FontAwesomeIcons.ruler,
                ),
                const SizedBox(height: 12),
                _buildInputField(
                  l10n.width,
                  _widthController,
                  FontAwesomeIcons.ruler,
                ),
                const SizedBox(height: 12),
                _buildInputField(
                  l10n.height,
                  _heightController,
                  FontAwesomeIcons.rulerVertical,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateVolume,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.calculateVolume,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (_volumeResult != null) ...[
                  const SizedBox(height: 20),
                  _buildResult(
                    l10n.totalVolume,
                    '${_volumeResult!.toStringAsFixed(1)} L',
                    theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.estimatedNetVolume(
                      (_volumeResult! * 0.85).toStringAsFixed(1),
                    ),
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(l10n.consideringRocksAndSubstrate,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // CALCOLO DOSAGGIO ADDITIVI
          _buildCalculatorCard(
            title: l10n.additivesDosageCalculation,
            icon: FontAwesomeIcons.flask,
            color: theme.colorScheme.tertiary,
            child: Column(
              children: [
                Text(l10n.calculateAdditiveDosage,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedAdditive,
                      isExpanded: true,
                      dropdownColor: theme.colorScheme.surfaceContainerHighest,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 15,
                      ),
                      items: [
                        DropdownMenuItem(
                          enabled: false,
                          child: Text(l10n.dosageSection,
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        ...[
                          l10n.calcium,
                          l10n.magnesium,
                          l10n.kh,
                          l10n.iodine,
                          l10n.strontium,
                        ].map((String value) {
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
                          child: Text(l10n.reductionSection,
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        ...[
                          l10n.nitrates,
                          l10n.phosphates,
                          l10n.no3po4xRedSea,
                          l10n.activeCarbon,
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(value,
                                style: const TextStyle(fontSize: 14),
                              ),
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
                _buildInputField(
                  l10n.aquariumVolume,
                  _tankVolumeController,
                  FontAwesomeIcons.water,
                ),
                const SizedBox(height: 12),
                _buildInputField(
                  l10n.currentValue(_getUnit()),
                  _currentValueController,
                  FontAwesomeIcons.chartLine,
                ),
                const SizedBox(height: 12),
                _buildInputField(
                  l10n.targetValue(_getUnit()),
                  _targetValueController,
                  FontAwesomeIcons.flag,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateAdditive,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.calculateDosage,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (_additiveResult != null) ...[
                  const SizedBox(height: 20),
                  _buildResult(
                    _selectedAdditive?.contains('NO3:PO4-X') == true ||
                            _selectedAdditive?.contains('Carbonio') == true
                        ? l10n.quantityToDoseReduction
                        : l10n.quantityToDose,
                    '${_additiveResult!.toStringAsFixed(2)} $_resultUnit',
                    theme.colorScheme.tertiary,
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.warningIndicativeValues,
                    style: TextStyle(color: Colors.orange, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ] else if (_selectedAdditive == l10n.nitrates ||
                    _selectedAdditive == l10n.phosphates) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.circleInfo,
                          color: Colors.orange,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(_selectedAdditive == l10n.nitrates
                              ? l10n.nitratesReductionAdvice
                              : l10n.phosphatesReductionAdvice,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
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

          //CALCOLO CAMBIO ACQUA
          _buildCalculatorCard(
            title: l10n.waterChangeCalculation,
            icon: FontAwesomeIcons.droplet,
            color: theme.colorScheme.secondary,
            child: Column(
              children: [
                Text(l10n.calculateWaterAndSalt,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  l10n.aquariumVolumeL,
                  _tankVolumeWaterController,
                  FontAwesomeIcons.water,
                ),
                const SizedBox(height: 12),
                _buildInputField(
                  l10n.changePercentage,
                  _percentageController,
                  FontAwesomeIcons.percent,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateWaterChange,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.calculate,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                if (_waterChangeResult != null) ...[
                  const SizedBox(height: 20),
                  _buildResult(
                    l10n.waterToChange,
                    '${_waterChangeResult!.toStringAsFixed(1)} L',
                    theme.colorScheme.secondary,
                  ),
                  const SizedBox(height: 12),
                  _buildResult(
                    l10n.saltNeeded,
                    '${_saltNeeded!.toStringAsFixed(0)} g',
                    theme.colorScheme.secondary,
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.calculatedForSalinity,
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // CALCOLO DENSITÀ/SALINITÀ
          _buildCalculatorCard(
            title: l10n.densitySalinityConversion,
            icon: FontAwesomeIcons.flask,
            color: theme.colorScheme.tertiary,
            child: Column(
              children: [
                Text(l10n.convertBetweenDensityAndSalinity,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Selettore modalità
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: _conversionMode,
                    isExpanded: true,
                    dropdownColor: theme.colorScheme.surfaceContainerHighest,
                    underline: const SizedBox(),
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 15,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'density_to_salinity',
                        child: Text(l10n.fromDensityToSalinity),
                      ),
                      DropdownMenuItem(
                        value: 'salinity_to_density',
                        child: Text(l10n.fromSalinityToDensity),
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
                      ? l10n.densityExample
                      : l10n.salinityExample,
                  _densityController,
                  FontAwesomeIcons.water,
                ),
                const SizedBox(height: 12),
                _buildInputField(
                  l10n.temperatureCelsius,
                  _temperatureController,
                  FontAwesomeIcons.temperatureHalf,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateDensitySalinity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.convert,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (_salinityPPT != null) ...[
                  const SizedBox(height: 20),
                  _buildResult(
                    l10n.salinityLabel,
                    '${_salinityPPT!.toStringAsFixed(2)} ppt',
                    theme.colorScheme.tertiary,
                  ),
                  const SizedBox(height: 12),
                  _buildResult(
                    l10n.salinityPPM,
                    '${_salinityPPM!.toStringAsFixed(0)} ppm',
                    theme.colorScheme.tertiary,
                  ),
                  const SizedBox(height: 12),
                  _buildResult(
                    l10n.densityLabel,
                    '${_specificGravity!.toStringAsFixed(4)} g/cm³',
                    theme.colorScheme.tertiary,
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.indicativeValuesRefractometer,
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // CALCOLO ILLUMINAZIONE
          _buildCalculatorCard(
            title: l10n.lightingCalculation,
            icon: FontAwesomeIcons.sun,
            color: Colors.amber,
            child: Column(
              children: [
                Text(l10n.calculateWattsPerLiter,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Selettore tipo vasca
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.3),
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: _tankType,
                    isExpanded: true,
                    dropdownColor: theme.colorScheme.surfaceContainerHighest,
                    underline: const SizedBox(),
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 15,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: l10n.fishOnly,
                        child: Text(l10n.fishOnly),
                      ),
                      DropdownMenuItem(
                        value: l10n.fishAndSoftCorals,
                        child: Text(l10n.fishAndSoftCorals),
                      ),
                      DropdownMenuItem(
                        value: l10n.spsCorals,
                        child: Text(l10n.spsCorals),
                      ),
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
                _buildInputField(
                  l10n.aquariumVolumeL,
                  _lightVolumeController,
                  FontAwesomeIcons.water,
                ),
                const SizedBox(height: 12),
                _buildInputField(
                  l10n.lightPowerW,
                  _wattsController,
                  FontAwesomeIcons.bolt,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateLighting,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Calcola',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                if (_wattsPerLiter != null) ...[
                  const SizedBox(height: 20),
                  _buildResult(
                    l10n.wattsPerLiter,
                    '${_wattsPerLiter!.toStringAsFixed(2)} W/L',
                    Colors.amber,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(_lightRecommendation!,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.recommendedPhotoperiod,
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
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
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
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
                child: Text(title,
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

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        prefixIcon: Icon(
          icon,
          color: theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
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
          Text(label,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          Text(value,
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
