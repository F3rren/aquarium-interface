/// Service for managing aquarium product inventory via the backend API.
library;

import 'package:maintenance_service/api.dart';
import 'package:logger/logger.dart';
import 'package:acquariumfe/constants/api_endpoints.dart';
import 'package:acquariumfe/models/product.dart';
import 'api_service.dart';

/// Non-singleton service that performs CRUD operations on [Product] records and
/// computes inventory statistics.
///
/// Unlike most other services, `ProductService` is **not** a singleton — it is
/// instantiated normally and each instance maintains its own state. The Riverpod
/// provider in `service_providers.dart` controls lifetime.
///
/// **Caching:** [_cachedProducts] is populated by the most-recent unfiltered
/// `getAllProducts()` call. Any mutation (add, update, delete, recordUsage,
/// toggleFavorite, updateQuantity) invalidates the cache. Filtered queries do
/// not update the cache.
///
/// **Response normalisation:** accepts both a direct JSON array and wrapper
/// objects keyed by `"data"`.
///
/// **Error handling:** [getAllProducts] falls back to the cache on network
/// errors; all mutation methods propagate exceptions so callers can display
/// feedback.
class ProductService {
  final _apiService = ApiService();
  final _logger = Logger();

  /// ID of the currently active aquarium.
  int? _currentAquariumId;

  /// Cache of the last unfiltered product list; `null` after any mutation.
  List<Product>? _cachedProducts;

  /// Sets the active aquarium and invalidates the product cache.
  void setCurrentAquarium(int aquariumId) {
    _currentAquariumId = aquariumId;
    _cachedProducts = null;
  }

