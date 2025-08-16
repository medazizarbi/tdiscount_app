import 'package:flutter/material.dart';
import 'package:tdiscount_app/models/product_model.dart';
import 'package:tdiscount_app/services/order_service.dart';
import 'package:http/http.dart' as http;

class CreateOrderRequest {
  final String firstName;
  final String lastName;
  final String address1;
  final String city;
  final String phone;
  final String note;
  final List<Product> products;
  final Map<int, int> quantities;

  CreateOrderRequest({
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.city,
    required this.phone,
    required this.note,
    required this.products,
    required this.quantities,
  });

  OrderInfo toOrderInfo() {
    return OrderInfo(
      firstName: firstName,
      lastName: lastName,
      address1: address1,
      city: city,
      phone: phone,
      note: note,
    );
  }
}

class OrderViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  http.Response? lastResponse;

  Future<bool> createOrder(CreateOrderRequest request) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await OrderService().createOrder(
        orderInfo: request.toOrderInfo(),
        products: request.products,
        quantities: request.quantities,
      );
      lastResponse = response;

      if (response.statusCode == 201) {
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        _handleError();
        return false;
      }
    } catch (e) {
      _handleError();
      return false;
    }
  }

  Future<bool> createOrdersOneByOne(CreateOrderRequest request) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final responses = await OrderService().createOrdersOneByOne(
        orderInfo: request.toOrderInfo(),
        products: request.products,
        quantities: request.quantities,
      );

      final allSucceeded = responses.every((res) => res.statusCode == 201);
      lastResponse = responses.isNotEmpty ? responses.last : null;
      isLoading = false;

      if (allSucceeded) {
        notifyListeners();
        return true;
      } else {
        _handleError();
        return false;
      }
    } catch (e) {
      _handleError();
      return false;
    }
  }

  void _handleError() {
    errorMessage = "Désolé, une erreur s'est produite.";
    isLoading = false;
    notifyListeners();
  }
}
