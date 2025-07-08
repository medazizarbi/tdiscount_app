import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tdiscount_app/models/product_model.dart';

class OrderService {
  final String baseUrl = "REMOVED_SECRET/";
  final String consumerKey = "REMOVED_SECRET";
  final String consumerSecret = "REMOVED_SECRET";

  Future<http.Response> createOrder({
    required String firstName,
    required String lastName,
    required String address1,
    required String city,
    required String phone,
    required String note,
    required List<Product> products,
    required Map<int, int> quantities,
  }) async {
    final url = Uri.parse('${baseUrl}orders');

    // Build line_items from products and quantities
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
        "first_name": firstName,
        "last_name": lastName,
        "address_1": address1,
        "city": city,
        "phone": phone,
      },
      "shipping": {
        "first_name": firstName,
        "last_name": lastName,
        "address_1": address1,
        "city": city,
        "phone": phone,
      },
      "customer_note": note,
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

    print('Order POST status: ${response.statusCode}');
    print('Order POST body: ${response.body}');
    return response;
  }

  Future<List<http.Response>> createOrdersOneByOne({
    required String firstName,
    required String lastName,
    required String address1,
    required String city,
    required String phone,
    required String note,
    required List<Product> products,
    required Map<int, int> quantities,
  }) async {
    List<http.Response> responses = [];
    for (final prod in products) {
      final response = await createOrder(
        firstName: firstName,
        lastName: lastName,
        address1: address1,
        city: city,
        phone: phone,
        note: note,
        products: [prod], // Only one product per order
        quantities: {prod.id: quantities[prod.id] ?? 1},
      );
      responses.add(response);
    }
    return responses;
  }
}
