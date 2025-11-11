import 'package:flutter/material.dart';

class DeleteAquarium extends StatefulWidget {
  const DeleteAquarium({super.key});

  @override
  State<DeleteAquarium> createState() => _DeleteAquariumState();
}

class _DeleteAquariumState extends State<DeleteAquarium> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _aquariums = [
    {'id': 1, 'name': 'La Mia Vasca', 'volume': 200, 'type': 'Marino'},
    {'id': 2, 'name': 'Acquario Tropicale', 'volume': 150, 'type': 'Dolce'},
  ];
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _deleteAquarium(Map<String, dynamic> aquarium) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.warning_rounded, color: theme.colorScheme.error, size: 48),
              ),
              const SizedBox(height: 20),
              Text(
                'Elimina Acquario',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Sei sicuro di voler eliminare "${aquarium['name']}"?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Questa azione non può essere annullata.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.onSurfaceVariant,
                          side: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha:0.3)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Annulla', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() => _aquariums.remove(aquarium));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.check_circle, color: theme.colorScheme.onSurface),
                                  const SizedBox(width: 12),
                                  Text('${aquarium['name']} eliminato'),
                                ],
                              ),
                              backgroundColor: theme.colorScheme.error,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                          foregroundColor: theme.colorScheme.onError,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_forever, size: 20),
                            SizedBox(width: 8),
                            Text('Elimina', style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Elimina Acquario', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _aquariums.isEmpty
              ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.check_circle, color: theme.colorScheme.tertiary, size: 64),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Nessun Acquario',
                    style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Non ci sono acquari da eliminare',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withValues(alpha:0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.delete, color: theme.colorScheme.error, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Gestione Acquari', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Seleziona per eliminare', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ..._aquariums.map((aquarium) => _buildAquariumCard(aquarium)),
              ],
            ),
        ),
      ),
    );
  }

  Widget _buildAquariumCard(Map<String, dynamic> aquarium) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.error.withValues(alpha:0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _deleteAquarium(aquarium),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    aquarium['type'] == 'Marino' ? Icons.water_drop : Icons.water,
                    color: theme.colorScheme.error,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        aquarium['name'],
                        style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${aquarium['volume']} L  ${aquarium['type']}',
                        style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.delete_outline, color: theme.colorScheme.error, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
