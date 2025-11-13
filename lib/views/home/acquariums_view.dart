import 'package:flutter/material.dart';
import 'package:acquariumfe/widgets/animated_value.dart';
import 'package:acquariumfe/utils/custom_page_route.dart';
import 'package:acquariumfe/views/aquarium/aquarium_details.dart';
import 'package:acquariumfe/widgets/components/skeleton_loader.dart';
import 'package:acquariumfe/services/aquarium_service.dart';
import 'package:acquariumfe/services/parameter_service.dart';
import 'package:acquariumfe/models/aquarium.dart';
import 'package:acquariumfe/models/aquarium_parameters.dart';

// Classe helper per combinare acquario + parametri
class AquariumWithParams {
  final Aquarium aquarium;
  final AquariumParameters? parameters;
  final DateTime? lastUpdate;
  
  AquariumWithParams({
    required this.aquarium,
    this.parameters,
    this.lastUpdate,
  });
  
  bool get hasAlert {
    if (parameters == null) return false;
    
    // Verifica parametri fuori range (valori tipici per acquario marino)
    final tempOk = parameters!.temperature >= 24.0 && parameters!.temperature <= 27.0;
    final phOk = parameters!.ph >= 7.8 && parameters!.ph <= 8.5;
    final salinityOk = parameters!.salinity >= 1.023 && parameters!.salinity <= 1.026;
    
    return !tempOk || !phOk || !salinityOk;
  }
}

class AquariumView extends StatefulWidget {
  const AquariumView({super.key});

  @override
  State<AquariumView> createState() => _AquariumViewState();
}

class _AquariumViewState extends State<AquariumView> with SingleTickerProviderStateMixin {
  final AquariumsService _aquariumsService = AquariumsService();
  final ParameterService _parameterService = ParameterService();
  
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isLoading = true;
  List<AquariumWithParams> _aquariumsWithParams = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final aquariums = await _aquariumsService.getAquariumsList();
      
      // Carica parametri per ogni acquario
      final aquariumsWithParams = <AquariumWithParams>[];
      for (final aquarium in aquariums) {
        AquariumParameters? params;
        DateTime? lastUpdate;
        
        try {
          // Disabilita alert automatici durante il caricamento iniziale
          _parameterService.setAutoCheckAlerts(false);
          params = await _parameterService.getCurrentParameters(
            id: aquarium.id,
            useMock: false,
          );
          lastUpdate = DateTime.now();
        } catch (e) {
          // Se fallisce, parametri rimangono null
          print('⚠️ Impossibile caricare parametri per ${aquarium.name}: $e');
        }
        
        aquariumsWithParams.add(AquariumWithParams(
          aquarium: aquarium,
          parameters: params,
          lastUpdate: lastUpdate,
        ));
      }
      
