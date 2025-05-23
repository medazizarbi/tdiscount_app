import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

// ===== Your Category Model =====

class Category {
  final int id;
  final String name;
  final int count;
  final String? description;

  Category({
    required this.id,
    required this.name,
    required this.count,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      count: json['count'] ?? 0,
      description: json['description'],
    );
  }
}

// ===== Testable Service =====

class TestableCategoryService {
  final http.Client client;
  final String consumerKey;
  final String consumerSecret;

  TestableCategoryService({
    required this.client,
    required this.consumerKey,
    required this.consumerSecret,
  });

  Map<String, String> _getAuthHeaders() {
    final basicAuth =
        'Basic ' + base64Encode(utf8.encode('$consumerKey:$consumerSecret'));
    return {
      'Authorization': basicAuth,
      'Content-Type': 'application/json',
    };
  }

  Future<List<Category>> fetchCategories() async {
    final url =
        Uri.parse('https://fakeapi.com/wp-json/wc/v3/products/categories');
    final response = await client.get(url, headers: _getAuthHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((jsonItem) => Category.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

// ===== Test =====

void main() {
  test('Category count is parsed and stored correctly', () async {
    final mockClient = MockClient((request) async {
      return http.Response(
          jsonEncode([
            {
              "id": 1,
              "name": "Fitness",
              "count": 25,
              "description": "All fitness products"
            }
          ]),
          200);
    });

    final service = TestableCategoryService(
      client: mockClient,
      consumerKey: "egzersgge",
      consumerSecret: "dqfffffff",
    );

    final categories = await service.fetchCategories();

    expect(categories, isNotEmpty);
    expect(categories.first.id, 1);
    expect(categories.first.name, "Fitness");
    expect(categories.first.count, 25);
    expect(categories.first.description, "All fitness products");
  });
}
