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

  Future<void> searchProducts(String search, {bool isNewSearch = true}) async {
    if (isLoading) return;
    if (isNewSearch) {
      currentPage = 1;
      hasMore = true;
      searchResults = [];
      lastSearch = search;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // Log when the method is called and the page value
    print(
        '🔎 [SearchViewModel] searchProducts called: page=$currentPage, isNewSearch=$isNewSearch, search="$search"');

    try {
      final products = await _searchService.searchProducts(
        search: search,
        page: currentPage,
        perPage: perPage,
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

  void clearResults() {
    searchResults = [];
    currentPage = 1;
    hasMore = true;
    lastSearch = "";
    notifyListeners();
  }
}