      if (mounted) {
        setState(() {
          _aquariumsWithParams = aquariumsWithParams;
          _isLoading = false;
        });
        
        // Imposta la prima vasca come corrente se ce ne sono
        if (aquariumsWithParams.isNotEmpty) {
          ParameterService().setCurrentAquarium(aquariumsWithParams.first.aquarium.id);
        }
        
        // Riabilita alert automatici
        _parameterService.setAutoCheckAlerts(true);
        
        _controller.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Errore nel caricamento delle vasche: $e'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return RefreshIndicator(
      onRefresh: _loadData,
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,
      child: _isLoading
          ? ListView(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
              children: List.generate(3, (index) => const AquariumCardSkeleton()),
            )
          : _aquariumsWithParams.isEmpty
              ? _buildEmptyState(theme)
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                  itemCount: _aquariumsWithParams.length,
                  itemBuilder: (context, index) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: _buildAquariumCard(context, _aquariumsWithParams[index]),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(40),
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.water_drop_outlined,
                size: 80,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 24),
              Text(
                'Nessuna vasca trovata',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Aggiungi la tua prima vasca per iniziare',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAquariumCard(BuildContext context, AquariumWithParams aquariumData) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final aquarium = aquariumData.aquarium;
    final params = aquariumData.parameters;
    
    // Usa parametri reali o valori di fallback
    final temp = params?.temperature ?? 0.0;
    final ph = params?.ph ?? 0.0;
    final salinity = params?.salinity ?? 0.0;
    final hasAlert = aquariumData.hasAlert;
    final hasData = params != null;
    
    return BounceButton(
      onTap: () {
        // Imposta questa vasca come vasca corrente per i parametri
        ParameterService().setCurrentAquarium(aquarium.id);
        
        Navigator.push(
          context,
          CustomPageRoute(
            page: AquariumDetails(aquariumId: aquarium.id),
            transitionType: PageTransitionType.fadeSlide,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1e293b),
                    const Color(0xFF0f172a),
                  ]
                : [
                    const Color(0xFFffffff),
                    const Color(0xFFf1f5f9),
                  ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: const Color(0xFF34d399).withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF34d399).withValues(alpha: 0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "aquarium_card_${aquarium.id}",
              child: Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF60a5fa).withValues(alpha: 0.2),
                                  const Color(0xFF2dd4bf).withValues(alpha: 0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF60a5fa).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Icon(
                              aquarium.type == 'Marino' 
                                  ? Icons.water_drop 
                                  : aquarium.type == 'Reef'
                                      ? Icons.bubble_chart
                                      : Icons.water,
                              color: const Color(0xFF60a5fa),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  aquarium.name,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.water_drop,
                                      size: 11,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${aquarium.volume.toInt()} L • ${aquarium.type}",
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Timestamp ultimo aggiornamento
            if (aquariumData.lastUpdate != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.update,
                      size: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Aggiornato ${_formatRelativeTime(aquariumData.lastUpdate!)}',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              const Color(0xFF0c4a6e).withValues(alpha: 0.4),
                              const Color(0xFF164e63).withValues(alpha: 0.3),
                              const Color(0xFF0f766e).withValues(alpha: 0.2),
                            ]
                          : [
                              const Color(0xFF7dd3fc).withValues(alpha: 0.3),
                              const Color(0xFF5eead4).withValues(alpha: 0.2),
                              const Color(0xFF60a5fa).withValues(alpha: 0.25),
                            ],
                    ),
                    border: Border.all(
                      color: const Color(0xFF60a5fa).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Onde animate di sfondo
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _WavePainter(
                            color: const Color(0xFF60a5fa).withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      // Icona vasca stilizzata
                      
                      // Parametri rapidi con glassmorphism
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.5)
                                : Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.4),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildQuickStat(
                                Icons.thermostat,
                                hasData ? "${temp.toStringAsFixed(1)}°C" : "N/D",
                                const Color(0xFFef4444),
                                hasData,
                              ),
                              Container(
                                width: 1,
                                height: 24,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                              ),
                              _buildQuickStat(
                                Icons.science_outlined,
                                hasData ? ph.toStringAsFixed(1) : "N/D",
                                const Color(0xFF60a5fa),
                                hasData,
                              ),
                              Container(
                                width: 1,
                                height: 24,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                              ),
                              _buildQuickStat(
                                Icons.water_outlined,
                                hasData ? salinity.toStringAsFixed(3) : "N/D",
                                const Color(0xFF2dd4bf),
                                hasData,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }

  Widget _buildQuickStat(IconData icon, String value, Color color, bool hasData) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(
          icon,
          size: 18,
          color: hasData ? color : theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: hasData
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withValues(alpha: 0.3),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
  
  /// Formatta un timestamp in formato relativo (es. "5 min fa", "2 ore fa")
  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inSeconds < 60) {
      return 'adesso';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min fa';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'ora' : 'ore'} fa';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'giorno' : 'giorni'} fa';
    } else {
      return '${(difference.inDays / 7).floor()} ${(difference.inDays / 7).floor() == 1 ? 'settimana' : 'settimane'} fa';
    }
  }
}

// CustomPainter per le onde animate
class _WavePainter extends CustomPainter {
  final Color color;

  _WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Prima onda
    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.5,
      size.width * 0.5, size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.7,
      size.width, size.height * 0.6,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Seconda onda (più chiara)
    final path2 = Path();
    paint.color = color.withValues(alpha: color.a * 0.5);
    
    path2.moveTo(0, size.height * 0.4);
    path2.quadraticBezierTo(
      size.width * 0.3, size.height * 0.3,
      size.width * 0.6, size.height * 0.4,
    );
    path2.quadraticBezierTo(
      size.width * 0.8, size.height * 0.5,
      size.width, size.height * 0.4,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
