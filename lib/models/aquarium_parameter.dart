/// Enum per identificare univocamente i parametri dell'acquario
enum AquariumParameter {
  temperature,
  ph,
  salinity,
  orp,
  calcium,
  magnesium,
  kh,
  nitrate,
  phosphate;

  /// Restituisce l'unità di misura per il parametro
  String get unit {
    switch (this) {
      case temperature:
        return ' °C';
      case ph:
        return '';
      case salinity:
        return '';
      case orp:
        return ' mV';
      case calcium:
      case magnesium:
      case nitrate:
      case phosphate:
        return ' mg/L';
      case kh:
        return ' dKH';
    }
  }
}
