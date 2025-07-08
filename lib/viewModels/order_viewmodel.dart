import 'package:flutter/material.dart';
import 'package:tdiscount_app/models/product_model.dart';
import 'package:tdiscount_app/services/order_service.dart';
import 'package:http/http.dart' as http;

class OrderViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  http.Response? lastResponse;

  Future<bool> createOrder({
    required String firstName,
    required String lastName,
    required String address1,
    required String city,
    required String phone,
    required String note,
    required List<Product> products,
    required Map<int, int> quantities,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await OrderService().createOrder(
        firstName: firstName,
        lastName: lastName,
        address1: address1,
        city: city,
        phone: phone,
        note: note,
        products: products,
        quantities: quantities,
      );
      lastResponse = response;
      if (response.statusCode == 201) {
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = "Désolé, une erreur s'est produite.";
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = "Désolé, une erreur s'est produite.";
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createOrdersOneByOne({
    required String firstName,
    required String lastName,
    required String address1,
    required String city,
    required String phone,
    required String note,
    required List<Product> products,
    required Map<int, int> quantities,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final responses = await OrderService().createOrdersOneByOne(
        firstName: firstName,
        lastName: lastName,
        address1: address1,
        city: city,
        phone: phone,
        note: note,
        products: products,
        quantities: quantities,
      );
      // Check if all orders succeeded (statusCode == 201)
      final allSucceeded = responses.every((res) => res.statusCode == 201);
      lastResponse = responses.isNotEmpty ? responses.last : null;
      isLoading = false;
      if (allSucceeded) {
        notifyListeners();
        return true;
      } else {
        errorMessage = "Désolé, une erreur s'est produite.";
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = "Désolé, une erreur s'est produite.";
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
