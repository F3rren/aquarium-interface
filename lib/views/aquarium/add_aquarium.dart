import 'package:acquariumfe/models/aquarium.dart';
import 'package:acquariumfe/services/aquarium_service.dart';
import 'package:acquariumfe/utils/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddAquarium extends StatefulWidget {
  const AddAquarium({super.key});

  @override
  State<AddAquarium> createState() => _AddAquariumState();
}

class _AddAquariumState extends State<AddAquarium> with SingleTickerProviderStateMixin {
  final AquariumsService _aquariumsService = AquariumsService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _volumeController = TextEditingController();
  String _selectedType = 'Marino';
  bool _isLoading = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
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
    _nameController.dispose();
    _volumeController.dispose();
    super.dispose();
  }

  void _saveAquarium() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        // Validazione manuale del volume
        final volumeText = _volumeController.text.trim();
        final volume = double.tryParse(volumeText);
        
        if (volume == null || volume <= 0) {
          throw Exception('Il volume deve essere un numero positivo');
        }

        // Crea l'oggetto Aquarium con i dati del form
        final newAquarium = Aquarium(
          name: _nameController.text.trim(),
          volume: volume,
          type: _selectedType,
        );

        // Chiamata al servizio per creare l'acquario
        final createdAquarium = await _aquariumsService.createAquarium(newAquarium);
        
        setState(() => _isLoading = false);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.circleCheck, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Acquario "${createdAquarium.name}" creato con successo!')),
                ],
              ),
              backgroundColor: const Color(0xFF34d399),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 3),
            ),
          );
          Navigator.pop(context, true); // Ritorna true per indicare il successo
        }
      } on AppException catch (error) {
        setState(() => _isLoading = false);
        
        if (context.mounted) {
          // Usa il messaggio user-friendly delle nuove eccezioni
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.triangleExclamation, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text(error.userMessage)),
                ],
              ),
              backgroundColor: const Color(0xFFef4444),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.triangleExclamation, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Errore: ${e.toString()}')),
                ],
              ),
              backgroundColor: const Color(0xFFef4444),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Nuovo Acquario', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
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
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: FaIcon(FontAwesomeIcons.circlePlus, color: theme.colorScheme.primary, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Crea Nuovo Acquario', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Compila i dettagli della vasca', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Nome
              _buildLabel('Nome Acquario'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                decoration: _buildInputDecoration('es. La Mia Vasca', FontAwesomeIcons.textHeight),
                validator: (value) => value?.isEmpty ?? true ? 'Inserisci un nome' : null,
              ),
              const SizedBox(height: 20),
              
              // Tipo
              _buildLabel('Tipo Acquario'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha:0.1)),
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildTypeButton('Marino', FontAwesomeIcons.droplet)),
                    Expanded(child: _buildTypeButton('Dolce', FontAwesomeIcons.water)),
                    Expanded(child: _buildTypeButton('Reef', FontAwesomeIcons.atom)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Volume
              _buildLabel('Volume (Litri)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _volumeController,
                style: TextStyle(color: theme.colorScheme.onSurface),
                keyboardType: TextInputType.number,
                decoration: _buildInputDecoration('es. 200', FontAwesomeIcons.ruler),
                validator: (value) => value?.isEmpty ?? true ? 'Inserisci il volume' : null,
              ),
              const SizedBox(height: 32),
              
              // Pulsante Salva
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAquarium,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                    disabledBackgroundColor: theme.colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(FontAwesomeIcons.circleCheck, size: 24),
                            SizedBox(width: 12),
                            Text('Salva Acquario', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    final theme = Theme.of(context);
    
    return Text(
      text,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    final theme = Theme.of(context);
    
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha:0.4)),
      prefixIcon: Icon(icon, color: theme.colorScheme.primary, size: 20),
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha:0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFef4444)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildTypeButton(String type, IconData icon) {
    final theme = Theme.of(context);
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withValues(alpha:0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              type,
              style: TextStyle(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

