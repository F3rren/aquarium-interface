import 'package:flutter/material.dart';
import 'package:acquariumfe/widgets/animated_value.dart';

class AquariumView extends StatefulWidget {
  const AquariumView({super.key});

  @override
  State<AquariumView> createState() => _AquariumViewState();
}

class _AquariumViewState extends State<AquariumView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildAquariumCard(context, "La Mia Vasca", "ALL GOOD", 25.5, true),
          ),
        ),
      ],
    );
  }

  Widget _buildAquariumCard(BuildContext context, String name, String status, double temp, bool isGood) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return BounceButton(
      onTap: () => Navigator.pushNamed(context, "/details"),
      child: Hero(
        tag: "aquarium_card",
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      theme.colorScheme.surfaceContainerHighest,
                      theme.colorScheme.surface,
                      theme.colorScheme.surface.withValues(alpha: 0.8),
                    ]
                  : [
                      const Color(0xFFffffff),
                      const Color(0xFFf8fafc),
                      const Color(0xFFe0f2fe),
                    ],
              stops: const [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.2), width: 1.5),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8)),
              BoxShadow(
                color: isGood ? theme.colorScheme.primary.withValues(alpha: 0.15) : theme.colorScheme.error.withValues(alpha: 0.15),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(name, style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                  Icon(Icons.arrow_forward_ios, color: theme.colorScheme.onSurface.withValues(alpha: 0.5), size: 16),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                status,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                  letterSpacing: -1.5,
                  shadows: [
                    Shadow(
                      color: isGood ? theme.colorScheme.primary.withValues(alpha: 0.3) : theme.colorScheme.error.withValues(alpha: 0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF60a5fa).withValues(alpha:0.15),
                        const Color(0xFF2dd4bf).withValues(alpha:0.08),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(child: Icon(Icons.water_drop, size: 60, color: const Color(0xFF60a5fa).withValues(alpha:0.4))),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha:0.6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withValues(alpha:0.1)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildQuickStat(Icons.thermostat, "${temp.toStringAsFixed(1)}°C"),
                              _buildQuickStat(Icons.science_outlined, "8.2 pH"),
                              _buildQuickStat(Icons.water_outlined, "1.024"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.access_time, size: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                  const SizedBox(width: 6),
                  Text("Updated 5 minutes ago", style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 11)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isGood ? const Color(0xFF34d399).withValues(alpha: 0.2) : theme.colorScheme.error.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isGood ? const Color(0xFF34d399).withValues(alpha: 0.4) : theme.colorScheme.error.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isGood ? Icons.check_circle : Icons.warning,
                          size: 12,
                          color: isGood ? const Color(0xFF34d399) : theme.colorScheme.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isGood ? "Online" : "Alert",
                          style: TextStyle(
                            color: isGood ? const Color(0xFF34d399) : theme.colorScheme.error,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStat(IconData icon, String value) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 6),
        Text(value, style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
