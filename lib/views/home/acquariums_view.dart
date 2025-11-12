import 'package:flutter/material.dart';
import 'package:acquariumfe/widgets/animated_value.dart';
import 'package:acquariumfe/utils/custom_page_route.dart';
import 'package:acquariumfe/views/aquarium/aquarium_details.dart';
import 'package:acquariumfe/widgets/components/skeleton_loader.dart';

class AquariumView extends StatefulWidget {
  const AquariumView({super.key});

  @override
  State<AquariumView> createState() => _AquariumViewState();
}

class _AquariumViewState extends State<AquariumView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = true;

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
    // Simula caricamento dati
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _isLoading = false);
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      _controller.forward(from: 0);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Dati aggiornati!'),
            ],
          ),
          backgroundColor: const Color(0xFF34d399),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,
      child: ListView(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        children: _isLoading 
          ? List.generate(3, (index) => const AquariumCardSkeleton())
          : [
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildAquariumCard(context, "La Mia Vasca", 25.5, true),
                ),
              ),
            ],
      ),
    );
  }

  Widget _buildAquariumCard(BuildContext context, String name, double temp, bool isGood) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return BounceButton(
      onTap: () => Navigator.push(
        context,
        CustomPageRoute(
          page: const AquariumDetails(),
          transitionType: PageTransitionType.fadeSlide,
        ),
      ),
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
            color: isGood 
                ? const Color(0xFF34d399).withValues(alpha: 0.3)
                : theme.colorScheme.error.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isGood 
                  ? const Color(0xFF34d399).withValues(alpha: 0.2)
                  : theme.colorScheme.error.withValues(alpha: 0.2),
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
              tag: "aquarium_card",
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
                              Icons.water,
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
                                  name,
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
                                      Icons.access_time,
                                      size: 11,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "5 min fa",
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
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isGood 
                            ? const Color(0xFF34d399).withValues(alpha: 0.15)
                            : theme.colorScheme.error.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isGood 
                              ? const Color(0xFF34d399).withValues(alpha: 0.5)
                              : theme.colorScheme.error.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isGood ? const Color(0xFF34d399) : theme.colorScheme.error,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: isGood ? const Color(0xFF34d399) : theme.colorScheme.error,
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isGood ? "Online" : "Alert",
                            style: TextStyle(
                              color: isGood ? const Color(0xFF34d399) : theme.colorScheme.error,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Icon(
                            Icons.opacity,
                            size: 28,
                            color: const Color(0xFF60a5fa).withValues(alpha: 0.6),
                          ),
                        ),
                      ),
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
                              _buildQuickStat(Icons.thermostat, "${temp.toStringAsFixed(1)}°C", const Color(0xFFef4444)),
                              Container(
                                width: 1,
                                height: 24,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                              ),
                              _buildQuickStat(Icons.science_outlined, "8.2", const Color(0xFF60a5fa)),
                              Container(
                                width: 1,
                                height: 24,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                              ),
                              _buildQuickStat(Icons.water_outlined, "1.024", const Color(0xFF2dd4bf)),
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

  Widget _buildQuickStat(IconData icon, String value, Color color) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
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
