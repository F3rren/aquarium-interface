import 'package:acquariumfe/views/dashboard/health_dashboard.dart';
import 'package:acquariumfe/views/parameters/parameters_view.dart';
import 'package:acquariumfe/views/charts/charts_view.dart';
import 'package:acquariumfe/views/notifications/notifications_page.dart';
import 'package:acquariumfe/views/profile/profile_page.dart';
import 'package:acquariumfe/utils/custom_page_route.dart';
import 'package:acquariumfe/widgets/components/skeleton_loader.dart';
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
  bool _isLoading = true;

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
    
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _isLoading = false);
      _animationController.forward();
    }
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
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header senza Hero
            Container(
              padding: const EdgeInsets.all(20),
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
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'La Mia Vasca',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'ALL GOOD',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_outlined, color: theme.colorScheme.onSurface),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CustomPageRoute(
                          page: const NotificationsPage(),
                          transitionType: PageTransitionType.slideFromRight,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const SkeletonLoader(width: double.infinity, height: 100),
                            const SizedBox(height: 16),
                            const SkeletonLoader(width: double.infinity, height: 100),
                            const SizedBox(height: 16),
                            const SkeletonLoader(width: double.infinity, height: 100),
                          ],
                        ),
                      ),
                    )
                  : FadeTransition(
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
