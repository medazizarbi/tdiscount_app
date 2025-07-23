import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdiscount_app/models/product_model.dart';
import 'package:tdiscount_app/services/produit_service.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  bool isLoading = false;
  Product? product; // Single product
  List<Product> cartProducts = []; // Store all fetched cart products

  // Add this map to track quantities
  Map<int, int> cartQuantities = {};

  // NEW: Cache for all fetched products to avoid refetching
  final Map<int, Product> _productCache = {};

  // NEW: Related products state
  List<Product> _relatedProducts = [];
  bool _isLoadingRelatedProducts = false;
  String? _relatedProductsError;

  // Getters for related products
  List<Product> get relatedProducts => _relatedProducts;
  bool get isLoadingRelatedProducts => _isLoadingRelatedProducts;
  String? get relatedProductsError => _relatedProductsError;

  // NEW: Helper method to get product from cache or fetch if not available
  Future<Product?> _getProductById(int productId) async {
    // Check if product is already in cache
    if (_productCache.containsKey(productId)) {
      return _productCache[productId];
    }

    // If not in cache, fetch from API
    try {
      final product = await _productService.fetchProductById(productId);

      // Store in cache for future use
      _productCache[productId] = product;

      return product;
    } catch (e) {
      return null;
    }
  }

  Future<void> fetchProductById(int productId) async {
    isLoading = true;
    notifyListeners();

    try {
      product = await _getProductById(productId);
    } catch (e) {
      // Handle error silently
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Call this when you add a product (default quantity = 1)
  Future<bool> addProductIdToCart(int productId) async {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    List<String> cartIds = prefs.getStringList('cart_product_ids') ?? [];
    bool added = false;
    if (!cartIds.contains(productId.toString())) {
      cartIds.add(productId.toString());
      await prefs.setStringList('cart_product_ids', cartIds);
      cartQuantities[productId] = 1; // default quantity
      added = true;
    }
    isLoading = false;
    notifyListeners();
    return added;
  }

  // Call this when you increment/decrement quantity
  void updateProductQuantity(int productId, int quantity) {
    if (quantity < 1) return;
    cartQuantities[productId] = quantity;
    notifyListeners();
  }

  Future<void> fetchAllCartProducts() async {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    List<String> cartIds = prefs.getStringList('cart_product_ids') ?? [];

    // Only fetch products that are not already in cartProducts
    for (String idStr in cartIds) {
      final int id = int.tryParse(idStr) ?? 0;
      if (id != 0 && !cartProducts.any((prod) => prod.id == id)) {
        final fetchedProduct = await _getProductById(id); // Use cached version
        if (fetchedProduct != null) {
          cartProducts.add(fetchedProduct);
        }
      }
    }
    isLoading = false;
    notifyListeners();
  }

  // Remove quantity when removing product
  Future<void> removeProductIdFromCart(int productId) async {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    List<String> cartIds = prefs.getStringList('cart_product_ids') ?? [];
    if (cartIds.contains(productId.toString())) {
      cartIds.remove(productId.toString());
      await prefs.setStringList('cart_product_ids', cartIds);
      cartProducts.removeWhere((prod) => prod.id == productId);
      cartQuantities.remove(productId);
    }
    isLoading = false;
    notifyListeners();
  }

  // --- Add these getters for UI binding ---
  double get totalPrice {
    double total = 0;
    for (final product in cartProducts) {
      final qty = cartQuantities[product.id] ?? 1;
      total += (double.tryParse(product.price) ?? 0) * qty;
    }
    return total;
  }

  double get totalEconomy {
    double economy = 0;
    for (final product in cartProducts) {
      final qty = cartQuantities[product.id] ?? 1;
      final prev = double.tryParse(product.regularPrice ?? '0') ?? 0;
      final now = double.tryParse(product.price) ?? 0;
      if (prev > now) {
        economy += (prev - now) * qty;
      }
    }
    return economy;
  }

  // NEW: Optimized method to fetch related products with caching
  Future<void> fetchRelatedProducts(List<int> relatedIds) async {
    if (relatedIds.isEmpty) {
      _relatedProducts = [];
      notifyListeners();
      return;
    }

    _isLoadingRelatedProducts = true;
    _relatedProductsError = null;
    notifyListeners();

    try {
      List<Product> fetchedRelatedProducts = [];
      List<int> productsToFetch = [];

      // First, check which products are already in cache
      for (int relatedId in relatedIds) {
        if (_productCache.containsKey(relatedId)) {
          fetchedRelatedProducts.add(_productCache[relatedId]!);
        } else {
          productsToFetch.add(relatedId);
        }
      }

      // Fetch only the products that are not in cache
      if (productsToFetch.isNotEmpty) {
        // Fetch products one by one and add to cache
        for (int productId in productsToFetch) {
          final product = await _getProductById(productId);
          if (product != null) {
            fetchedRelatedProducts.add(product);
          }
        }
      }

      // Sort the related products to maintain the original order from relatedIds
      _relatedProducts = [];
      for (int relatedId in relatedIds) {
        final product = fetchedRelatedProducts.firstWhere(
          (p) => p.id == relatedId,
          orElse: () =>
              fetchedRelatedProducts.first, // fallback, shouldn't happen
        );
        if (fetchedRelatedProducts.any((p) => p.id == relatedId)) {
          _relatedProducts.add(product);
        }
      }

      _relatedProductsError = null;
    } catch (e) {
      _relatedProductsError =
          'Erreur lors du chargement des produits similaires';
      _relatedProducts = [];
    } finally {
      _isLoadingRelatedProducts = false;
      notifyListeners();
    }
  }

  // NEW: Method to set related products for a specific product (useful for navigation)
  void setRelatedProductsFor(int currentProductId, List<int> relatedIds) {
    // Filter cached products that match the related IDs
    _relatedProducts = relatedIds
        .where((id) => _productCache.containsKey(id))
        .map((id) => _productCache[id]!)
        .toList();

    notifyListeners();

    // If not all related products are in cache, fetch the missing ones
    if (_relatedProducts.length < relatedIds.length) {
      fetchRelatedProducts(relatedIds);
    }
  }

  // NEW: Method to clear related products (call when leaving detail screen)
  void clearRelatedProducts() {
    _relatedProducts = [];
    _isLoadingRelatedProducts = false;
    _relatedProductsError = null;
    notifyListeners();
  }

  // NEW: Method to get cache statistics (useful for debugging)
  Map<String, int> getCacheStats() {
    return {
      'cached_products': _productCache.length,
      'current_related_products': _relatedProducts.length,
    };
  }

  // NEW: Method to clear cache if needed (useful for logout or memory management)
  void clearProductCache() {
    _productCache.clear();
  }
}
