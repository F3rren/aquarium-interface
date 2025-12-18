import 'package:acquariumfe/models/product.dart';
import 'api_service.dart';

class ProductService {
  final _apiService = ApiService();
  int? _currentAquariumId;
  List<Product>? _cachedProducts;

  // Imposta l'acquario corrente
  void setCurrentAquarium(int aquariumId) {
    _currentAquariumId = aquariumId;
    _cachedProducts = null; // Invalida cache quando cambia acquario
  }

  // Ottieni tutti i prodotti
  Future<List<Product>> getAllProducts({
    ProductCategory? category,
    String? brand,
    String? search,
    bool? favorites,
    bool? expired,
    bool? expiringSoon,
    bool? lowStock,
    bool? shouldUseAgain,
  }) async {
    if (_currentAquariumId == null) {
      throw Exception('Aquarium ID not set');
    }

    // Costruisci query parameters
    Map<String, dynamic> queryParams = {};
    if (category != null) {
      queryParams['category'] = category.name.toUpperCase();
    }
    if (brand != null) queryParams['brand'] = brand;
    if (search != null) queryParams['search'] = search;
    if (favorites == true) queryParams['favorites'] = 'true';
    if (expired == true) queryParams['expired'] = 'true';
    if (expiringSoon == true) queryParams['expiringSoon'] = 'true';
    if (lowStock == true) queryParams['lowStock'] = 'true';
    if (shouldUseAgain == true) queryParams['shouldUseAgain'] = 'true';

    try {
      String endpoint = '/products';
      if (queryParams.isNotEmpty) {
        final queryString = queryParams.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
            .join('&');
        endpoint = '$endpoint?$queryString';
      }

      final response = await _apiService.get(endpoint);

      List<dynamic> productList;
      if (response is List) {
        productList = response;
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data')) {
          var dataField = response['data'];
          if (dataField is List) {
            productList = dataField;
          } else {
            productList = [];
          }
        } else {
          productList = [];
        }
      } else {
        productList = [];
      }

      final products = productList
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();

      // Aggiorna cache se è una chiamata senza filtri
      if (queryParams.isEmpty) {
        _cachedProducts = products;
      }

      return products;
    } catch (e) {
      return _cachedProducts ?? [];
    }
  }

  // Ottieni prodotti per categoria
  Future<List<Product>> getProductsByCategory(ProductCategory category) async {
    return await getAllProducts(category: category);
  }

  // Ottieni prodotti preferiti
  Future<List<Product>> getFavoriteProducts() async {
    return await getAllProducts(favorites: true);
  }

  // Ottieni prodotti in scadenza
  Future<List<Product>> getExpiringProducts() async {
    return await getAllProducts(expiringSoon: true);
  }

  // Ottieni prodotti con scorte basse
  Future<List<Product>> getLowStockProducts() async {
    return await getAllProducts(lowStock: true);
  }

  // Ottieni prodotto per ID
  Future<Product?> getProductById(String id) async {
    if (_currentAquariumId == null) {
      throw Exception('Aquarium ID not set');
    }

    try {
      final response = await _apiService.get('/products/$id');
      
      if (response is Map<String, dynamic>) {
        if (response.containsKey('data')) {
          return Product.fromJson(response['data'] as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Aggiungi prodotto
  Future<void> addProduct(Product product) async {
    if (_currentAquariumId == null) {
      throw Exception('Aquarium ID not set');
    }

    try {
      await _apiService.post('/products', product.toJson());
      _cachedProducts = null; // Invalida cache
    } catch (e) {
      rethrow;
    }
  }

  // Aggiorna prodotto
  Future<void> updateProduct(Product product) async {
    if (_currentAquariumId == null) {
      throw Exception('Aquarium ID not set');
    }

    try {
      await _apiService.put('/products/${product.id}', product.toJson());
      _cachedProducts = null; // Invalida cache
    } catch (e) {
      rethrow;
    }
  }

  // Elimina prodotto
  Future<void> deleteProduct(String id) async {
    if (_currentAquariumId == null) {
      throw Exception('Aquarium ID not set');
    }

    try {
      await _apiService.delete('/products/$id');
      _cachedProducts = null; // Invalida cache
    } catch (e) {
      rethrow;
    }
  }

  // Registra utilizzo prodotto (PATCH /products/{id}/mark-used)
  Future<void> recordUsage(String productId, {double? quantityUsed}) async {
    if (_currentAquariumId == null) {
      throw Exception('Aquarium ID not set');
    }

    try {
      // Prima marca come usato
      await _apiService.patch('/products/$productId/mark-used', {});
      
      // Poi aggiorna la quantità se specificata
      if (quantityUsed != null) {
        await _apiService.patch('/products/$productId/quantity', {
          'change': -quantityUsed,
        });
      }
      
      _cachedProducts = null; // Invalida cache
    } catch (e) {
      rethrow;
    }
  }

  // Toggle preferito (PATCH /products/{id}/toggle-favorite)
  Future<void> toggleFavorite(String productId) async {
    if (_currentAquariumId == null) {
      throw Exception('Aquarium ID not set');
    }

    try {
      await _apiService.patch('/products/$productId/toggle-favorite', {});
      _cachedProducts = null; // Invalida cache
    } catch (e) {
      rethrow;
    }
  }

  // Aggiorna quantità (PATCH /products/{id}/quantity)
  Future<void> updateQuantity(String productId, double change) async {
    if (_currentAquariumId == null) {
      throw Exception('Aquarium ID not set');
    }

    try {
      await _apiService.patch('/products/$productId/quantity', {
        'change': change,
      });
      _cachedProducts = null; // Invalida cache
    } catch (e) {
      rethrow;
    }
  }

  // Calcola statistiche (usa dati locali dalla cache)
  Future<Map<String, dynamic>> getStatistics() async {
    final products = await getAllProducts();

    double totalCost = 0;
    int expiringCount = 0;
    int lowStockCount = 0;
    Map<ProductCategory, int> categoryCounts = {};

    for (var product in products) {
      // Costi totali
      if (product.cost != null) {
        totalCost += product.cost!;
      }

      // Conteggio in scadenza
      if (product.isExpiringSoon || product.isExpired) {
        expiringCount++;
      }

      // Conteggio scorte basse
      if (product.isLowStock) {
        lowStockCount++;
      }

      // Conteggio per categoria
      categoryCounts[product.category] =
          (categoryCounts[product.category] ?? 0) + 1;
    }

    return {
      'totalProducts': products.length,
      'totalCost': totalCost,
      'expiringCount': expiringCount,
      'lowStockCount': lowStockCount,
      'categoryCounts': categoryCounts,
      'favoriteCount': products.where((p) => p.isFavorite).length,
    };
  }

  // Pulisci cache
  void clearCache() {
    _cachedProducts = null;
  }
}
