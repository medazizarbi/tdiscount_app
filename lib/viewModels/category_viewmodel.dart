import 'package:flutter/material.dart';
import 'package:tdiscount_app/models/category_model.dart';
import 'package:tdiscount_app/models/product_model.dart';
import '../services/category_service.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  bool isLoading = false;
  List<Category> categories = [];
  List<Product> products = []; // Store fetched products
  List<Category> subCategories = []; // Store fetched subcategories
  Map<int, List<Product>> productsBySubCategory =
      {}; // Map to store products by subcategory ID

  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();

    categories = await _categoryService.fetchCategories();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProductsByCategory(int categoryId) async {
    isLoading = true;
    notifyListeners();

    products = await _categoryService.fetchProductsByCategory(categoryId);
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSubCategories(
      int parentCategoryId, String parentCategoryName) async {
    isLoading = true;
    notifyListeners();

    subCategories = await _categoryService.fetchSubCategories(
        parentCategoryId, parentCategoryName);
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProductsBySubCategory(int subCategoryId) async {
    isLoading = true;
    notifyListeners();

    final products =
        await _categoryService.fetchProductsByCategory(subCategoryId);
    productsBySubCategory[subCategoryId] =
        products; // Store products for the subcategory
    isLoading = false;
    notifyListeners();
  }
}
