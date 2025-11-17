/// Testi e messaggi delle notifiche
class NotificationTexts {
  // Titoli delle notifiche per parametro
  static const Map<String, String> parameterTitles = {
    'Temperatura': 'Temperatura Anomala',
    'pH': 'pH Fuori Range',
    'Salinità': 'Salinità Anomala',
    'ORP': 'ORP Fuori Range',
    'Calcio': 'Calcio Anomalo',
    'Magnesio': 'Magnesio Anomalo',
    'KH': 'KH Fuori Range',
    'Nitrati': 'Nitrati Elevati',
    'Fosfati': 'Fosfati Elevati',
  };

  // Messaggi per stato alto
  static const Map<String, String> highMessages = {
    'Temperatura': 'La temperatura è troppo alta.',
    'pH': 'Il pH è troppo alto.',
    'Salinità': 'La salinità è troppo alta.',
    'ORP': 'L\'ORP è troppo alto.',
    'Calcio': 'Il calcio è troppo alto.',
    'Magnesio': 'Il magnesio è troppo alto.',
    'KH': 'Il KH è troppo alto.',
    'Nitrati': 'I nitrati sono troppo alti.',
    'Fosfati': 'I fosfati sono troppo alti.',
  };

  // Messaggi per stato basso
  static const Map<String, String> lowMessages = {
    'Temperatura': 'La temperatura è troppo bassa.',
    'pH': 'Il pH è troppo basso.',
    'Salinità': 'La salinità è troppo bassa.',
    'ORP': 'L\'ORP è troppo basso.',
    'Calcio': 'Il calcio è troppo basso.',
    'Magnesio': 'Il magnesio è troppo basso.',
    'KH': 'Il KH è troppo basso.',
    'Nitrati': 'I nitrati sono troppo bassi.',
    'Fosfati': 'I fosfati sono troppo bassi.',
  };

  // Suggerimenti per stato alto
  static const Map<String, String> highSuggestions = {
    'Temperatura': 'Verifica il riscaldatore e la temperatura ambiente.',
    'pH': 'Controlla l\'aerazione e riduci l\'illuminazione.',
    'Salinità': 'Aggiungi acqua osmotica per diluire.',
    'ORP': 'Riduci l\'ossigenazione o controlla l\'ozonizzatore.',
    'Calcio': 'Riduci il dosaggio di integratori al calcio.',
    'Magnesio': 'Riduci il dosaggio di integratori al magnesio.',
    'KH': 'Riduci il dosaggio di buffer alcalini.',
    'Nitrati': 'Effettua un cambio d\'acqua e verifica il filtro.',
    'Fosfati': 'Effettua un cambio d\'acqua e usa resine anti-fosfati.',
  };

  // Suggerimenti per stato basso
  static const Map<String, String> lowSuggestions = {
    'Temperatura': 'Verifica il funzionamento del riscaldatore.',
    'pH': 'Aumenta l\'aerazione e controlla il KH.',
    'Salinità': 'Aggiungi sale marino di qualità.',
    'ORP': 'Aumenta l\'ossigenazione o controlla lo skimmer.',
    'Calcio': 'Integra con soluzioni di calcio.',
    'Magnesio': 'Integra con soluzioni di magnesio.',
    'KH': 'Aggiungi buffer alcalini gradualmente',
    'Nitrati': 'Normale per acquari ben bilanciati',
    'Fosfati': 'Normale per acquari ben bilanciati',
  };

  // Manutenzione
  static const String maintenanceTitle = 'Promemoria Manutenzione';
  static const String maintenanceWeekly = 'Manutenzione settimanale prevista';
  static const String maintenanceMonthly = 'Manutenzione mensile prevista';
  
  // Titoli manutenzione specifici
  static const String waterChangeTitle = 'Promemoria: Cambio Acqua';
  static const String waterChangeBody = 'È tempo di cambiare l\'acqua dell\'acquario';
  
  static const String filterCleaningTitle = 'Promemoria: Pulizia Filtro';
  static const String filterCleaningBody = 'Controlla e pulisci il filtro dell\'acquario';
  
  static const String parameterTestingTitle = 'Promemoria: Test Parametri';
  static const String parameterTestingBody = 'Esegui i test dei parametri dell\'acqua';
  
  static const String lightMaintenanceTitle = 'Promemoria: Manutenzione Luci';
  static const String lightMaintenanceBody = 'Controlla e pulisci le luci dell\'acquario';
  
  static const String maintenanceWeeklyDetails = 
      'È ora di effettuare la manutenzione settimanale:\n'
      '• Cambio acqua 10-15%\n'
      '• Pulizia vetri\n'
      '• Test parametri\n'
      '• Controllo attrezzature';
  
  static const String maintenanceMonthlyDetails = 
      'È ora di effettuare la manutenzione mensile:\n'
      '• Cambio acqua 20-25%\n'
      '• Pulizia filtro\n'
      '• Controllo pompe e riscaldatore\n'
      '• Verifica luci e timer\n'
      '• Test completo parametri';

  // Severità
  static const Map<String, String> severityLabels = {
    'CRITICAL': 'CRITICO',
    'HIGH': 'ALTO',
    'MEDIUM': 'MEDIO',
    'LOW': 'BASSO',
  };

  static const Map<String, String> severityDescriptions = {
    'CRITICAL': 'Richiede intervento immediato',
    'HIGH': 'Richiede attenzione prioritaria',
    'MEDIUM': 'Monitorare attentamente',
    'LOW': 'Situazione sotto controllo',
  };

  // Helper methods
  static String getTitle(String parameter) {
    return parameterTitles[parameter] ?? 'Parametro Anomalo';
  }

  static String getMessage(String parameter, bool isHigh) {
    final messages = isHigh ? highMessages : lowMessages;
    return messages[parameter] ?? 'Il parametro $parameter è fuori range';
  }

  static String getSuggestion(String parameter, bool isHigh) {
    final suggestions = isHigh ? highSuggestions : lowSuggestions;
    return suggestions[parameter] ?? 'Controlla il parametro e verifica le impostazioni';
  }

  static String getSeverityLabel(String severity) {
    return severityLabels[severity] ?? severity;
  }

  static String getSeverityDescription(String severity) {
    return severityDescriptions[severity] ?? '';
  }
}
