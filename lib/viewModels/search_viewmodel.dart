import 'package:flutter/material.dart';
import 'package:tdiscount_app/models/product_model.dart';
import 'package:tdiscount_app/services/search_service.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchService _searchService = SearchService();

  List<Product> searchResults = [];
  bool isLoading = false;
  String? errorMessage;
  int currentPage = 1;
  final int perPage = 10;
  bool hasMore = true;
  String lastSearch = "";

  // Store current filter parameters
  double? currentMinPrice;
  double? currentMaxPrice;
  String? currentOrder;

  Future<void> searchProducts(
    String search, {
    bool isNewSearch = true,
    double? minPrice,
    double? maxPrice,
    String? order,
  }) async {
    if (isLoading) return;

    if (isNewSearch) {
      currentPage = 1;
      hasMore = true;
      searchResults = [];
      lastSearch = search;
      // Store filter parameters for pagination
      currentMinPrice = minPrice;
      currentMaxPrice = maxPrice;
      currentOrder = order;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // Log when the method is called and the page value with filters
    print(
        '🔎 [SearchViewModel] searchProducts called: page=$currentPage, isNewSearch=$isNewSearch, search="$search", minPrice=$minPrice, maxPrice=$maxPrice, order=$order');

    try {
      final products = await _searchService.searchProducts(
        search: search,
        page: currentPage,
        perPage: perPage,
        minPrice: isNewSearch ? minPrice : currentMinPrice,
        maxPrice: isNewSearch ? maxPrice : currentMaxPrice,
        order: isNewSearch ? order : currentOrder,
      );

      if (isNewSearch) {
        searchResults = products;
      } else {
        searchResults.addAll(products);
      }
      // Stop only if the server returns 0 products
      hasMore = products.isNotEmpty;
      if (hasMore) currentPage++;
    } catch (e) {
      errorMessage = "Erreur lors de la recherche des produits";
      if (isNewSearch) searchResults = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Method to search with filters only (keeping the same search term)
  Future<void> applyFilters({
    double? minPrice,
    double? maxPrice,
    String? order,
  }) async {
    if (lastSearch.isNotEmpty) {
      await searchProducts(
        lastSearch,
        isNewSearch: true,
        minPrice: minPrice,
        maxPrice: maxPrice,
        order: order,
      );
    }
  }

  // Method to load more results with current filters
  Future<void> loadMoreResults() async {
    if (lastSearch.isNotEmpty && hasMore && !isLoading) {
      await searchProducts(
        lastSearch,
        isNewSearch: false,
      );
    }
  }

  void clearResults() {
    searchResults = [];
    currentPage = 1;
    hasMore = true;
    lastSearch = "";
    currentMinPrice = null;
    currentMaxPrice = null;
    currentOrder = null;
    notifyListeners();
  }
}
