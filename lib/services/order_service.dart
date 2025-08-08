import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tdiscount_app/models/product_model.dart';

class OrderService {
  String get baseUrl => dotenv.env['WC_BASE_URL'] ?? "";
  String get consumerKey => dotenv.env['WC_CONSUMER_KEY'] ?? "";
  String get consumerSecret => dotenv.env['WC_CONSUMER_SECRET'] ?? "";

  Future<http.Response> createOrder({
    required OrderInfo orderInfo,
    required List<Product> products,
    required Map<int, int> quantities,
  }) async {
    final url = Uri.parse('${baseUrl}orders');

    final List<Map<String, dynamic>> lineItems = products.map((prod) {
      return {
        "product_id": prod.id,
        "name": prod.name,
        "sku": prod.sku ?? "",
        "price": prod.price,
        "quantity": quantities[prod.id] ?? 1,
      };
    }).toList();

    final Map<String, dynamic> body = {
      "billing": {
        "first_name": orderInfo.firstName,
        "last_name": orderInfo.lastName,
        "address_1": orderInfo.address1,
        "city": orderInfo.city,
        "phone": orderInfo.phone,
      },
      "shipping": {
        "first_name": orderInfo.firstName,
        "last_name": orderInfo.lastName,
        "address_1": orderInfo.address1,
        "city": orderInfo.city,
        "phone": orderInfo.phone,
      },
      "customer_note": orderInfo.note,
      "line_items": lineItems,
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    return response;
  }

  Future<List<http.Response>> createOrdersOneByOne({
    required OrderInfo orderInfo,
    required List<Product> products,
    required Map<int, int> quantities,
  }) async {
    List<http.Response> responses = [];
    for (final prod in products) {
      final response = await createOrder(
        orderInfo: orderInfo,
        products: [prod],
        quantities: {prod.id: quantities[prod.id] ?? 1},
      );
      responses.add(response);
    }
    return responses;
  }
}

class OrderInfo {
  final String firstName;
  final String lastName;
  final String address1;
  final String city;
  final String phone;
  final String note;

  OrderInfo({
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.city,
    required this.phone,
    required this.note,
  });
}
