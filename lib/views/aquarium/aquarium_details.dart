import 'package:acquariumfe/views/dashboard/health_dashboard.dart';
import 'package:acquariumfe/views/parameters/parameters_view.dart';
import 'package:acquariumfe/views/charts/charts_view.dart';
import 'package:acquariumfe/views/notifications/notifications_page.dart';
import 'package:acquariumfe/views/profile/profile_page.dart';
import 'package:flutter/material.dart';

class AquariumDetails extends StatefulWidget {
  const AquariumDetails({super.key});

  @override
  State<StatefulWidget> createState() => _AquariumDetailsState();
}

class _AquariumDetailsState extends State<AquariumDetails> with SingleTickerProviderStateMixin {
  int _selectedBottomIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Lista delle pagine da mostrare
  final List<Widget> _pages = const [
    HealthDashboard(),
    ParametersView(),
    ChartsView(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _selectedBottomIndex) return;
    
    _animationController.reverse().then((_) {
      setState(() {
        _selectedBottomIndex = index;
      });
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(color: theme.colorScheme.surface),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface), onPressed: () => Navigator.pop(context)),
                  Text('La Mia Vasca', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.w500)),
                  IconButton(
                    icon: Icon(Icons.notifications_outlined, color: theme.colorScheme.onSurface),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: IndexedStack(
                  index: _selectedBottomIndex,
                  children: _pages,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.dashboard, 'Dashboard', 0),
                _buildNavItem(Icons.science, 'Parametri', 1),
                _buildNavItem(Icons.analytics, 'Grafici', 2),
                _buildNavItem(Icons.person, 'Profilo', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedBottomIndex == index;
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.1 : 1.0,
              child: Icon(
                icon,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
