import 'package:flutter/material.dart';
import 'package:tdiscount_app/models/category_model.dart';
import 'package:tdiscount_app/models/product_model.dart';
import '../services/category_service.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  bool isLoading = false;
  List<Category> categories = [];
  List<Product> products = [];
  List<Category> subCategories = [];
  Map<int, List<Product>> productsBySubCategory = {};
  int currentPage = 1;
  bool hasMoreProducts = true;
  bool _isLoadingMore = false;
  final ScrollController scrollController = ScrollController();

  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();

    try {
      categories = await _categoryService.fetchCategories();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductsByCategory(int categoryId) async {
    if (!hasMoreProducts || _isLoadingMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final category = categories.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => Category(id: categoryId, name: '', count: 0),
      );

      const int perPage = 20;
      final newProducts = await _categoryService.fetchProductsByCategory(
        categoryId,
        currentPage,
        perPage,
      );

      if (newProducts.isEmpty) {
        hasMoreProducts = false;
        return;
      }

      if (productsBySubCategory.containsKey(categoryId)) {
        productsBySubCategory[categoryId]!.addAll(newProducts);
      } else {
        productsBySubCategory[categoryId] = newProducts;
      }

      // Check if we've loaded all products using the count field
      if (productsBySubCategory[categoryId]!.length >= category.count) {
        hasMoreProducts = false;
      }

      currentPage++;
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void initScrollListener(int categoryId) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchProductsByCategory(categoryId);
      }
    });
  }

  void disposeScrollController() {
    scrollController.dispose();
  }

  Future<void> fetchSubCategories(
      int parentCategoryId, String parentCategoryName) async {
    isLoading = true;
    notifyListeners();

    try {
      subCategories = await _categoryService.fetchSubCategories(
          parentCategoryId, parentCategoryName);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductsBySubCategory(int subCategoryId) async {
    isLoading = true;
    notifyListeners();

    try {
      const int perPage = 20;
      products = await _categoryService.fetchProductsByCategory(
          subCategoryId, currentPage, perPage);
      productsBySubCategory[subCategoryId] = products;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void resetPagination() {
    currentPage = 1;
    hasMoreProducts = true;
    _isLoadingMore = false;
    notifyListeners();
  }

  int getCategoryCount(int categoryId) {
    return categories
        .firstWhere(
          (cat) => cat.id == categoryId,
          orElse: () => Category(id: categoryId, name: '', count: 0),
        )
        .count;
  }
}
