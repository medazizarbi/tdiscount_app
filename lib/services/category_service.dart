import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/product_model.dart'; // Import your Product model

class CategoryService {
  final String baseUrl = "REMOVED_SECRET/";

  // Add variables for consumer_key and consumer_secret
  final String consumerKey = "REMOVED_SECRET";
  final String consumerSecret = "REMOVED_SECRET";

  Future<List<Category>> fetchCategories() async {
    final String endpoint =
        "products/categories?parent=0&per_page=8&order=desc&orderby=count";
    final String url = "$baseUrl$endpoint";

    try {
      print("Fetching categories from API: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
        },
      );

      print("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Response body: ${response.body}");

        final List<dynamic> data = json.decode(response.body);

        // Map the data and process categories
        List<Category> categories = data.map((json) {
          final category = Category.fromJson(json);

          // Replace "&amp;" with "&" in category names and create a new Category object
          return Category(
            id: category.id,
            name: category.name.replaceAll("&amp;", "&"),
            // Add other fields from the Category model as needed
          );
        }).toList();

        // Move "Autres catégories" to the end of the list
        categories.sort((a, b) {
          if (a.name == "Autres catégories") return 1;
          if (b.name == "Autres catégories") return -1;
          return 0;
        });

        // Log the processed categories
        for (var category in categories) {
          print("Category ID: ${category.id}, Name: ${category.name}");
        }

        return categories;
      } else {
        print("Failed to load categories. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load categories: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching categories: $e");
      throw Exception("Error fetching categories: $e");
    }
  }

  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final String endpoint = "products?category=$categoryId";
    final String url = "$baseUrl$endpoint";

    try {
      print("Fetching products for category ID: $categoryId");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
        },
      );

      print("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Response body: ${response.body}");

        final List<dynamic> data = json.decode(response.body);

        // Map the data to Product objects
        final products = data.map((json) => Product.fromJson(json)).toList();

        return products;
      } else {
        print("Failed to load products. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load products: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching products: $e");
      throw Exception("Error fetching products: $e");
    }
  }
}
