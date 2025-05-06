import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart'; // Import your Product model

class ProductService {
  final String baseUrl = "REMOVED_SECRET/";

  // Add variables for consumer_key and consumer_secret
  final String consumerKey = "REMOVED_SECRET";
  final String consumerSecret = "REMOVED_SECRET";

  Future<Product> fetchProductById(int productId) async {
    final String endpoint = "products/$productId";
    final String url = "$baseUrl$endpoint";

    try {
      print("Fetching product with ID: $productId");

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

        final Map<String, dynamic> data = json.decode(response.body);

        // Map the data to a Product object
        final product = Product.fromJson(data);

        print(
            "Product ID: ${product.id}, Name: ${product.name}, Price: ${product.price}, Regular Price: ${product.regularPrice}, Image URL: ${product.imageUrls}");

        return product;
      } else {
        print("Failed to load product. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load product: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching product: $e");
      throw Exception("Error fetching product: $e");
    }
  }
}
