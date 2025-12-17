import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:acquariumfe/models/product.dart';

class ProductService {
  static const String _storageKey = 'aquarium_products';
  int? _currentAquariumId;

  // Imposta l'acquario corrente
  void setCurrentAquarium(int aquariumId) {
    _currentAquariumId = aquariumId;
  }

  String get _aquariumKey {
    if (_currentAquariumId == null) {
      throw Exception('Aquarium ID not set');
    }
    return '${_storageKey}_$_currentAquariumId';
  }

  // Ottieni tutti i prodotti
  Future<List<Product>> getAllProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? productsJson = prefs.getString(_aquariumKey);

    if (productsJson == null) {
      return [];
    }

    final List<dynamic> productsList = jsonDecode(productsJson);
    return productsList.map((json) => Product.fromJson(json)).toList();
  }

  // Ottieni prodotti per categoria
  Future<List<Product>> getProductsByCategory(ProductCategory category) async {
    final products = await getAllProducts();
    return products.where((p) => p.category == category).toList();
  }

  // Ottieni prodotti preferiti
  Future<List<Product>> getFavoriteProducts() async {
    final products = await getAllProducts();
    return products.where((p) => p.isFavorite).toList();
  }

  // Ottieni prodotti in scadenza
  Future<List<Product>> getExpiringProducts() async {
    final products = await getAllProducts();
    return products.where((p) => p.isExpiringSoon || p.isExpired).toList();
  }

  // Ottieni prodotti con scorte basse
  Future<List<Product>> getLowStockProducts() async {
    final products = await getAllProducts();
    return products.where((p) => p.isLowStock).toList();
  }

  // Ottieni prodotto per ID
  Future<Product?> getProductById(String id) async {
    final products = await getAllProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Aggiungi prodotto
  Future<void> addProduct(Product product) async {
    final products = await getAllProducts();
    products.add(product);
    await _saveProducts(products);
  }

  // Aggiorna prodotto
  Future<void> updateProduct(Product product) async {
    final products = await getAllProducts();
    final index = products.indexWhere((p) => p.id == product.id);

    if (index != -1) {
      products[index] = product;
      await _saveProducts(products);
    }
  }

  // Elimina prodotto
  Future<void> deleteProduct(String id) async {
    final products = await getAllProducts();
    products.removeWhere((p) => p.id == id);
    await _saveProducts(products);
  }

  // Registra utilizzo prodotto
  Future<void> recordUsage(String productId, {double? quantityUsed}) async {
    final product = await getProductById(productId);
    if (product == null) return;

    double? newQuantity = product.quantity;
    if (quantityUsed != null && product.quantity != null) {
      newQuantity = product.quantity! - quantityUsed;
      if (newQuantity < 0) newQuantity = 0;
    }

    final updatedProduct = product.copyWith(
      lastUsed: DateTime.now(),
      quantity: newQuantity,
    );

    await updateProduct(updatedProduct);
  }

  // Toggle preferito
  Future<void> toggleFavorite(String productId) async {
    final product = await getProductById(productId);
    if (product == null) return;

    final updatedProduct = product.copyWith(isFavorite: !product.isFavorite);

    await updateProduct(updatedProduct);
  }

  // Calcola statistiche
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

  // Salva prodotti
  Future<void> _saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final String productsJson = jsonEncode(
      products.map((p) => p.toJson()).toList(),
    );
    await prefs.setString(_aquariumKey, productsJson);
  }

  // Esporta prodotti in JSON (per backup)
  Future<String> exportToJson() async {
    final products = await getAllProducts();
    return jsonEncode(products.map((p) => p.toJson()).toList());
  }

  // Importa prodotti da JSON
  Future<void> importFromJson(String jsonString) async {
    final List<dynamic> productsList = jsonDecode(jsonString);
    final products = productsList
        .map((json) => Product.fromJson(json))
        .toList();
    await _saveProducts(products);
  }
}
