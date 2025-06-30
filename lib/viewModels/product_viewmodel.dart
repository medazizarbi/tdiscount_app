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

  Future<void> fetchProductById(int productId) async {
    isLoading = true;
    notifyListeners();

    try {
      product = await _productService.fetchProductById(productId);
    } catch (e) {
      print("Error fetching product: $e");
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
        final fetchedProduct = await _productService.fetchProductById(id);
        cartProducts.add(fetchedProduct);
        print('Fetched product: ${fetchedProduct.name} (ID: $id)');
      } else if (cartProducts.any((prod) => prod.id == id)) {
        print(
            'Product with ID $id already in cartProducts, skipping fetch.✅✅✅✅✅✅');
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
}
