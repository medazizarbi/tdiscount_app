import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdiscount_app/models/product_model.dart';
import 'package:tdiscount_app/services/produit_service.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  bool isLoading = false;
  Product? product; // Single product
  List<Product> cartProducts = []; // Store all fetched cart products

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

  Future<bool> addProductIdToCart(int productId) async {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    List<String> cartIds = prefs.getStringList('cart_product_ids') ?? [];
    bool added = false;
    if (!cartIds.contains(productId.toString())) {
      cartIds.add(productId.toString());
      await prefs.setStringList('cart_product_ids', cartIds);
      print('Product $productId added to cart.');
      added = true; // Newly added
    } else {
      print('Product $productId is already in the cart.');
      added = false; // Already in cart
    }

    isLoading = false;
    notifyListeners();
    return added;
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

  Future<void> removeProductIdFromCart(int productId) async {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    List<String> cartIds = prefs.getStringList('cart_product_ids') ?? [];
    if (cartIds.contains(productId.toString())) {
      cartIds.remove(productId.toString());
      await prefs.setStringList('cart_product_ids', cartIds);
      print('Product $productId removed from cart.');
      // Optionally, remove from cartProducts as well
      cartProducts.removeWhere((prod) => prod.id == productId);
    } else {
      print('Product $productId is not in the cart.');
    }

    isLoading = false;
    notifyListeners();
  }
}
