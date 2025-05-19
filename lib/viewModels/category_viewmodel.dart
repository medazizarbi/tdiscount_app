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

  Map<int, int> currentPageByCategory = {};
  Map<int, bool> hasMoreProductsByCategory = {};

  late ScrollController scrollController;
  int? activeCategoryId;

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
    if (activeCategoryId != categoryId) {
      activeCategoryId = categoryId;
      currentPageByCategory[categoryId] = 3;
      hasMoreProductsByCategory[categoryId] = true;
    }

    final currentPage = currentPageByCategory[categoryId] ?? 2;
    final hasMore = hasMoreProductsByCategory[categoryId] ?? true;

    if (!hasMore || isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final category = categories.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => Category(id: categoryId, name: '', count: 0),
      );

      const int perPage = 10;

      print(
          "🔄 Fetching products: category=$categoryId, page=$currentPage, per_page=$perPage");

      final newProducts = await _categoryService.fetchProductsByCategory(
        categoryId,
        currentPage,
        perPage,
      );

      if (newProducts.isEmpty) {
        hasMoreProductsByCategory[categoryId] = false;
        return;
      }

      productsBySubCategory.putIfAbsent(categoryId, () => []);

      final existingIds =
          productsBySubCategory[categoryId]!.map((p) => p.id).toSet();

      final duplicates = <Product>[];
      final uniqueProducts = <Product>[];

      for (var product in newProducts) {
        if (existingIds.contains(product.id)) {
          duplicates.add(product);
        } else {
          uniqueProducts.add(product);
        }
      }

      if (duplicates.isNotEmpty) {
        print("⚠️ Skipped ${duplicates.length} duplicated products:");
        for (var dup in duplicates) {
          print("❌ Duplicate ID: ${dup.id}, Name: ${dup.name}");
        }
      }

      productsBySubCategory[categoryId]!.addAll(uniqueProducts);

      // ✅ Check against category count
      if (productsBySubCategory[categoryId]!.length >= category.count) {
        hasMoreProductsByCategory[categoryId] = false;
      }

      currentPageByCategory[categoryId] = currentPage + 1;
    } catch (e) {
      print('❌ Error fetching products: $e');
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool _isScrollListenerAttached = false;

  void initScrollListener(int categoryId) {
    if (_isScrollListenerAttached) return;

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300) {
        final category = categories.firstWhere(
          (cat) => cat.id == categoryId,
          orElse: () => Category(id: categoryId, name: '', count: 0),
        );
        final currentCount = productsBySubCategory[categoryId]?.length ?? 0;
        if (currentCount < category.count) {
          fetchProductsByCategory(categoryId);
        }
      }
    });

    _isScrollListenerAttached = true;
  }

  void disposeScrollController() {
    scrollController.dispose();
    _isScrollListenerAttached = false;
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
          subCategoryId, 1, perPage);
      productsBySubCategory[subCategoryId] = products;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void resetPagination() {
    currentPageByCategory.clear();
    hasMoreProductsByCategory.clear();
    isLoading = false;
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

  bool hasMoreProductsFor(int subCategoryId) {
    final loadedCount = productsBySubCategory[subCategoryId]?.length ?? 0;
    final subCategory = subCategories.firstWhere(
      (sub) => sub.id == subCategoryId,
      orElse: () => Category(id: subCategoryId, name: '', count: 0),
    );
    final totalCount = subCategory.count;
    return loadedCount < totalCount;
  }
}
