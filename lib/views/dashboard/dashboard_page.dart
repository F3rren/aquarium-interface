/// Thin wrapper that hosts the health dashboard as the main dashboard tab.
library;

import 'package:acquariumfe/views/dashboard/health_dashboard.dart';
import 'package:flutter/material.dart';

/// The Dashboard tab widget; renders [HealthDashboard].
///
/// Exists as an indirection layer so the bottom-navigation bar can reference
/// a stable `DashboardPage` route name while the implementation is free to
/// evolve inside [HealthDashboard].
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HealthDashboard();
  }
}
