import 'package:flutter/material.dart';
import 'package:acquariumfe/services/parameter_service.dart';
import 'package:acquariumfe/utils/exceptions.dart';

/// Esempio di utilizzo del nuovo sistema di gestione errori
class ExampleErrorHandling extends StatefulWidget {
  const ExampleErrorHandling({super.key});

  @override
  State<ExampleErrorHandling> createState() => _ExampleErrorHandlingState();
}

class _ExampleErrorHandlingState extends State<ExampleErrorHandling> {
  final _parameterService = ParameterService();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  /// Esempio 1: Gestione base con catch generico
  Future<void> _loadParametersBasic() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final parameters = await _parameterService.getCurrentParameters();
      
      setState(() {
        _successMessage = 'Parametri caricati: Temp ${parameters.temperature}°C';
        _isLoading = false;
      });
    } on AppException catch (e) {
      // Tutte le nostre eccezioni custom hanno userMessage
      setState(() {
        _errorMessage = e.userMessage;
        _isLoading = false;
      });
    } catch (e) {
      // Errore imprevisto
      setState(() {
        _errorMessage = 'Errore imprevisto';
        _isLoading = false;
      });
    }
  }

  /// Esempio 2: Gestione specifica per tipo di errore
  Future<void> _loadParametersAdvanced() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final parameters = await _parameterService.getCurrentParameters();
      
      setState(() {
        _successMessage = 'Parametri caricati: Temp ${parameters.temperature}°C';
        _isLoading = false;
      });
    } on NoAquariumSelectedException catch (e) {
      // Nessun acquario selezionato - naviga alla selezione acquario
      if (mounted) {
        Navigator.pushNamed(context, '/aquariums');
      }
    } on NetworkException catch (e) {
      // Problemi di rete - mostra UI offline mode
      setState(() {
        _errorMessage = '📡 ${e.userMessage}';
        _isLoading = false;
      });
      // Potresti abilitare una modalità offline qui
    } on TimeoutException catch (e) {
      // Timeout - suggerisci di riprovare
      setState(() {
        _errorMessage = '⏱️ ${e.userMessage}';
        _isLoading = false;
      });
    } on AuthException catch (e) {
      // Autenticazione fallita - redirect al login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on ServerException catch (e) {
      // Errore del server - mostra supporto
      setState(() {
        _errorMessage = '🔧 ${e.userMessage}';
        _isLoading = false;
      });
      // Potresti mostrare un pulsante "Contatta supporto"
    } on ValidationException catch (e) {
      // Dati non validi - mostra errori specifici
      setState(() {
        _errorMessage = '❌ ${e.userMessage}';
        if (e.errors != null) {
          // Mostra errori specifici per campo
          _errorMessage = '$_errorMessage\n${e.errors}';
        }
        _isLoading = false;
      });
    } on AppException catch (e) {
      // Catch-all per altre eccezioni custom
      setState(() {
        _errorMessage = e.userMessage;
        _isLoading = false;
      });
    } catch (e) {
      // Errore davvero imprevisto
      setState(() {
        _errorMessage = 'Si è verificato un errore imprevisto';
        _isLoading = false;
      });
      // In produzione, logga questo errore a un servizio di analytics
      print('Unexpected error: $e');
    }
  }

  /// Esempio 3: Pattern con retry manuale
  Future<void> _loadParametersWithRetry() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    int attempts = 0;
    const maxAttempts = 3;

    while (attempts < maxAttempts) {
      try {
        final parameters = await _parameterService.getCurrentParameters();
        
        setState(() {
          _successMessage = 'Parametri caricati al tentativo ${attempts + 1}';
          _isLoading = false;
        });
        return; // Successo, esci dal loop
      } on NetworkException catch (e) {
        attempts++;
        if (attempts >= maxAttempts) {
          setState(() {
            _errorMessage = '${e.userMessage} (dopo $maxAttempts tentativi)';
            _isLoading = false;
          });
        } else {
          // Attendi prima di riprovare
          await Future.delayed(Duration(seconds: attempts * 2));
        }
      } on AppException catch (e) {
        // Altri errori non meritano retry
        setState(() {
          _errorMessage = e.userMessage;
          _isLoading = false;
        });
        return;
      }
    }
  }

  /// Esempio 4: Mostrare dettagli tecnici in debug mode
  Future<void> _loadParametersDebug() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final parameters = await _parameterService.getCurrentParameters();
      
      setState(() {
        _successMessage = 'Parametri caricati: Temp ${parameters.temperature}°C';
        _isLoading = false;
      });
    } on AppException catch (e) {
      setState(() {
        // In debug, mostra anche dettagli tecnici
        if (const bool.fromEnvironment('dart.vm.product')) {
          // Release mode - solo messaggio user-friendly
          _errorMessage = e.userMessage;
        } else {
          // Debug mode - mostra dettagli
          _errorMessage = '''
${e.userMessage}

DEBUG INFO:
Message: ${e.message}
Details: ${e.details ?? 'N/A'}
Original: ${e.originalError ?? 'N/A'}
Type: ${e.runtimeType}
          ''';
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Handling Examples'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),
            
            if (_errorMessage != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                ),
              ),
            
            if (_successMessage != null)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _successMessage!,
                    style: TextStyle(color: Colors.green.shade900),
                  ),
                ),
              ),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _loadParametersBasic,
              child: const Text('1. Gestione Base'),
            ),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _loadParametersAdvanced,
              child: const Text('2. Gestione Avanzata (Tipo Specifico)'),
            ),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _loadParametersWithRetry,
              child: const Text('3. Con Retry Manuale'),
            ),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _loadParametersDebug,
              child: const Text('4. Debug Mode'),
            ),
            
            const SizedBox(height: 20),
            
            const Divider(),
            
            const Text(
              'Vantaggi del Nuovo Sistema:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text('✅ Messaggi user-friendly automatici'),
            const Text('✅ Tipizzazione forte (type-safe)'),
            const Text('✅ Retry automatico per errori di rete'),
            const Text('✅ Separazione tra messaggio tecnico e UI'),
            const Text('✅ Catch specifici per azioni mirate'),
            const Text('✅ Più facile fare debugging'),
          ],
        ),
      ),
    );
  }
}
