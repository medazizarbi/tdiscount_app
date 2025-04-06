import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<String> _favoriteProductNames = [];

  List<String> get favoriteProductNames => _favoriteProductNames;

  void toggleFavorite(String productName) {
    if (_favoriteProductNames.contains(productName)) {
      _favoriteProductNames.remove(productName);
    } else {
      _favoriteProductNames.add(productName);
    }
    notifyListeners(); // Notify widgets to update
  }

  bool isFavorite(String productName) {
    return _favoriteProductNames.contains(productName);
  }
}
