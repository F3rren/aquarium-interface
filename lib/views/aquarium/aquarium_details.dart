import 'package:acquariumfe/views/dashboard/health_dashboard.dart';
import 'package:acquariumfe/views/parameters/parameters_view.dart';
import 'package:acquariumfe/views/charts/charts_view.dart';
import 'package:acquariumfe/views/notifications/notifications_page.dart';
import 'package:acquariumfe/views/profile/profile_page.dart';
import 'package:acquariumfe/views/maintenance/maintenance_view.dart';
import 'package:acquariumfe/utils/custom_page_route.dart';
import 'package:acquariumfe/widgets/components/skeleton_loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AquariumDetails extends StatefulWidget {
  final int? aquariumId;

  const AquariumDetails({super.key, this.aquariumId});

  @override
  State<StatefulWidget> createState() => _AquariumDetailsState();
}

class _AquariumDetailsState extends State<AquariumDetails>
    with SingleTickerProviderStateMixin {
  int _selectedBottomIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = true;

  // Lista delle pagine da mostrare
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Inizializza le pagine con aquariumId
    _pages = [
      const HealthDashboard(),
      const ParametersView(),
      const ChartsView(),
      MaintenanceView(aquariumId: widget.aquariumId),
      ProfilePage(aquariumId: widget.aquariumId),
    ];

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
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false, // Gestiamo manualmente il padding bottom
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
                    icon: FaIcon(
                      FontAwesomeIcons.arrowLeft,
                      color: theme.colorScheme.onSurface,
                    ),
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
                      ],
                    ),
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.bell,
                      color: theme.colorScheme.onSurface,
                    ),
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
                            const SkeletonLoader(
                              width: double.infinity,
                              height: 100,
                            ),
                            const SizedBox(height: 16),
                            const SkeletonLoader(
                              width: double.infinity,
                              height: 100,
                            ),
                            const SizedBox(height: 16),
                            const SkeletonLoader(
                              width: double.infinity,
                              height: 100,
                            ),
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
        child: Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            top: 10,
            bottom: bottomPadding > 0 ? bottomPadding : 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(FontAwesomeIcons.chartPie, 'Dashboard', 0),
              _buildNavItem(FontAwesomeIcons.flask, 'Parametri', 1),
              _buildNavItem(FontAwesomeIcons.chartLine, 'Grafici', 2),
              _buildNavItem(FontAwesomeIcons.wrench, 'Manutenzione', 3),
              _buildNavItem(FontAwesomeIcons.user, 'Profilo', 4),
            ],
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.1 : 1.0,
              child: Icon(
                icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                size: 22,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                fontSize: 9,
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
