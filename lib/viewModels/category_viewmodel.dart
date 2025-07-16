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
  List<Product> trendingProducts = [];

  // Add this persistent list to store category names for filters
  List<String> categoryNamesForFilter = [];

  Map<int, int> currentPageByCategory = {};
  Map<int, bool> hasMoreProductsByCategory = {};

  // NEW: Top categories variables
  List<Category> topCategories = [];
  Map<int, List<Product>> topCategoriesProducts = {};
  bool isTopCategoriesLoading = false;

  late ScrollController scrollController;
  int? activeCategoryId;

  // NEW: Method to get top 4 categories (corrected logic)
  void getTop4Categories() {
    print("🔄 Getting top 4 categories from ${categories.length} categories");

    if (categories.isEmpty) {
      print("❌ Categories list is empty, cannot get top categories");
      return;
    }

    // Filter categories with count > 0
    final validCategories =
        categories.where((category) => category.count > 0).toList();

    // Sort by count in descending order (highest count first)
    validCategories.sort((a, b) => b.count.compareTo(a.count));

    // Take top 4 categories
    topCategories = validCategories.take(4).toList();

    // Check if "autres categories" exists in the top 4
    final autresIndex = topCategories.indexWhere((category) =>
        category.name.toLowerCase().contains("autres") ||
        category.name.toLowerCase().contains("autre"));

    // If "autres categories" exists in top 4 and it's not already last
    if (autresIndex != -1 && autresIndex != topCategories.length - 1) {
      // Remove "autres categories" from its current position
      final autresCategory = topCategories.removeAt(autresIndex);
      // Add it to the end
      topCategories.add(autresCategory);

      print("📱 Found 'autres categories' in top 4, moved to last position");
    }

    print(
        "✅ Top 4 categories selected: ${topCategories.map((c) => '${c.name}(${c.count})').toList()}");
    notifyListeners();
  }

  // NEW: Method to fetch products for top categories
  Future<void> fetchTopCategoriesProducts() async {
    print("🔄 Fetching products for top categories");

    if (topCategories.isEmpty) {
      print("❌ Top categories list is empty, getting top categories first");
      getTop4Categories();
    }

    if (topCategories.isEmpty) {
      print("❌ Still no top categories available");
      return;
    }

    isTopCategoriesLoading = true;
    notifyListeners();

    try {
      // Clear previous products
      topCategoriesProducts.clear();

      // Fetch 10 products for each top category
      for (final category in topCategories) {
        try {
          print(
              '🔄 Fetching 10 products for category: ${category.name} (ID: ${category.id})');

          final products = await _categoryService.fetchProductsByCategory(
            category.id,
            1, // page 1
            10, // 10 products per category
          );

          topCategoriesProducts[category.id] = products;

          print(
              '✅ Fetched ${products.length} products for category: ${category.name}');
        } catch (e) {
          print('❌ Error fetching products for category ${category.name}: $e');
          topCategoriesProducts[category.id] = [];
        }
      }

      print('✅ Top categories products fetch completed');
    } catch (e) {
      print('❌ Error in fetchTopCategoriesProducts: $e');
    } finally {
      isTopCategoriesLoading = false;
      notifyListeners();
    }
  }

  // NEW: Method to get products for a specific top category
  List<Product> getProductsForTopCategory(int categoryId) {
    return topCategoriesProducts[categoryId] ?? [];
  }

  // NEW: Combined method to get top categories and fetch their products
  Future<void> setupTopCategories() async {
    print("🔄 Setting up top categories with products");

    // Ensure we have categories first
    if (categories.isEmpty) {
      print("📱 Categories list is empty, fetching categories first...");
      await fetchCategories();
    }

    // Get top 4 categories
    getTop4Categories();

    // Fetch products for top categories
    await fetchTopCategoriesProducts();

    print("✅ Top categories setup completed");
  }

  // Modified method to populate and return the filter categories
  List<String> getCategoriesForFilter() {
    final Set<String> categoryNames = <String>{};

    // Add main categories
    for (var category in categories) {
      categoryNames.add(category.name);
    }

    // Add subcategories
    for (var subCategory in subCategories) {
      categoryNames.add(subCategory.name);
    }

    // Convert to sorted list and store it
    categoryNamesForFilter = categoryNames.toList()..sort();

    // Debug print to check if data is available
    print(
        "📋 getCategoriesForFilter: Found ${categories.length} categories and ${subCategories.length} subcategories");
    print(
        "📋 Returning ${categoryNamesForFilter.length} category names: $categoryNamesForFilter");

    return categoryNamesForFilter;
  }

  // Add this method to be called in initState
  void initializeCategoryNamesForFilter() {
    if (categories.isNotEmpty) {
      getCategoriesForFilter();
      print(
          "📋 Initialized category names for filter: ${categoryNamesForFilter.length} items");
    } else {
      print("📋 Categories list is empty, cannot initialize filter names yet");
    }
  }

  // Add this async version that ensures data is fetched
  Future<List<String>> getCategoriesForFilterAsync() async {
    // Fetch categories if empty
    if (categories.isEmpty) {
      print("📋 Categories list is empty, fetching...");
      await fetchCategories();
    }

    // Return the filtered categories
    return getCategoriesForFilter();
  }

  // Alternative: Auto-fetch version
  List<String> getCategoriesForFilterWithAutoFetch() {
    // If both lists are empty, trigger fetch (but don't wait for it)
    if (categories.isEmpty && subCategories.isEmpty) {
      print("📋 No categories available, triggering fetch...");
      fetchCategories(); // This will update the lists and notify listeners
      return []; // Return empty list for now, Consumer will rebuild when data arrives
    }

    final Set<String> categoryNames = <String>{};

    // Add main categories
    for (var category in categories) {
      categoryNames.add(category.name);
    }

    // Add subcategories
    for (var subCategory in subCategories) {
      categoryNames.add(subCategory.name);
    }

    // Convert to sorted list to maintain consistent order
    final List<String> sortedCategories = categoryNames.toList()..sort();

    print(
        "📋 getCategoriesForFilter: Returning ${sortedCategories.length} categories");

    return sortedCategories;
  }

  Future<void> fetchTrendingProducts() async {
    const trendingCategoryId = 1337; // best deals category ID
    await fetchProductsBySubCategory(trendingCategoryId);
    trendingProducts = productsBySubCategory[trendingCategoryId] ?? [];
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    print("🔄 viewmodel :  Fetching categories");
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
    print("🔄 viewmodel :  Fetching products for category: $categoryId");
    if (activeCategoryId != categoryId) {
      activeCategoryId = categoryId;
      currentPageByCategory[categoryId] = 2;
      hasMoreProductsByCategory[categoryId] = true;
    }

    final currentPage = currentPageByCategory[categoryId] ?? 2;
    final hasMore = hasMoreProductsByCategory[categoryId] ?? true;

    if (!hasMore || isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final category = categories.followedBy(subCategories).firstWhere(
            (cat) => cat.id == categoryId,
            orElse: () => Category(id: categoryId, name: 'not found', count: 0),
          );

      final currentList = productsBySubCategory[categoryId]!;
      final remaining = category.count - currentList.length;
      if (remaining <= 0) {
        hasMoreProductsByCategory[categoryId] = false;
        return;
      }

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

// ✅ Log current count of products and total expected count
      print(
          "📦📦📦📦 Fetched ${productsBySubCategory[categoryId]!.length} / ${category.count} products for category $categoryId");

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
      print(
          "Fetched subCategories: ${subCategories.map((c) => '${c.id}:${c.name}:${c.count}').toList()}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductsBySubCategory(int subCategoryId) async {
    isLoading = true;
    notifyListeners();

    try {
      const int perPage = 10;
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
