import 'package:acquariumfe/views/dashboard/health_dashboard.dart';
import 'package:acquariumfe/widgets/ai_chat_overlay.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Stack(
      children: [
        const HealthDashboard(),
        // FAB per chat AI posizionato in basso a destra
        Positioned(
          right: 16,
          bottom: 16 + bottomPadding,
          child: const AiChatOverlayInner(),
        ),
      ],
    );
  }
}
