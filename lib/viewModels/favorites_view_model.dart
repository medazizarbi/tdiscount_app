import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdiscount_app/models/product_model.dart';
import 'package:tdiscount_app/services/produit_service.dart';

class FavoriteViewModel extends ChangeNotifier {
  List<int> _favoriteProductIds = [];
  final List<Product> _favoriteProducts = [];
  final ProductService _productService = ProductService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<int> get favoriteProductIds => _favoriteProductIds;
  List<Product> get favoriteProducts => _favoriteProducts;

  FavoriteViewModel() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    _favoriteProductIds =
        prefs.getStringList('favorite_product_ids')?.map(int.parse).toList() ??
            [];

    // Remove products from _favoriteProducts if their id is not in _favoriteProductIds
    _favoriteProducts
        .removeWhere((prod) => !_favoriteProductIds.contains(prod.id));

    // Fetch only products that are in _favoriteProductIds but not already in _favoriteProducts
    final existingIds = _favoriteProducts.map((p) => p.id).toSet();
    final idsToFetch =
        _favoriteProductIds.where((id) => !existingIds.contains(id)).toList();

    for (final id in idsToFetch) {
      try {
        final product = await _productService.fetchProductById(id);
        _favoriteProducts.add(product);
      } catch (e) {
        print("Error fetching product with id $id: $e");
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
      print('Removed $productId from favorites');
    } else {
      _favoriteProductIds.add(productId);
      print('Added $productId to favorites');
    }
    await prefs.setStringList(
      'favorite_product_ids',
      _favoriteProductIds.map((id) => id.toString()).toList(),
    );
    print(
        'Current favorites in SharedPreferences: ${prefs.getStringList('favorite_product_ids')}');
    notifyListeners();
  }

  bool isFavorite(int productId) {
    return _favoriteProductIds.contains(productId);
  }
}
