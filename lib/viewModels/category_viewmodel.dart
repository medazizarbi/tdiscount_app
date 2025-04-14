import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../services/category_service.dart';
import '../views/home_screen.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  List<Product> _productsByCategory = [];
  bool _isLoading = false;
  bool _isLoadingProducts = false;

  List<Category> get categories => _categories;
  List<Product> get productsByCategory => _productsByCategory;
  bool get isLoading => _isLoading;
  bool get isLoadingProducts => _isLoadingProducts;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _categoryService.fetchCategories();
    } catch (e) {
      _categories = [];
      print("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductsByCategory(int categoryId) async {
    _isLoadingProducts = true;
    notifyListeners();

    _productsByCategory =
        await _categoryService.fetchProductsByCategory(categoryId);

    _isLoadingProducts = false;
    notifyListeners();
  }
}
