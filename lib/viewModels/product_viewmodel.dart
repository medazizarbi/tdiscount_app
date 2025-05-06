import 'package:flutter/material.dart';
import 'package:tdiscount_app/models/product_model.dart';
import 'package:tdiscount_app/services/produit_service.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  bool isLoading = false;
  Product? product; // Store the fetched product

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
}