  /// Returns all products, optionally filtered by one or more criteria.
  ///
  /// Supported filters (all optional):
  /// - [category] — [ProductCategory] enum value
  /// - [brand] — exact brand string
  /// - [search] — free-text search across name / brand
  /// - [favorites] — only starred products when `true`
  /// - [expired] — only expired products when `true`
  /// - [expiringSoon] — only products expiring within 30 days when `true`
  /// - [lowStock] — only products below the low-stock threshold when `true`
  /// - [shouldUseAgain] — only products past their usage interval when `true`
  ///
  /// When called without filters, updates [_cachedProducts]. On network error,
  /// returns the cached list (or an empty list if no cache exists).
  ///
  /// Throws when no aquarium has been set.
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
      String endpoint = ApiEndpoints.products;
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
          productList = dataField is List ? dataField : [];
        } else {
          productList = [];
        }
      } else {
        productList = [];
      }

      final products = productList
          .map((json) => Product.fromDto(ProductDTO.fromJson(json)!))
          .toList();

      // Only cache unfiltered results.
      if (queryParams.isEmpty) {
        _cachedProducts = products;
      }

      return products;
    } catch (e) {
      _logger.e('Errore nel caricamento dei prodotti', error: e);
      return _cachedProducts ?? [];
    }
  }

  /// Returns products filtered by [category].
  Future<List<Product>> getProductsByCategory(ProductCategory category) async {
    return await getAllProducts(category: category);
  }

  /// Returns only products marked as favourites.
  Future<List<Product>> getFavoriteProducts() async {
    return await getAllProducts(favorites: true);
  }

  /// Returns products that are expiring within the next 30 days.
  Future<List<Product>> getExpiringProducts() async {
    return await getAllProducts(expiringSoon: true);
  }

  /// Returns products below the low-stock threshold (< 20 units).
  Future<List<Product>> getLowStockProducts() async {
    return await getAllProducts(lowStock: true);
  }

  /// Fetches a single product by [id] from `GET /products/{id}`.
  ///
  /// Returns `null` on error or when the backend response cannot be parsed.
  Future<Product?> getProductById(String id) async {
    if (_currentAquariumId == null) {
      throw Exception('Aquarium ID not set');
    }

    try {
      final response = await _apiService.get(ApiEndpoints.product(id));

      if (response is Map<String, dynamic>) {
        if (response.containsKey('data')) {
          return Product.fromDto(ProductDTO.fromJson(response['data'])!);
        }
      }
      return null;
    } catch (e) {
      _logger.e('Errore nel recupero del prodotto', error: e);
      return null;
    }
  }

  /// Creates a new product via `POST /products` and invalidates the cache.
  Future<void> addProduct(Product product) async {
    if (_currentAquariumId == null) {
      throw Exception('Aquarium ID not set');
    }

    try {
      await _apiService.post(ApiEndpoints.products, product.toJson());
      _cachedProducts = null;
    } catch (e) {
      _logger.e("Errore nell'aggiunta del prodotto", error: e);
      rethrow;
    }
  }

  /// Updates an existing product via `PUT /products/{id}` and invalidates the
  /// cache.
  Future<void> updateProduct(Product product) async {
    if (_currentAquariumId == null) {
      throw Exception('Aquarium ID not set');
    }

    try {
      await _apiService.put(ApiEndpoints.product(product.id), product.toJson());
      _cachedProducts = null;
    } catch (e) {
      _logger.e("Errore nell'aggiornamento del prodotto", error: e);
      rethrow;
    }
  }

  /// Permanently deletes the product with [id] via `DELETE /products/{id}` and
  /// invalidates the cache.
  Future<void> deleteProduct(String id) async {
    if (_currentAquariumId == null) {
      throw Exception('Aquarium ID not set');
    }

    try {
      await _apiService.delete(ApiEndpoints.product(id));
      _cachedProducts = null;
    } catch (e) {
      _logger.e("Errore nell'eliminazione del prodotto", error: e);
      rethrow;
    }
  }

  /// Records a product usage event via two PATCH requests:
  /// 1. `PATCH /products/{id}/mark-used` — updates [Product.lastUsed].
  /// 2. `PATCH /products/{id}/quantity` with `{"change": -quantityUsed}` if
  ///    [quantityUsed] is non-null.
  ///
  /// Invalidates the cache on success.
  Future<void> recordUsage(String productId, {double? quantityUsed}) async {
    if (_currentAquariumId == null) {
      throw Exception('Aquarium ID not set');
    }

    try {
      await _apiService.patch(ApiEndpoints.markProductUsed(productId), {});

      if (quantityUsed != null) {
        await _apiService.patch(ApiEndpoints.productQuantity(productId), {
          'change': -quantityUsed,
        });
      }

      _cachedProducts = null;
    } catch (e) {
      _logger.e("Errore nella registrazione dell'uso", error: e);
      rethrow;
    }
  }

  /// Toggles the [Product.isFavorite] flag via
  /// `PATCH /products/{id}/toggle-favorite` and invalidates the cache.
  Future<void> toggleFavorite(String productId) async {
    if (_currentAquariumId == null) {
      throw Exception('Aquarium ID not set');
    }

    try {
      await _apiService.patch(ApiEndpoints.toggleProductFavorite(productId), {});
      _cachedProducts = null;
    } catch (e) {
      _logger.e('Errore nel toggle preferito', error: e);
      rethrow;
    }
  }

  /// Adjusts [Product.quantity] by [change] units (positive to add stock,
  /// negative to reduce) via `PATCH /products/{id}/quantity`.
  ///
  /// Invalidates the cache on success.
  Future<void> updateQuantity(String productId, double change) async {
    if (_currentAquariumId == null) {
      throw Exception('Aquarium ID not set');
    }

    try {
      await _apiService.patch(ApiEndpoints.productQuantity(productId), {
        'change': change,
      });
      _cachedProducts = null;
    } catch (e) {
      _logger.e("Errore nell'aggiornamento della quantità", error: e);
      rethrow;
    }
  }

  /// Computes inventory statistics from the current (unfiltered) product list.
  ///
  /// All calculations are performed locally from the fetched data. Returns a
  /// map with:
  /// - `'totalProducts'` (int)
  /// - `'totalCost'` (double) — sum of [Product.cost] for products with a cost
  /// - `'expiringCount'` (int) — products that are expired or expiring soon
  /// - `'lowStockCount'` (int) — products below the low-stock threshold
  /// - `'categoryCounts'` ([Map<ProductCategory, int>]) — per-category counts
  /// - `'favoriteCount'` (int) — starred products
  Future<Map<String, dynamic>> getStatistics() async {
    final products = await getAllProducts();

    double totalCost = 0;
    int expiringCount = 0;
    int lowStockCount = 0;
    Map<ProductCategory, int> categoryCounts = {};

    for (var product in products) {
      if (product.cost != null) {
        totalCost += product.cost!;
      }

      if (product.isExpiringSoon || product.isExpired) {
        expiringCount++;
      }

      if (product.isLowStock) {
        lowStockCount++;
      }

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

  /// Clears the in-memory product cache without making a network call.
  void clearCache() {
    _cachedProducts = null;
  }
}
